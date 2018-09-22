Déclaration par annotations
###########################

Plutôt que de configurer les *beans* d'un contexte d'application dans un fichier
XML, il est possible d'utiliser des annotations fournies par le Spring Framework
ou des annotations standards Java.

L'utilisation des annotations est plus intrusive que le recours à un fichier XML
puisqu'il faut les ajouter dans le code source (et donc avoir accès au code source).
Heureusement, le Spring Framework autorise à mêler les deux techniques. Cela
laisse donc une liberté complète aux développeurs pour définir leur contexte
d'application.

.. _spring_configuration_annotations:

Configuration du support des annotations
****************************************

Par défaut le support des annotations n'est pas activé dans un contexte
d'application. Pour l'activer, il faut utiliser l'élément ``<annotation-config />`` :

.. code-block:: xml
  :caption: Activation de la configuration par annotation

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config />

  </beans>

.. note::

  L'élément ``<annotation-config />`` appartient à l'espace de nom XML
  ``http://www.springframework.org/schema/context``. En effet, il est possible avec le
  Spring Framework de créer et de déclarer des espaces de noms XML afin de faciliter
  la configuration du contexte d'application.

Avec l'élément ``<annotation-config />`` déclaré, il devient possible d'utiliser
les annotations suivantes dans les classes des *beans* :

* `@Required`_
* `@Value`_
* `@Autowired`_
* `@Qualifier`_
* Les annotations officielles Java JSR-250_ (voir plus bas)

L'annotation @Required
**********************

L'annotation `@Required`_ peut être placée sur une méthode *setter* pour indiquer
qu'une dépendance doit être injectée au moment de la configuration du contexte
d'application. Si ce n'est pas le cas, l'initialisation du contexte d'application
échouera avec l'exception BeanInitializationException_.

.. code-block:: java
  :caption: Exemple de déclaration avec l'annotation @Required

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.List;
  import org.springframework.beans.factory.annotation.Required;

  public class Societe {

    private String nom;

    public String getNom() {
      return nom;
    }

    @Required
    public void setNom(String nom) {
      this.nom = nom;
    }

    // ...

  }

L'annotation @Value
*******************

L'annotation `@Value`_ est utilisable sur un attribut ou un paramètre d'un constructeur
pour un type primitif ou un chaîne de caractères. Il donne la valeur par défaut
à injecter :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.List;

  import org.springframework.beans.factory.annotation.Value;

  public class Societe {

    @Value("Ma societe")
    private String nom;

    public String getNom() {
      return nom;
    }

  }

.. note::

  Dans le chapitre sur le :ref:`langage d'expression (SpEL) <spring_spel_annotation>`, nous
  verrons que nous pouvons donner une expression à évaluer pour cette annotation.

L'annotation @Autowired
***********************

L'annotation `@Autowired`_ permet d'activer l'injection automatique de dépendance.
Contrairement au :ref:`mode autowiring en XML <spring_autowiring>`, il n'est pas
possible de définir une stratégie à appliquer. Cette annotation peut être placée
sur un constructeur, une méthode ou directement sur un attribut. Le
Spring Framework va chercher le *bean* du contexte d'application dont
le type est applicable à chaque paramètre du constructeur, aux paramètres de la méthode
ou à l'attribut. La stratégie est donc forcément :ref:`byType <spring_autowiring_bytype>`.

.. code-block:: java
  :caption: Exemple d'utilisation de @Autowired sur un attribut

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import javax.sql.DataSource;

  import org.springframework.beans.factory.annotation.Autowired;

  public class UserDao {
    
    @Autowired
    private DataSource dataSource;
    
    // ..
  }

.. code-block:: java
  :caption: Exemple d'utilisation de @Autowired sur une méthode

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import javax.sql.DataSource;

  import org.springframework.beans.factory.annotation.Autowired;

  public class UserDao {
    
    private DataSource dataSource;
    
    @Autowired
    public void setDataSource(DataSource dataSource) {
      this.dataSource = dataSource;
    }
    
    // ..
  }

.. code-block:: java
  :caption: Exemple d'utilisation de @Autowired sur un constructeur

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import javax.sql.DataSource;

  import org.springframework.beans.factory.annotation.Autowired;

  public class UserDao {
    
    private DataSource dataSource;
    
    @Autowired
    public UserDao(DataSource dataSource) {
      this.dataSource = dataSource;
    }
    
    // ..
  }

.. note::

  L'annotation `@Autowired`_ définit un comportement légèrement différent de
  la stratégie :ref:`byType <spring_autowiring_bytype>`. Si cette annotation
  est employée sur un attribut ou une méthode *setter* et qu'il existe dans
  le contexte d'application plusieurs *beans* du type correspondant, alors
  le Spring Framework va sélectionner le *bean* qui porte le même nom
  que l'attribut ou la propriété.

  Il est cependant préférable d'utiliser l'annotation `@Qualifier`_ pour qualifier
  le type de dépendance.


L'annotation @Qualifier
***********************

L'annotation `@Qualifier`_ permet de qualifier, c'est-à-dire de préciser
le *bean* à injecter. Dans la classe Java, on ajoute l'annotation sur un attribut
ou sur un paramètre d'une méthode à injecter. Dans le fichier de contexte, on
déclare un *bean* compatible avec l'élément ``<qualifier />`` avec la même valeur.

L'annotation `@Qualifier`_ permet de guider le Spring Framework dans le choix
du *bean* à injecter si plusieurs *beans* d'un type compatible sont déclarés
dans le contexte d'application.

.. code-block:: java
  :caption: Utilisation de l'annotation `@Qualifier`_

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.beans.factory.annotation.Autowired;
  import org.springframework.beans.factory.annotation.Qualifier;

  public class UserService {

    private UserFilter blacklistFilter;
    private UserFilter whitelistFilter;

    @Autowired
    public UserService(@Qualifier("blacklist") UserFilter blacklistFilter, 
                       @Qualifier("whitelist") UserFilter whitelistFilter) {
      this.blacklistFilter = blacklistFilter;
      this.whitelistFilter = whitelistFilter;
    }

    // ..
  }

.. code-block:: xml
  :caption: Déclaration des beans avec l'élément <qualifier/>

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd">

    <context:annotation-config/>
    
    <bean name="userService" class="{{ROOT_PKG}}.UserService"/>
      
    <bean class="{{ROOT_PKG}}.UserFilter">
      <qualifier value="whitelist"/>
    </bean>

    <bean class="{{ROOT_PKG}}.UserFilter">
      <qualifier value="blacklist"/>
    </bean>

  </beans>

Les annotations JSR-250
***********************

Indépendamment du Spring Framework, le communauté Java a défini un ensemble
d'annotations dans la spécification JSR-250_. Certaines d'entre-elles sont reconnues
par le Spring Framework :

`@Resource`_
  Cette Annotation peut se substituer à l'annotation `@Autowired`_ sur les attributs
  et les méthode *setter*. Le Spring Framework réalise une injection de dépendance
  basée sur le type attendu. Si l'annotation spécifie un nom grâce à son
  attribut ``name`` alors l'injection de dépendance se fait en cherchant un
  *bean* du même nom.

  ::

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.annotation.Resource;
    import javax.sql.DataSource;

    public class UserDao {

      @Resource(name="dataSource")
      private DataSource dataSource;

      // ..
    }


`@PostConstruct`_
  Cette annotation s'utilise sur une méthode publique afin de signaler que cette
  méthode doit être appelée par le conteneur IoC après l'initialisation du *bean*.

`@PreDestroy`_
  Cette annotation s'utilise sur une méthode publique afin de signaler que cette
  méthode doit être appelée juste avant la fermeture du contexte d'application.

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.sql.Connection;
  import java.sql.SQLException;

  import javax.annotation.PostConstruct;
  import javax.annotation.PreDestroy;
  import javax.annotation.Resource;
  import javax.sql.DataSource;

  public class UserDao {

    @Resource(name="dataSource")
    private DataSource dataSource;

    private Connection connection;
    
    @PostConstruct
    public void openConnection() throws SQLException {
      connection = dataSource.getConnection();
    }
    
    @PreDestroy
    public void closeConnection() throws SQLException {
      connection.close();
    }

    // ...
  }

Détection automatique des beans (*autoscan*)
********************************************

Plutôt que de déclarer les *beans* dans un fichier XML, il est possible de demander
au Spring Framework de rechercher dans les packages les classes qui sont
susceptibles d'être instanciées pour créer des *beans* dans le contexte d'application.
On appelle cette opération le *package scanning*.

Pour activer le *package scanning*, il faut ajouter l'élément ``<component-scan />``
dans le fichier XML de contexte d'application.

.. code-block:: xml
  :caption: Activation du package scanning

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
                        http://www.springframework.org/schema/beans/spring-beans.xsd
                        http://www.springframework.org/schema/context
                        http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="{{ROOT_PKG}}" />

  </beans>

L'attribut ``base-package`` indique le package Java à partir duquel le Spring
Framework doit rechercher les classes à instancier (sous-packages inclus). Il est
possible de mettre en place des
`filtres <https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-scanning-filters>`_
pour paramétrer la recherche de manière fine.

.. note::

  La déclaration de l'élément ``<component-scan />`` implique automatiquement
  une configuration par annotation. Il n'est donc pas nécessaire d'ajouter
  l'élément ``<annotation-config />``.

Le Spring Framework fournit deux annotations de stéréotype : `@Component`_ et
`@Service`_. Un stéréotype désigne le rôle que joue une classe dans l'application.
Les classes ayant des stéréotypes sont instanciées automatiquement par le
Spring Framework pour créer un *bean* dans le contexte d'application.

`@Component`_
  Un composant est un stéréotype générique. Il est possible d'indiquer en attribut
  le nom du *bean*.

`@Service`_
  Un service est un composant qui remplit une fonctionnalité centrale dans l'architecture
  d'une application. Il renvoie aux classes qui ont la charge de réaliser les
  fonctionnalités principales. Il s'agit normalement d'une classe qui ne maintient
  pas d'état conversationnel. Il n'y a pas de différence technique entre
  les annotations `@Component`_ et `@Service`_, Le Spring Framework traite
  les classes annotées par l'une ou l'autre de la même manière. Il s'agit plus
  d'un repère pour les développeurs.

.. code-block:: java
  :caption: Utilisation de l'annotation `@Service`_

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.stereotype.Service;

  @Service
  public class UserService {

    // ...

  }

.. note::

  Il existe trois autres annotations de stéréotypes traitées par des modules Spring :
  `@Repository`_, `@Controller`_ et `@RestController`_. La première s'utilise
  dans le cadre de l'intégration des bases de données avec le module Spring Data
  et les deux dernières sont ajoutées pour le module Spring MVC pour le développement
  d'application Web.

Un *bean* possédant une annotation de stéréotype peut lui-même concourir à créer
de nouveaux *beans* et se comporter ainsi comme une *factory*.
Il suffit pour cela qu'il déclare des méthodes publiques
annotées avec `@Bean`_. Dans ce cas, le nom du *bean* correspond au nom de la méthode :

.. code-block:: java
  :caption: Création d'un bean à partir d'un composant

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.annotation.Bean;
  import org.springframework.stereotype.Service;

  @Service
  public class ProduitService {

    @Bean
    public FacturationService facturationService() {
      return new FacturationService();
    }

  }

Après que le conteneur IoC ait créé une instance de ``ProduitService``, il appellera
la méthode ``facturationService`` pour créer un *bean* appelé "facturationService".

Support de annotations standard JSR-330
***************************************

La communauté Java a proposé des annotations
pour déclarer une dépendance d'injection dans le standard JSR-330. Le Spring Framework
supporte également ces annotations.

.. note::

  La JSR-330 ne fait pas partie de l'API de Java, pour pouvoir l'utiliser vous
  devez ajouter une dépendance dans votre projet Maven :

  .. code-block:: xml

    <dependency>
      <groupId>javax.inject</groupId>
      <artifactId>javax.inject</artifactId>
      <version>1</version>
    </dependency>

`@Inject`_
  Vous pouvez utiliser l'annotation `@Inject`_ au lieu de `@Autowired`_.

  .. todo:: Exemple ici

`@Named`_
  Vous pouvez utiliser l'annotation `@Named`_ au lieu de `@Component`_. L'annotation
  `@Named`_ peut également être utilisée conjointement avec `@Inject`_ pour
  préciser le nom du *bean* à injecter ou son qualificateur (*qualifier*).

  .. todo:: Exemple ici

.. note::

  Pour une comparaison plus poussée entre JSR-330 et le Spring Framework,
  reportez-vous à la
  `documentation de ce dernier <https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-standard-annotations-limitations>`_.


.. _@Bean: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html
.. _@Required: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Required.html
.. _@Value: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Value.html
.. _@Autowired: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Autowired.html
.. _@Qualifier: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Qualifier.html
.. _JSR-250: https://en.wikipedia.org/wiki/JSR_250
.. _BeanInitializationException: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/BeanInitializationException.html
.. _@Resource: https://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html
.. _@PostConstruct: https://docs.oracle.com/javaee/7/api/javax/annotation/PostConstruct.html
.. _@PreDestroy: https://docs.oracle.com/javaee/7/api/javax/annotation/PreDestroy.html
.. _@Component: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Component.html
.. _@Service: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Service.html
.. _@Repository: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Repository.html
.. _@Controller: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/stereotype/Controller.html
.. _@RestController: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html
.. _@Inject: https://docs.oracle.com/javaee/7/api/javax/inject/Inject.html
.. _@Named: https://docs.oracle.com/javaee/7/api/javax/inject/Named.html
