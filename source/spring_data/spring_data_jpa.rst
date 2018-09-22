JPA avec Spring Data
####################

`Spring Data`_ est un projet *Spring* qui a pour objectif de simplifier l'interaction
avec différents systèmes de stockage de données : qu'il s'agisse d'une base de données
relationnelle, d'une base de données NoSQL, d'un système *Big Data* ou encore
d'une API Web.

Le principe de *Spring Data* est d'éviter aux développeurs de coder les accès à
ces systèmes. Pour cela, *Spring Data* utilise une convention de nommage des méthodes
d'accès pour exprimer la requête à réaliser.

Ajout de Spring Data JPA dans un projet Maven
*********************************************

`Spring Data`_ se compose d'un noyau central et de plusieurs sous modules dédiés
à un type de système de stockage et une technologies d'accès. Dans un projet
Maven, pour utiliser *Spring Data* pour une base de données relationnelles avec
JPA, il faut déclarer la dépendance suivante :

.. code-block:: xml

  <dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
    <version>2.0.8.RELEASE</version>
  </dependency>

Notion de repository
********************

*Spring Data* s'organise autour de la notion de *repository*. Il fournit
une interface marqueur générique `Repository<T, ID>`_. Le type **T** correspond
au type de l'objet géré par le *repository*. Le type **ID** correspond au type
de l'objet qui représente la clé d'un objet.

L'interface `CrudRepository<T, ID>`_ hérite de `Repository<T, ID>`_ et fournit
un ensemble d'opérations élémentaires pour la manipulation des objets.

Pour une intégration de *Spring Data* avec JPA, il existe également l'interface
`JpaRepository<T, ID>`_ qui hérite indirectement de `CrudRepository<T, ID>`_ et
qui fournit un ensemble de méthodes pour interagir avec une base de données.

Pour créer un *repository*, il suffit de créer une interface qui hérite d'une
des interfaces ci-dessus.

.. code-block:: java
  :caption: Exemple de création d'un repository JPA
  
  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;

  public interface UserRepository extends JpaRepository<User, Long> {
    
  }

Configuration des repositories
******************************

La façon la plus simple de configurer les *repositories* est d'utiliser l'élément
``repositories`` dans l'espace de nom ``http://www.springframework.org/schema/data/jpa``
dans la déclaration du contexte de l'application :

.. code-block:: xml
  :caption: Configuration des repositories dans le contexte d'application
  :linenos:

  <?xml version="1.0" encoding="UTF-8"?>
  <beans 
    xmlns="http://www.springframework.org/schema/beans"
    xmlns:context="http://www.springframework.org/schema/context"
    xmlns:tx="http://www.springframework.org/schema/tx" 
    xmlns:jpa="http://www.springframework.org/schema/data/jpa"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
                        http://www.springframework.org/schema/beans/spring-beans.xsd
                        http://www.springframework.org/schema/context
                        http://www.springframework.org/schema/context/spring-context.xsd
                        http://www.springframework.org/schema/tx
                        http://www.springframework.org/schema/tx/spring-tx.xsd
                        http://www.springframework.org/schema/data/jpa
                        http://www.springframework.org/schema/data/jpa/spring-jpa.xsd">

    <context:property-placeholder location="classpath:jdbc.properties" />
    <context:component-scan base-package="{{ROOT_PKG}}" />
    <tx:annotation-driven />

    <jpa:repositories base-package="{{ROOT_PKG}}.repositories"
                      enable-default-transactions="false" />

    <bean name="dataSource" class="org.apache.commons.dbcp2.BasicDataSource"
          destroy-method="close">
      <property name="driverClassName" value="${jdbc.driverClassName}" />
      <property name="url" value="${jdbc.url}" />
      <property name="username" value="${jdbc.username}" />
      <property name="password" value="${jdbc.password}" />
    </bean>

    <bean name="transactionManager" class="org.springframework.orm.jpa.JpaTransactionManager" />

    <bean name="entityManagerFactory"
          class="org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean">
      <property name="persistenceUnitName" value="persistenceUnit" />
      <property name="dataSource" ref="dataSource" />
    </bean>

  </beans>

L'exemple précédent montre une configuration complète d'une source de données
locale en utilisant DBCP_ comme gestionnaire de connexions. À la ligne 21, on 
utilise l'élément ``repositories``. Cet élément a, entre autres, les attributs
suivants :

**base-packages**
  Indique le package à partir duquel *Spring Data JPA* recherche des interfaces
  héritant directement ou indirectement de `Repository<T, ID>`_ pour générer les classes
  concrètes. 
  
  .. tip::

    Si vous avez dans votre projet une interface héritant de `Repository<T, ID>`_
    mais que vous ne souhaitez pas que *Spring Data* génère de classe concrète, alors
    vous devez ajouter l'annotation `@NoRepositoryBean`_ sur cette interface.

**enable-default-transaction**
  Signale si une méthode de *repository* est transactionnelle par défaut. Attention,
  cet attribut a la valeur ``true`` par défaut. Si votre projet gère les transactions
  avec *Spring Transaction* en utilisant des classes de service qui délèguent des appels
  aux *repositories*, alors il est plus cohérent de positionner cet attribut à ``false``.

**entity-manager-factory-ref**
  Donne le nom du *bean* de type EntityManagerFactory_ à utiliser. Par convention, si aucune
  valeur n'est précisée avec cet attribut, *Spring Data JPA* recherche dans le contexte
  un *bean* nommé "entityManagerFactory".

**transaction-manager-ref**
  Donne le nom du *bean* de type JpaTransactionManager_ à utiliser. Par convention, si aucune
  valeur n'est précisée avec cet attribut, *Spring Data JPA* recherche dans le contexte
  un *bean* nommé "transactionManager".

À l'initialisation du contexte d'application, *Spring Data JPA* va fournir une implémentation
à toutes les interfaces héritant directement ou indirectement de `Repository<T, ID>`_ et
qui se trouvent dans le package |{{ROOT_PKG}}|.repositories ou un de ses sous-packages.
Ainsi, il est possible d'injecter un *bean* du type de l'interface d'un *repository*,
l'implémentation concrète étant à la charge de *Spring Data JPA*.

.. code-block:: java
  :caption: Exemple d'injection et d'utilisation d'un repository

  package {{ROOT_PKG}}.service;

  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.stereotype.Repository;
  import org.springframework.transaction.annotation.Transactional;

  import {{ROOT_PKG}}.repository.UserRepository;

  @Repository
  public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public void doSomething(long id) {
      long nbUser = userRepository.count();
      boolean exists = userRepository.existsById(id);
      
      // ..
    }
    
  }
  
Ajout de méthodes dans une interface de repository
**************************************************

L'interface `JpaRepository<T, ID>`_ déclare beaucoup de méthodes mais elles suffisent
rarement pour implémenter les fonctionnalités attendues d'une application.
*Spring Data* utilise une convention de nom pour générer automatiquement le code
sous-jacent et exécuter la requête. La requête est déduite de la signature de la
méthode (on parle de *query methods*).

La convention est la suivante : *Spring Data JPA* supprime du début de la méthode
les prefixes *find*, *read*, *query*, *count* and *get* et recherche la présence
du mot *By* pour marquer le début des critères de filtre. Chaque critère doit
correspondre à un paramètre de la méthode dans le même ordre.

.. code-block:: java
  :caption: Exemple de déclaration de *query methods*
  :linenos:
  
  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;

  public interface UserRepository extends JpaRepository<User, Long> {
    
    User getByLogin(String login);
    
    long countByEmail(String email);
    
    List<User> findByNameAndEmail(String name, String email);

    List<User> findByNameOrEmail(String name, String email);

  }

*Spring Data JPA* générera une implémentation pour chaque méthode de ce *repository*.

Pour la méthode *getByLogin*, l'implémentation sera de la forme :

::

  return entityManager.createQuery("select u from User u where u.login = :login", User.class)
                      .setParameter("login", login)
                      .getSingleResult(); 


Pour la méthode *countByEmail*, l'implémentation sera de la forme :

::

  return (Long) entityManager.createQuery("select count(u) from User u where u.email = :email")
                             .setParameter("email", email)
                             .getSingleResult(); 

Pour la méthode *findByNameAndEmail*, l'implémentation sera de la forme :

::

  return entityManager.createQuery("select u from User u where u.name = :name and u.email = :email", User.class)
                      .setParameter("name", name)
                      .setParameter("email", email)
                      .getResultList();

Pour la méthode *findByNameOrEmail*, l'implémentation sera de la forme :

::

  return entityManager.createQuery("select u from User u where u.name = :name or u.email = :email", User.class)
                      .setParameter("name", name)
                      .setParameter("email", email)
                      .getResultList();

.. note::

  Il est même possible de donner des critères sur des entités liées. Ainsi,
  si la classe ``User`` contient une association vers une entité ``Address`` :
  
  ::

    package {{ROOT_PKG}}.service;
  
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.OneToOne;

    @Entity
    public class User {

      @Id
      @GeneratedValue(strategy=GenerationType.IDENTITY)
      private Long id;
        
      @OneToOne
      private Address adress;
          
      // ...
    }
    
  et si l'entité ``Address`` contient un champ ``city`` :

  ::

    package {{ROOT_PKG}}.service;
      
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;

    @Entity
    public class Address {

      @Id
      @GeneratedValue(strategy=GenerationType.IDENTITY)
      private Long id;
        
      private String city;
          
      // ...
    }

  Alors il est possible de définir une méthode dans ``UserRepository`` qui permet
  de filtrer sur la ville de l'adresse :

  ::
  
    List<User> findByAddressCity(String city);

Pour une description complète des règles de nommage existantes pour les *query methods*,
vous pouvez vous reporter à la `documentation officielle <https://docs.spring.io/spring-data/jpa/docs/2.0.8.RELEASE/reference/html/#jpa.query-methods.query-creation>`__.

Requêtes nommées JPA
====================

Avec JPA, il est possible de définir des :ref:`requêtes nommées <jpa_requetes_nommees>`
grâce à l'annotation `@NamedQuery`_.

`Spring Data JPA` utilise une convention pour rechercher les requêtes nommées avec JPA.
La requête doit porter comme nom, le nom de l'entité suivi de ``.`` suivi du nom
de la méthode. Ainsi si on définit une requête nommée sur une entité ``User`` :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import javax.persistence.Entity;
  import javax.persistence.GeneratedValue;
  import javax.persistence.GenerationType;
  import javax.persistence.Id;
  import javax.persistence.NamedQuery;

  @Entity
  @NamedQuery(name="User.findByLogin", query="select u from User u where u.login = :login")
  public class User {

    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    private String login;

    // ...
  }
 
Il faut ensuite déclarer la méthode dans le *repository* assigné à l'entité ``User`` :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;
  import org.springframework.data.repository.query.Param;

  public interface UserRepository extends JpaRepository<User, Long>{
    
    User findByLogin(@Param("login") String login);
    
  }

.. note ::

  Remarquez la présence de l'annotation  `@Param`_ qui permet d'associer le
  paramètre de la méthode au paramètre de la requête nommée.

Utilisation de @Query
=====================

L'annotation `@Query`_ permet de préciser la requête directement sur la méthode
elle-même :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;
  import org.springframework.data.jpa.repository.Query;
  import org.springframework.data.repository.query.Param;

  public interface UserRepository extends JpaRepository<User, Long>{
    
    @Query("select u from User u where u.login = :login")
    User findByLogin(@Param("login") String login);
    
  }

.. note::

  Pour des requêtes avec peu de paramètres, il est possible d'utiliser la notation
  pour désigner un paramètre par un numéro d'ordre dans la requête. Cela évite
  un usage de l'annotation `@Param`_ :
  
  ::

    package {{ROOT_PKG}}.repositories;

    import {{ROOT_PKG}}.service.User;
    import org.springframework.data.jpa.repository.JpaRepository;
    import org.springframework.data.jpa.repository.Query;

    public interface UserRepository extends JpaRepository<User, Long>{
      
      @Query("select u from User u where u.login = ?1")
      User findByLogin(String login);
      
    }

.. note::

  Le comportement par défaut de *Spring Data JPA* est de chercher la présence
  de l'annotation `@Query`_ ou la présence d'une requête nommée JPA. S'il n'en
  existe pas alors *Spring Data JPA* analyse la signature de la méthode pour
  essayer d'en déduire la requête à exécuter.

Déclaration de requêtes de modification
***************************************

Il est possible de créer des *query methods* pour réaliser des modifications
(*update*, *insert*, *delete*). Pour cela, il suffit d'ajouter l'annotation
`@Modifying`_ sur la méthode :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;
  import org.springframework.data.jpa.repository.Modifying;
  import org.springframework.data.jpa.repository.Query;

  public interface UserRepository extends JpaRepository<User, Long>{
    
    @Modifying
    @Query("update User u set u.login = ?2 where u.id = ?1")
    void updateLogin(long id, String login);
    
  }

Implémentation des méthodes de repository
*****************************************

Il est parfois nécessaire de fournir une implémentation d'une ou de plusieurs
méthodes d'un *repository*. Dans ce cas, il faut isoler les méthodes que l'on
souhaite implémenter dans une interface spécifique. Par exemple, on peut
créer l'interface ``UserCustomRepository`` :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;

  public interface UserCustomRepository {
    
    void doSomethingComplicated(User u);

  }

Cette interface est étendue par l'interface du *repository* :

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import org.springframework.data.jpa.repository.JpaRepository;

  public interface UserRepository extends UserCustomRepository, JpaRepository<User, Long>{
    
    
  }

Comme *Spring Data JPA* détecte une interface parente qui n'hérite pas elle-même
de l'interface `Repository<T, ID>`_, il recherche une classe Java portant le même
nom que l'interface avec le suffixe **Impl** dans le même package ou un sous-package.
Si une telle classe existe   alors *Spring Data JPA* tente de créer un *bean*
de cette classe.

.. note::

  La classe d'implémentation ne doit pas porter de stéréotype Spring comme
  `@Component`_ ou `@Repository`_. Par contre, elle peut utiliser toutes les
  autres annotations autorisées par le Spring Framework si le contexte
  d'application est configuré correctement. 

::

  package {{ROOT_PKG}}.repositories;

  import {{ROOT_PKG}}.service.User;
  import javax.persistence.EntityManager;
  import javax.persistence.PersistenceContext;

  public class UserCustomRepositoryImpl implements UserCustomRepository {

    @PersistenceContext
    private EntityManager em;
    
    @Override
    public void doSomethingComplicated(User u) {
      // ...
    }

  }

Le *repository* fonctionnera ainsi par délégation. Lorsque la méthode 
``UserRepository.doSomethingComplicated`` sera appelée, elle déléguera le traitement
à la méthode ``UserCustomRepositoryImpl.doSomethingComplicated``.

.. note::

  Il est tout à fait possible de fournir une implémentation pour une méthode
  déclarée dans l'interface `JpaRepository<T, ID>`_ ou une des interfaces parentes. Pour
  cela, il suffit de déclarer dans l'interface d'implémentation une méthode
  avec la même signature.
  
.. _@NoRepositoryBean: https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/NoRepositoryBean.html
.. _Spring Data: https://docs.spring.io/spring-data/jpa/docs/2.0.8.RELEASE/reference/html/
.. _Repository<T, ID>: https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/Repository.html
.. _CrudRepository<T, ID>: https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html
.. _JpaRepository<T, ID>: https://docs.spring.io/spring-data/jpa/docs/2.0.8.RELEASE/api/org/springframework/data/jpa/repository/JpaRepository.html
.. _DBCP: https://commons.apache.org/proper/commons-dbcp/apidocs/index.html
.. _EntityManagerFactory: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManagerFactory.html
.. _JpaTransactionManager: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/orm/jpa/JpaTransactionManager.html
.. _@NamedQuery: https://docs.oracle.com/javaee/7/api/javax/persistence/NamedQuery.html
.. _@Param: https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/query/Param.html
.. _@Query: https://docs.spring.io/spring-data/jpa/docs/2.0.8.RELEASE/api/org/springframework/data/jpa/repository/Query.html
.. _@Modifying: https://docs.spring.io/spring-data/jpa/docs/2.0.8.RELEASE/api/org/springframework/data/jpa/repository/Modifying.html
.. _@Component: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html
.. _@Repository: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Repository.html



