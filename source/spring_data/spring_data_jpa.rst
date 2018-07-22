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
  
  package ROOT_PKG.repositories;

  import ROOT_PKG.service.User;
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
    <context:component-scan base-package="ROOT_PKG" />
    <tx:annotation-driven />

    <jpa:repositories base-package="ROOT_PKG.repositories"
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
utilise l'élément ``repositories``. Cet élément a, entre autres, les attibuts
suivants :

**base-packages**
  Indique le package à partir duquel *Spring Data* recherche des interfaces
  héritant directement ou indirectement de Repository_ pour générer les classes
  concrètes. Si vous avez dans votre projet une interface héritant de Repository_
  mais que vous ne souhaitez pas que *Spring Data* génère de classe concrète, alors
  vous devez ajouter l'annotation `@NoRepositoryBean`_ sur cette interface.

**enable-default-transaction**
  Signale si une méthode de *repository* est transactionnelle par défaut. Attention,
  cet attribut a la valeur ``true`` par défaut. Si votre projet gère les transactions
  avec *Spring Transaction* en utilisant des classes de service qui délèguent des appels
  aux *repositories*, alors il est plus cohéret de positionner cet attribut à ``false``.

**transaction-manager-ref**
  Donne le nom du *bean* de type JpaTransactionManager_. Par convention, si aucune
  valeur n'est précisée avec cet attribut, *Spring Data* recherche dans le context
  une *bean* nommé "transactionManager".

À l'initialisation du contexte d'applicaion, *Spring Data* va fournir une implémentation
à toutes les interfaces héritant directement ou indirectement de Repository_ et
qui se trouve dans le package |ROOT_PKG|.repositories ou un de ses sous-packages.
Donc, il est possible d'injecter un *bean* du type de l'interface d'un *repository*.

.. code-block:: java
  :caption: Exemple d'injection et d'utilisation d'un repository

  package ROOT_PKG.service;

  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.stereotype.Repository;
  import org.springframework.transaction.annotation.Transactional;

  import ROOT_PKG.repository.UserRepository;

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

.. todo::

  * ajout de méthodes dans les repositories
  * paramètres nommés dans les méthodes
  * utilisation de query nommé (JPA et @Query)
  * implémentation de certaines méthodes de repositories

.. _@NoRepositoryBean: https://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/NoRepositoryBean.html
