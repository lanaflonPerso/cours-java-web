Spring DAO
##########

DAO (*Data Access Object*) est une responsabilité qui est souvent utilisée dans
les applications d'entreprise. Dans le code source d'une application, on peut
trouver des classes nommées ``UserDao``, ``ProducDao``... Ce suffixe "Dao" dénote
que la classe a pour responsabilité d'accéder au système d'information pour lire
ou modifier des données. Comme la plupart des applications d'entreprise stockent
leurs données dans une base de données, les classes DAO sont donc les classes
qui contiennent le code qui permet d'échanger des informations avec la base de données.
En Java, selon la technologie utilisée, il peut s'agir des classes qui utilisent
l'API JDBC ou JPA par exemple.

Spring DAO reprend ce principe d'architecture en cherchant à simplifier l'intégration
et l'implémentation des interactions avec les bases de données.

L'annotation @Repository
************************

Le Spring Framework fournit des stéréotypes pour marquer le rôle des classes.
Le stéréotype le plus général est `@Component`_.
Il est également possible d'utiliser l'annotation `@Repository`_ pour indiquer qu'une
classe sert de point d'accès à un mécanisme de stockage et de recherche d'une
collection d'objets. La notion de *repository* vient de l'ouvrage de Eric
Evans (*Domain Driven Development*)

::

  package ROOT_PKG.repository;

  import org.springframework.stereotype.Repository;

  @Repository
  public class UserService {

    public void save(User user) {
      // ...
    }

    public User getById(long id) {
      // ...
    }

  }

Intégration de JPA
******************

Pour une application utilisant JPA et qui accepte la 
:ref:`configuration par annotations <spring_configuration_annotations>`, il est
possible d'injecter un EntityManager_ dans un *repository* grâce à l'annotation
`@Autowired`_, `@Inject`_ et même `@PersistenceContext`_ (qui est l'annnotation
standard de Java EE).

::

  package ROOT_PKG.repository;

  import javax.persistence.EntityManager;
  import javax.persistence.PersistenceContext;

  import org.springframework.stereotype.Repository;

  @Repository
  public class UserService {

    @PersistenceContext
    private EntityManager entityManager;

    public void save(User user) {
      // ...
    }

    public User getById(long id) {
      // ...
    }

  }

.. note::

  Pour activer JPA, il faut configurer le contexte d'application avec
  :ref:`un gestionnaire de transaction JPA <spring_tx_transaction_jpa>`.

Uniformité de la hiérarchie des exceptions
******************************************

Un apport du module *Spring Data Access* est d'uniformiser la hiérarchie des exceptions.
En effet, l'API de base d'accès aux données, JDBC, utilise des exceptions héritant
de SQLException_ qui est une *checked* exception. JPA utilise des *unechecked*
exceptions héritant de PersistenceException_. *Spring Data* offre également
d'autres formes d'accès à des données (comme la lecture de fichier XML) qui
signalent également des erreurs avec d'autres hiérarchies d'exception.

Pour simplifier la gestion des exceptions, *Spring Data Access* propose une
hiérarchie unique d'exceptions pour toutes ces technologies afin de simplifier
la gestion des erreurs pour les applications.

.. image:: assets/spring_data_exceptions.png
  :alt: Hiérarchie des exceptions

La classe DataAccessException_ est une *checked* exception.

Pour une application utilisant JPA, l'uniformisation de la hiérarchie des exceptions
n'est pas activée par défaut. Pour l'activer, il faut utiliser l'annotation
`@Repository`_ et déclarer dans le contexte d'application un *bean* de type
PersistenceExceptionTranslationPostProcessor_.

.. code-block:: xml

  <bean class="org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor" />

.. todo::

  * utilisation du jdbcTemplate (hiérarchie des exceptions)
  * gestion de la datasource dans le container ou locale

.. _EntityManager: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManager.html
.. _SQLException: https://docs.oracle.com/javase/8/docs/api/java/sql/SQLException.html
.. _PersistenceException: https://docs.oracle.com/javaee/7/api/javax/persistence/PersistenceException.html
.. _@Repository: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Repository.html
.. _@Component: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Component.html
.. _@Autowired: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Autowired.html
.. _@Inject: https://docs.oracle.com/javaee/7/api/javax/inject/Inject.html
.. _@PersistenceContext: https://docs.oracle.com/javaee/7/api/javax/persistence/PersistenceContext.html
.. _DataAccessException: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/dao/DataAccessException.html
.. _PersistenceExceptionTranslationPostProcessor: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/dao/annotation/PersistenceExceptionTranslationPostProcessor.html

