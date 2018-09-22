Les EJB
#######

Les Enterprise Java Beans (EJB) sont des composants Java EE fournis par
les développeurs d'application. Ils sont définis par la `JSR
318 <https://www.jcp.org/en/jsr/detail?id=318>`__. Ils encapsulent la
logique de traitement de l'application (également appelée logique
métier).

À travers les EJB, le développeur dispose de services fournis par le
conteneur EJB tels que :

-  modèle d'exécution thread-safe
-  gestion du cycle de vie des instances pour une meilleure scalabilité
-  accés aux services Java EE par injection
-  gestion des transactions
-  contrôle des droits d'accès pour l'invocation des méthodes
-  gestion des traitements asynchrones
-  accès distant pour un client à travers une interface remote

Avec les EJB, nous abordons les composants qui ne sont plus liés à la
présentation Web. Les EJB ont une longue histoire depuis J2EE jusqu'à
leur version 3 actuelle dans Java EE. Ils peuvent être utilisés dans de
nombreux contextes applicatifs. Ils ont aussi été ignorés par une grande
partie des développeurs Java. Dans le cadre de cours, nous nous
bornerons à aborder le modèle de threading et le support de la
transaction supportés par les EJB.

Le conteneur d'EJB
******************

Nous avons vu que le cycle de vie des Servlets et les JSP est pris en
charge par un conteneur de Servlet. De même, le serveur d'application
fournit un conteneur d'EJB qui a la responsabilité de gérer le cycle de
vie des composants EJB fournis par les développeurs d'application.

Les types d'EJB
===============

On distingue plusieurs types d'EJB :

Les EJB de session
    *Stateful* EJB, *Stateless* EJB et *Singleton* EJB qui sont adaptés pour
    le traitement synchrone. Il s'agit des EJB les plus courants dans
    une application Web.
Les EJB orientés message
    *Message Driven Bean* qui est adapté pour le traitement asynchrone. On
    utilise généralement cet EJB dans des applications de type bus
    d'entreprise ou MOM (Middleware Orienté Messages).
Les Entity Beans
    Les EJB pour gérer la persistance. Il s'agit des composants Java EE qui représentent
    les données d'un modèle relationnel de base de données. Depuis EJB 3, l'API JPA définit
    les entity beans.

.. only:: not ejb_complet

.. note::

    Ce cours ne couvre pas les Message Driven Beans.

Les EJB session
***************

Un EJB session correspond à une classe Java classique (POJO). Il existe
cependant trois types d'EJB session qui correspondent à des modèles
d'exécution concurrente (**threading model**) :

-  les EJB avec état conversationnel (*stateful*)
-  les EJB sans état conversationnel (*stateless*)
-  les EJB singleton (*singleton*)

En effet, dans un serveur Java EE, une application est exécutée dans un
environnement concurrent. Nous avons vu déjà les problèmes que cela pose
pour le développement des Servlets ou pour le choix de la portée
(request, session, application) pour un back bean JSF. La distinction
entre les EJB session porte sur la façon dont chacun se comporte dans un
environnement concurrent.

EJB session stateful
********************

L'EJB session *stateful* (avec état conversationnel) est créé pour
représenter une interaction entre le client et le serveur. Cela signifie
qu'il existe une instance par interaction. Il s'agit du cas le plus
simple pour le développeur puisqu'il n'y a pas de problème de
concurrence entre les clients (chacun disposant de sa propre instance).
Il s'agit cependant du cas le plus complexe à gérer pour le conteneur
d'application Java EE. Un cas d'utilisation consiste à utiliser un EJB
session comme backing bean JPA.

.. code-block:: java
    :caption: EJB stateful : le panier de l'utilisateur

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Stateful;

    @Stateful
    public class UserBasket {
      private List<Item> items = new ArrayList<>();

      public void addItem(Item i) {
        items.add(i);
      }

      // ...
    }

L'exemple traditionnel du panier sur un site marchand correspond à une
utilisation classique de l'EJB session. Chaque utilisateur dispose de
son instance de panier. Cette instance est conservée tant que la session
de l'utilisateur existe. De plus, on peut conserver des informations
propres à l'utilisateur comme membres de l'EJB (dans cet exemple la
liste des items) : d'où le nom de *stateful*.

Il est possible de fournir une méthode qui supprime l'EJB du conteneur. Une
telle méthode doit être annotée avec `@Remove`_ :

.. code-block:: java
    :caption: EJB stateful : ajout d'une méthode de suppression

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Stateful;
    import javax.ejb.Remove;

    @Stateful
    public class UserBasket {
      private List<Item> items = new ArrayList<>();

      public void addItem(Item i) {
        items.add(i);
      }
      
      @Remove
      public void supprimer() {
        items.clear();
      }

      // ...
    }

EJB session stateless
*********************

L'EJB session *stateless* (sans état conversationnel) représente des
traitements de l'application indépendants de l'état entre le client et
le serveur. N'importe quel utilisateur peut avoir recours à un EJB
*stateless* et donc, il **ne faut pas** stocker dans un EJB *stateless*
d'information liée à la requête où à la session d'un utilisateur. On
retrouve ainsi les mêmes restrictions que pour le développement de
Servlet. Néanmoins, les EJB *stateless* fournissent un modèle d'exécution
concurrent (threading model) sûr. En effet, le conteneur d'EJB crée un
pool d'instances pour chaque classe d'EJB *stateless*. Ainsi à un instant
T, toutes les requêtes qui s'exécutent en parallèle sur un serveur
utilisent une instance particulière d'un EJB *stateless*. Lorsque la
requête est achevée, le conteneur d'EJB récupère l'instance de l'EJB
*stateless* dans le pool afin de la réutiliser pour le traitement d'une
requête à venir. Lorsqu'on développe un EJB *stateless*, il n'est donc pas
nécessaire de protéger le code contre les accès concurrents.

.. code-block:: java
    :caption: EJB stateless : l'implémentation d'un repository

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Stateless;

    @Stateless
    public class IndividuRepository {

      public void add(Individu i) {
        // ...
      }

      // ...
    }

EJB session singleton
*********************

L'EJB singleton permet d'implémenter une ressource réellement partagée
dans une application. Le conteneur EJB garantit qu'il ne créera
qu'\ **UNE** instance d'un EJB singleton pour une application.

.. code-block:: java
    :caption: EJB singleton : la gestion d'une ressource unique

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.*;

    @Singleton
    @Lock(LockType.WRITE)
    public class SharedResource {

      @Lock(LockType.READ)
      public void doSomething() {
        // ...
      }
    }

L'annotation
`@Lock <https://docs.oracle.com/javaee/7/api/javax/ejb/Lock.html>`__
permet de contrôler si l'instance ou une méthode autorise des accès
concurrents (lock de type READ) ou des accès avec acquisition d'un
verrou (lock de type WRITE).

L'utilisation d'un verrou (lock de type WRITE) est équivalent au mot-clé
``synchronized`` en Java. C'est-à-dire qu'à un instant T, un seul thread
peut exécuter le code d'une méthode.

Par défaut, un EJB singleton dispose d'un verrou en écriture pour toutes
ses méthodes (lock de type write).

**Attention**, l'utilisation d'un EJB singleton est souvent dictée par
un soucis de performance. Mais si cet EJB utilise systématiquement un
verrou en écriture, l'application peut subir des dégradations de
performance puisqu'un seul thread à la fois (et donc une seule requête
Web par exemple) peut appeler une méthode de cet EJB.

Méthodes de cycle de vie
************************

Un EJB peut être tenu informé de l'évolution de son cycle de vie par le
conteneur. Pour cela, il peut déclarer des méthodes publiques qui ne prennent
aucun paramètre avec une des annotations suivantes :

`@PostConstruct`_
  Les méthodes annotées avec `@PostConstruct`_ sont invoquées par le conteneur
  sur toutes les nouvelles instances de *beans*. L'appel est réalisé juste après
  que l'injection des dépendances soit réalisée.

`@PreDestroy`_
  Les méthodes annotées avec `@PreDestroy`_ sont invoquées par le conteneur après
  les méthodes annotées avec `@Remove`_ et avant que le conteneur supprime l'instance
  du *bean*

`@PostActivate`_
  Les méthodes annotées avec `@PostActivate`_ sont invoquées par le conteneur après
  après que le *bean* soit chargé depuis la zone de stockage.

`@PrePassivate`_
  Les méthodes annotées avec `@PrePassivate`_ sont invoquées par le conteneur 
  avant que le *bean* soit placé depuis la zone de stockage.

.. note::

  La passivation et l'activation sont des opérations liées au cycle de vie particulier
  des EJB session avec état conversationnel (*stateful EJB*). Un conteneur
  peut décider de *passiver*, c'est-à-dire de stocker sur disque un *stateful EJB*.
  L'opération inverse s'appelle l'activation. Cela permet à une instance d'un EJB
  de sauvegarder son état lors d'un redémarrage du serveur ou lorsque le conteneur
  décide de libérer une partie de la mémoire.

Accès à un EJB session
**********************

Pour avoir accès à une instance d'un EJB session, une application **ne
la crée pas**, elle demande au conteneur EJB de la lui fournir par
injection.

La méthode la plus simple, consiste à utiliser l'annotation
`@EJB`_ sur un
attribut d'un autre composant Java EE (Servlet, bean CDI ou même EJB).

.. code-block:: java
    :caption: Injection d'une instance d'EJB session

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import java.io.IOException;

    import javax.ejb.EJB;
    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    @WebServlet("/MyServlet")
    public class MyServlet extends HttpServlet {

      @EJB
      private IndividuRepository individuRepository;

      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws ServletException, IOException {
        // ...
      }

    }

.. only:: jsf

    Pour utiliser un EJB comme backing bean JSF, il doit également disposer
    de l'annotation ``@Named`` exploitée par le service CDI. Et de
    l'annotation précisant la portée du bean (requête, session ou
    application)

    .. code-block:: java
        :caption: Un EJB utiliser comme backing bean JSF

      {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

        import javax.ejb.Stateful;
        import javax.enterprise.context.SessionScoped;
        import javax.inject.Named;

        @Stateful
        @SessionScoped
        @Named
        public class UserBasket {

          // ...

        }


EJB et interface métier
***********************

Plutôt que de référencer la classe de l'EJB, il est possible de passer
par une interface que l'on appelle l'interface métier de l'EJB. On distingue
les interfaces locales (*local interfaces*) et les interfaces distantes
(*remote interfaces*). En effet, un EJB peut être injecté dans un autre composant
dans un autre composant Java EE de l'application mais il peut également être
accessible à distance (à travers le protocole de communication RMI par exemple).
La déclaration d'une interface locale et d'une interface distante est très similaire.
Si vous n'avez pas besoin de donner accès à un EJB à une application distante, alors
l'utilisation d'une interface locale suffit et elle évite au conteneur d'avoir
à gérer le service d'accès à distance.

Pour déclarer une interface locale, il suffit de faire implémenter une interface
Java à la classe de l'EJB et d'ajouter l'annotation `@Local`_ sur l'interface
et sur l'EJB lui-même pour préciser le type de l'interface.


.. code-block:: java
    :caption: L'interface locale

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Local;

    @Local
    public interface IndividuRepository {

	    void add(Individu i);

    }


.. code-block:: java
    :caption: L'implémentation de l'EJB

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Local;
    import javax.ejb.Stateless;

    @Stateless
    @Local(IndividuRepository.class)
    public class IndividuRepositoryBean implements IndividuRepository {

	    @Override
	    public void add(Individu i) {
		    // ...
	    }

	    // ...
    }

Plutôt que de référencer l'EJB, il est possible de demander l'injection
en déclarant un attribut annoté `@EJB`_ du type de l'interface ``IndividuRepository`` 

::

    @EJB
    private IndividuRepository individuRepository;


Pour une interface distante, le mécanisme est identique mais on utilise l'annotation
`@Remote`_ à la place de `@Local`_ :

.. code-block:: java
    :caption: L'interface distante

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Remote;

    @Remote
    public interface IndividuRepository {

	    void add(Individu i);

    }


.. code-block:: java
    :caption: L'implémentation de l'EJB

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.Remote;
    import javax.ejb.Stateless;

    @Stateless
    @Remote(IndividuRepository.class)
    public class IndividuRepositoryBean implements IndividuRepository {

	    @Override
	    public void add(Individu i) {
		    // ...
	    }

	    // ...
    }


La gestion des transactions
***************************


Un service intéressant dans l'utilisation des EJB est la prise en charge
du support transactionnel sur chacune de leur méthode. Il est ainsi
possible de gérer automatiquement les transactions JTA (Java Transaction
API).

.. _jta_ref:

JTA (Java Transaction API)
==========================

Le recours aux transactions ne se limite pas aux systèmes de base de données.
N'importe quel service logiciel peut fournir un support à la transaction. Quand
plusieurs systèmes transactionnels sont inclus au sein d'une même transaction,
il peut être nécessaire d'avoir recours à une transaction distribuée pour les
synchroniser.

Pour ces raisons, Java EE fournit une API dédiée uniquement à la gestion des
transactions : **JTA**. Cette API est indépendante de JDBC et elle est aussi plus
complète (et donc plus compliquée). TomEE nous laisse le choix de gérer les
transactions avec **JTA** ou avec JDBC pour les *DataSources*. Le paramètre
*JtaManaged* disponible dans la balise *Resource* permet d'indiquer si l'on
souhaite ou non qu'une DataSource_ soit gérable avec **JTA**.
Nous reviendrons sur **JTA** lorsque nous parlerons de JPA et des EJB.

.. _demarcation_transactionnelle:

La démarcation transactionnelle
===============================

Le conteneur EJB prend en charge les transactions JTA en utilisant
un appel de méthode comme démarcation transactionnelle :
lors de l'appel d'une méthode d'un EJB, le conteneur
commence une transaction JTA et, au retour de la méthode, le conteneur
effectue un commit ou un rollback.

Deux annotations permettent de déclarer le support transactionnel pour
les EJB :

`@TransactionManagement <https://docs.oracle.com/javaee/7/api/javax/ejb/TransactionManagement.html>`__
    Définit si la transaction est gérée par le conteneur (valeur
    CONTAINER par défaut) ou si la transaction est gérée par le bean
    lui-même (valeur BEAN). Une transaction gérée par le bean signifie
    que le développeur souhaite gérer la transaction par programmation.
`@TransactionAttribute <https://docs.oracle.com/javaee/7/api/javax/ejb/TransactionAttribute.html>`__
    Permet de déclarer sous quelle condition une transaction gérée par
    le conteneur peut être démarrée lors de l'appel à une méthode de
    l'EJB. Pour plus d'information, on se reportera à la documentation
    de l'énumération
    `TransactionAttributeType <https://docs.oracle.com/javaee/7/api/javax/ejb/TransactionAttributeType.html>`__
    qui est spécifiée dans cette annotation. Si l'annotation est omise,
    cela signifie que la transaction est de type ``REQUIRED``.
    ``REQUIRED`` signifie que si une transaction existe au moment de
    l'appel à la méthode, elle est utilisée ou sinon une nouvelle
    transaction est démarrée.

.. code-block:: java
    :caption: Transaction gérée par le conteneur

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.*;

    @Stateless
    // Il s'agit de la valeur par défaut
    @TransactionManagement(TransactionManagementType.CONTAINER)
    // Il s'agit de la valeur par défaut
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public class IndividuRepository {

      public void add(Individu i) {
        // ...
      }

      // ...
    }

Même si vous ne positionnez pas d'annotation pour la gestion de
transaction sur un EJB session, ce service est tout de même activé.

Le développeur d'EJB peut décider de gérer la transaction par
programmation grâce à l'objet
`UserTransaction <https://docs.oracle.com/javaee/7/api/javax/transaction/UserTransaction.html>`__
injecté par le conteneur grâce à l'annotation
`@Resource <https://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html>`__.
Dans ce cas, l'utilisation de l'annotation ``@TransactionManagement``
est obligatoire pour indiquer au conteneur que l'EJB gère lui-même les
transactions.

.. code-block:: java
    :caption: Transaction gérée par le bean

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.*;
    import javax.annotation.Resource;
    import javax.transaction.UserTransaction;

    @Stateless
    // signale que la transaction est gérée dans le code de l'EJB
    @TransactionManagement(TransactionManagementType.BEAN)
    public class IndividuRepository {
      @Resource
      private UserTransaction tx;

      public void add(Individu i) {
        // démarrer la transaction
        tx.begin();
        // ...
        // commiter la transaction
        tx.commit();
      }

      // ...
    }

Dans le cas d'une gestion des transactions par le conteneur, une
transaction **sera rollbackée** si :

-  la méthode de l'EJB se termine par une exception runtime
-  la méthode de l'EJB se termine par une exception portant l'annotation
   `@ApplicationException <https://docs.oracle.com/javaee/7/api/javax/ejb/ApplicationException.html>`__
   avec l'attribut **rollback** avec la valeur true

Dans tous les autres cas, la transaction est **commitée**.

L'exception ci-dessous provoque un rollback de la transaction gérée par
le conteneur lorsqu'elle est jetée lors de l'exécution d'une méthode
d'EJB.

.. code-block:: java
    :caption: Une exception applicative provoquant un rollback

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.ejb.ApplicationException;

    @ApplicationException(rollback = true)
    public class ArticleNotAvailableException extends Exception {

      // ...

    }

.. _DataSource: https://docs.oracle.com/javase/8/docs/api/javax/sql/DataSource.html
.. _@PostConstruct: https://docs.oracle.com/javaee/7/api/javax/annotation/PostConstruct.html
.. _@PreDestroy: https://docs.oracle.com/javaee/7/api/javax/annotation/PreDestroy.html
.. _@PostActivate: https://docs.oracle.com/javaee/7/api/javax/ejb/PostActivate.html
.. _@PrePassivate: https://docs.oracle.com/javaee/7/api/javax/ejb/PrePassivate.html
.. _@Remove: https://docs.oracle.com/javaee/7/api/javax/ejb/Remove.html
.. _@EJB: https://docs.oracle.com/javaee/7/api/javax/ejb/EJB.html
.. _@Local: https://docs.oracle.com/javaee/7/api/javax/ejb/Local.html
.. _@Remote: https://docs.oracle.com/javaee/7/api/javax/ejb/Remote.html

