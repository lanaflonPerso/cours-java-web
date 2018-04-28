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
    Stateful EJB, Stateless EJB et Singleton EJB qui sont adaptés pour
    le traitement synchrone. Il s'agit des EJB les plus courants dans
    une application Web.
Les EJB orientés message
    Message Driven Bean qui est adapté pour le traitement asynchrone. On
    utilise généralement cet EJB dans des applications de type bus
    d'entreprise ou MOM (Middleware Orienté Messages).
Les Entity Bean
    Les EJB pour gérer la persistance. Il s'agit des composants Java qui représente
    les données d'un modèle relationnel de base de données. Depuis EJB 3, l'API JPA définit
    les entity beans.

.. note::

    Ce cours ne couvre pas les Message Driven Beans.

Les EJB session
***************

Un EJB session correspond à une classe Java classique (POJO). Il existe
cependant trois types d'EJB session qui correspondent à des modèles
d'exécution concurrente (**threading model**) :

-  les EJB avec état conversationnel (stateful)
-  les EJB sans état conversationnel (stateless)
-  les EJB singleton (singleton)

En effet, dans un serveur Java EE, une application est exécutée dans un
environnement concurrent. Nous avons vu déjà les problèmes que cela pose
pour le développement des Servlets ou pour le choix de la portée
(request, session, application) pour un back bean JSF. La distinction
entre les EJB session porte sur la façon dont chacun se comporte dans un
environnement concurrent.

EJB session stateful
********************

L'EJB session stateful (avec état conversationnel) est créé pour
représenter une interaction entre le client et le serveur. Cela signifie
qu'il existe une instance par interaction. Il s'agit du cas le plus
simple pour le développeur puisqu'il n'y a pas de problème de
concurrence entre les clients (chacun disposant de sa propre instance).
Il s'agit cependant du cas le plus complexe à gérer pour le conteneur
d'application Java EE. Un cas d'utilisation consiste à utiliser un EJB
session comme backing bean JPA.

.. code-block:: java
    :caption: EJB stateful : le panier de l'utilisateur

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
liste des items) : d'où le nom de stateful.

EJB session stateless
*********************

L'EJB session stateless (sans état conversationnel) représente des
traitements de l'application indépendants de l'état entre le client et
le serveur. N'importe quel utilisateur peut avoir recours à un EJB
stateless et donc, il **ne faut pas** stocker dans un EJB stateless
d'information liée à la requête où à la session d'un utilisateur. On
retrouve ainsi les mêmes restrictions que pour le développement de
Servlet. Néanmoins, les EJB stateless fournissent un modèle d'exécution
concurrent (threading model) sûr. En effet, le conteneur d'EJB crée un
pool d'instances pour chaque classe d'EJB stateless. Ainsi à un instant
T, toutes les requêtes qui s'exécutent en parallèle sur un serveur
utilisent une instance particulière d'un EJB stateless. Lorsque la
requête est achevée, le conteneur d'EJB récupère l'instance de l'EJB
stateless dans le pool afin de la réutiliser pour le traitement d'une
requête à venir. Lorsqu'on développe un EJB stateless, il n'est donc pas
nécessaire de protéger le code contre les accès concurrents.

.. code-block:: java
    :caption: EJB stateless : l'implémentation d'un repository

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

Accès à un EJB session
**********************

Pour avoir accès à une instance d'un EJB session, une application **ne
la crée pas**, elle demande au conteneur EJB de la lui fournir par
injection.

La méthode la plus simple, consiste à utiliser l'annotation
`@EJB <https://docs.oracle.com/javaee/7/api/javax/ejb/EJB.html>`__ sur un
attribut d'un autre composant Java EE (Servlet, bean CDI ou même EJB).

.. code-block:: java
    :caption: Injection d'une instance d'EJB session

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

        import javax.ejb.Stateful;
        import javax.enterprise.context.SessionScoped;
        import javax.inject.Named;

        @Stateful
        @SessionScoped
        @Named
        public class UserBasket {
          
          // ...

        }

La gestion des transactions
***************************

Un service intéressant dans l'utilisation des EJB est la prise en charge
du support transactionnel sur chacune de leur méthode. Il est ainsi
possible de gérer automatiquement les transactions JTA (Java Transaction
API) en utilisant un appel de méthode comme démarcation
transactionnelle : lors de l'appel d'une méthode d'un EJB, le conteneur
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

    import javax.ejb.ApplicationException;

    @ApplicationException(rollback = true)
    public class ArticleNotAvailableException extends Exception {
      
      // ...

    }

