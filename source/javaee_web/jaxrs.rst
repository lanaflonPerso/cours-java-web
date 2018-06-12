Les API Web avec JAX-RS
#######################

`JAX-RS <https://jax-rs-spec.java.net/>`__ est l'API conçue pour
implémenter des API Web (aussi appelées Web Services RESTful). Les API
Web exploitent les possibilités du protocole HTTP pour permettre à des
systèmes d'information de communiquer et de s'échanger des services.
JAX-RS est donc une API de programmation pour implémenter rapidement des
applications basées sur HTTP. Ainsi, comme nous le verrons plus loin,
son utilisation n'est pas réservée à l'implémentation de services mais
il peut tout aussi bien être utilisé pour développer des applications
Web plus traditionnelles.

JAX-RS 2.x est défini par la `JSR
339 <https://jcp.org/en/jsr/detail?id=339>`__. Comme pour tous les
services et toutes API Java EE, il existe plusieurs implémentations de
cette spécification : `Jersey <https://jersey.java.net/>`__
(l'implémentation de référence),
`RestEasy <http://resteasy.jboss.org/>`__ (intégré dans le serveur Wildfly), `Apache
CXF <https://cxf.apache.org/docs/jax-rs.html>`__.

La notion de ressource
**********************

Dans le Web, ce qui est désigné par une URI est appelé une
**ressource**. Une ressource offre une interface uniforme qui est
définie dans HTTP par l'ensemble des méthodes : GET, HEAD, POST, PUT,
DELETE, OPTIONS... Un client HTTP positionne dans sa requête une méthode
pour indiquer le type d'opération que le serveur doit effectuer sur la
ressource.

`GET <http://tools.ietf.org/html/rfc7231#section-4.3.1>`__
    Demande au serveur une représentation de la ressource cible.
`HEAD <http://tools.ietf.org/html/rfc7231#section-4.3.2>`__
    Comme un GET sauf que la réponse ne contient jamais de corps. Cette
    méthode est utile pour obtenir les informations des en-têtes HTTP et
    valider une requête sans envoyer ni recevoir de corps de message.
`PUT <http://tools.ietf.org/html/rfc7231#section-4.3.4>`__
    Crée ou met à jour l'état d'une ressource identifiée par l'URI.
`DELETE <http://tools.ietf.org/html/rfc7231#section-4.3.5>`__
    Détruit l'association de l'URI avec l'état de la ressource.
`POST <http://tools.ietf.org/html/rfc7231#section-4.3.3>`__
    La sémantique de la méthode POST est probablement la plus compliquée
    à saisir car cette méthode est utilisable dans différentes
    situations.

    -  Le client souhaite créer une ressource sur le serveur en laissant
       au serveur le choix de l'URI de la ressource.
    -  Le client souhaite ajouter une ressource à une ressource
       représentant une collection.
    -  Le client souhaite que le serveur effectue un traitement.
    -  Le client souhaite modifier partiellement une ressource.

`OPTIONS <http://tools.ietf.org/html/rfc7231#section-4.3.7>`__
    Permet d'obtenir les options de communication (par exemple : les
    méthodes autorisées pour l'URI). Le serveur doit retourner ces
    informations dans les en-têtes de réponse. Ainsi l'en-tête de
    réponse
    `Allow <http://tools.ietf.org/html/rfc7231#section-7.4.1>`__
    liste les méthodes HTTP autorisées pour cette URI.
`TRACE <http://tools.ietf.org/html/rfc7231#section-4.3.8>`__
    Permet de simuler un écho de la requête. Cette méthode n'est pas
    utilisée pour la réalisation d'API Web car elle est surtout utile
    pour tester la configuration du réseau et obtenir des informations
    des proxies.
`CONNECT <http://tools.ietf.org/html/rfc7231#section-4.3.6>`__
    Établit un tunnel à travers un proxy. Cette méthode n'est pas
    utilisée pour la réalisation d'API Web.

Configurer une application Web pour JAX-RS
******************************************

Dans un serveur d'application tel que Wildfly, JAX-RS est disponible par
défaut. Il est pris en charge par une servlet nommée ``javax.ws.rs.core.Application``.
Dans le fichier :file:`web.xml` de son application, il suffit d'ajouter une balise
``<servlet-mapping>`` pour indiquer le motif d'URI géré par JAX-RS :

.. code-block:: xml

    <servlet-mapping>
        <servlet-name>javax.ws.rs.core.Application</servlet-name>
        <url-pattern>/api/*</url-pattern>
    </servlet-mapping>

Dans l'exemple ci-dessus, cela signifie que les requêtes à partir de
**http://[hôte]/[contexte racine]/api/** seront gérées par JAX-RS.

.. note::

    Il est également possible d'activer JAX-RS dans une application Web en 
    fournissant dans cette application une classe qui étend la classe abstraite
    Application_. On utilise alors l'annotation `@ApplicationPath`_ pour donner
    le motif d'URI géré par JAX-RS :

    ::

        package ROOT_PKG.adhesion.api;

        import javax.ws.rs.ApplicationPath;
        import javax.ws.rs.core.Application;

        @ApplicationPath("/api")
        public class WebApplication extends Application {

        }

.. note::

    Il est aussi possible d'utiliser une implémentation de JAX-RS dans
    des conteneurs plus légers comme Tomcat ou Jetty sous la forme d'un
    framework tiers ajouté à son application Web. Vous devez alors vous
    reporter à la documentation de l'implémentation choisie pour connaître
    la marche à suivre.

Implémenter des ressources avec JAX-RS
**************************************

JAX-RS permet d'implémenter des ressources sous la forme de composants
Java EE. Une classe représentant une ressource est identifiée grâce à
l'annotation `@Path <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Path.html>`__.

`@Path <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Path.html>`__
    L'annotation ``@javax.ws.rs.Path`` indique le chemin d'URI qui
    identifie la ressource. Cette annotation est utilisable sur une
    classe et sur les méthodes. Utilisée sur une classe, cette
    annotation permet d'identifier la classe comme une ressource racine
    qui devient dès lors un composant géré par le serveur d'application.

    ::

        package ROOT_PKG;

        import javax.ws.rs.Path;

        @Path("/user")
        public class UserResource {
        }

    Pour l'exemple ci-dessus, la ressource sera identifiée par l'URI :
    **http://[hôte]/[contexte racine]/[mapping servlet]/user**

    Utilisée sur une méthode, cette annotation permet de spécifier une
    sous-chemin dans la ressource. Si cette méthode retourne une classe
    utilisant des annotations JAX-RS, on parle alors de
    **sous-ressource**.

    ::

        package ROOT_PKG;

        import javax.ws.rs.Path;

        @Path("/user")
        public class UserResource {
            
          @Path("/geo")
          public GeoLocation getGeographicalLocation() {
            //...
          }

        }

    Pour l'exemple ci-dessus, l'instance de la classe ``GeoLocation``
    retournée par la méthode est accessible par l'URI :
    **http://[hôte]/[contexte racine]/[mapping servlet]/user/geo**

    Dans l'exemple précédent, si la classe ``GeoLocation`` utilise
    elle-même des annotations JAX-RS alors on dit qu'il s'agit d'une
    sous-ressource. Il devient possible de créer des arborescences de
    ressources en Java basées sur le chemin de l'URI.

Les annotations de méthodes
===========================

JAX-RS fournit une annotation pour presque toutes les méthodes
HTTP :

-  ``@javax.ws.rs.GET``
-  ``@javax.ws.rs.HEAD``
-  ``@javax.ws.rs.POST``
-  ``@javax.ws.rs.PUT``
-  ``@javax.ws.rs.DELETE``
-  ``@javax.ws.rs.OPTIONS``

Elles permettent d'indiquer quelle méthode Java doit être appelée
pour traiter la méthode de la requête HTTP entrante.

::

    package ROOT_PKG;

    import javax.ws.rs.DELETE;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.PUT;
    import javax.ws.rs.Path;

    @Path("/user")
    public class UserResource {

      @GET
      public User get() {
        //....
      }

      @PUT
      public User createOrUpdate() {
        //....
      }
      
      @DELETE
      public void delete() {
        //....
      }

      @POST
      @Path("/subscription")
      public void subscribe() {
        //....
      }

    }

Si aucune méthode Java n'est déclarée pour traiter la méthode HTTP
de la requête entrante, alors le serveur répondra automatiquement le
code erreur ``405`` (Method not allowed) sauf pour les méthodes
``HEAD`` et ``OPTIONS``. Pour la méthode HTTP ``HEAD``, JAX-RS tente
d'appeler la méthode Java associée à ``GET`` et ignore le corps de
la réponse (ce qui est exactement le comportement attendu par un
client HTTP qui effectue ce type de requête). Pour la méthode HTTP
``OPTIONS``, JAX-RS génère une réponse contenant l'en-tête ``Allow``
donnant la liste des méthodes HTTP autorisées pour cette ressource
en se basant sur les annotations JAX-RS présentes dans la classe.

Paramètre dans le chemin d'URI
==============================

Comme chaque ressource Web est identifiée par une URI, il est
important pour le serveur de pouvoir récupérer dans le chemin les
informations qui vont lui permettre de réaliser cette identification
dynamiquement. Par exemple, le serveur peut extraire du chemin de la
ressource une clé primaire lui permettant d'effectuer une recherche
en base de données.

Avec JAX-RS, on déclare des paramètres de chemin entre accolades et
on utilise l'annotation ``javax.ws.rs.PathParam`` pour récupérer
leur valeur dans les paramètres des méthodes :

::

    package ROOT_PKG;

    import javax.ws.rs.DELETE;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.PUT;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;

    @Path("/user/{id}")
    public class UserResource {
      
      @GET
      public User get(@PathParam("id") long id) {
        //....
      }

      @PUT
      public User createOrUpdate(@PathParam("id") long id, User user) {
        //....
      }
      
      @DELETE
      public void delete(@PathParam("id") long id) {
        //....
      }

      @POST
      @Path("/subscription")
      public void subscribe(@PathParam("id") long id) {
        //....
      }

      @GET
      @Path("/subscription/{idSubscription}")
      public Subscription getSubscription(@PathParam("id") long id, 
                                          @PathParam("idSubscription") String idSub) {
        //....
      }
    }

JAX-RS est une API très versatile. Elle autorise beaucoup plus de
souplesse que la plupart des autres API Java EE. Pour l'exemple
précédent, comme le paramètre ``{id}`` permettant d'identifier un
utilisateur est déclaré au niveau de la classe, on devrait pouvoir
obtenir cet identifiant à la construction de l'instance. JAX-RS
permet effectivement cette implémentation qui semble plus conforme à
un modèle objet :

::

    package ROOT_PKG;

    import javax.ws.rs.DELETE;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.PUT;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;

    @Path("/user/{id}")
    public class UserResource {
      
      private final long id;
      
      public UserResource(@PathParam("id") long id) {
        this.id = id;
      }
      
      @GET
      public User get() {
        // ...
      }

      @PUT
      public User createOrUpdate(User user) {
        // ...
      }
      
      @DELETE
      public void delete() {
        //....
      }

      @POST
      @Path("/subscription")
      public void subscribe() {
        //....
      }

      @GET
      @Path("/subscription/{idSubscription}")
      public Subscription getSubscription(@PathParam("idSubscription") String idSub) {
        //....
      }
    }

Contrairement à l'API Servlet, l'API JAX-RS **crée une instance** de
``UserResource`` pour chaque requête. Il est donc possible de
stocker dans l'état de l'instance des informations spécifiques à la
requête (comme l'identifiant de l'utilisateur).

JAX-RS peut réaliser le transtypage d'un paramètre de chemin vers
les types primitifs et les chaînes de caractères. Cela permet de
garantir un premier contrôle de la validité de la donnée. Si la
valeur attendue doit avoir un motif particulier, il est possible de
le spécifier avec une expression régulière :

::

    package ROOT_PKG;

    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;

    @Path("/user/{id: [0-9]{5}}")
    public class UserResource {
      
      private final long id;
      
      public UserResource(@PathParam("id") long id) {
        this.id = id;
      }
      
      @GET
      public User get() {
        // ...
      }

    }

Par défaut, JAX-RS utilise comme expression régulière pour un
paramètre de chemin ``[^/]+?``

`@Consumes <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Consumes.html>`__ / `@Produces <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Produces.html>`__
    Lorsqu'un client soumet une requête pour transmettre des
    informations au serveur (comme des données de formulaire) et quand
    un serveur retourne du contenu à un client, il est nécessaire de
    préciser le type de contenu. On utilise pour cela l'en-tête HTTP
    ``Content-type`` avec comme valeur le type
    `MIME <http://fr.wikipedia.org/wiki/Type_MIME>`__.

    Une liste (non exhaustive) des types MIME les plus courants est :

    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/plain                          | Un fichier texte                                                                                                   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/plain;charset=utf-8            | Un fichier texte encodé en UTF-8                                                                                   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/html                           | Un fichier HTML                                                                                                    |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | application/x-www-form-urlencoded   | Le format de données pour la soumission d'un formulaire HTML                                                       |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/xml ou application/xml         | Un fichier XML                                                                                                     |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/json ou application/json       | Un fichier JSON                                                                                                    |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | image/jpeg                          | Une image au format jpeg                                                                                           |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | application/octet-stream            | Un flux d'octets sans type particulier. Il s'agit du format par défaut si l'en-tête ``Content-type`` est absent.   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+

    La classe et/ou les méthodes d'une Ressource JAX-RS peuvent utiliser
    les annotations
    `@Consumes <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Consumes.html>`__
    et
    `@Produces <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Produces.html>`__
    pour indiquer respectivement le type de contenu attendu dans la
    requête et le type de contenu de la réponse.

    ::

        package ROOT_PKG;

        import javax.ws.rs.DELETE;
        import javax.ws.rs.GET;
        import javax.ws.rs.POST;
        import javax.ws.rs.PUT;
        import javax.ws.rs.Path;
        import javax.ws.rs.PathParam;
        import javax.ws.rs.Produces;
        import javax.ws.rs.Consumes;
        import javax.ws.rs.core.MediaType;

        @Path("/user/{id}")
        public class UserResource {
          
          private final long id;
          
          public UserResource(@PathParam("id") long id) {
            this.id = id;
          }
          
          @GET
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public User get() {
            // ...
          }

          @PUT
          @Consumes({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public User createOrUpdate(User user) {
            // ...
          }
          
          @DELETE
          public void delete() {
            //....
          }

          @POST
          @Path("/subscription")
          public void subscribe() {
            //....
          }

          @GET
          @Path("/subscription/{idSubscription}")
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public Subscription getSubscription(@PathParam("idSubscription") String idSub) {
            //....
          }
        }

    Plutôt que d'écrire :

    ::

        @Produces("application/json")

    Il est recommandé d'utiliser les constantes déclarées dans la classe
    ``javax.ws.rs.core.MediaType`` 

    ::

        @Produces(MediaType.APPLICATION_JSON)

`@QueryParam <http://docs.oracle.com/javaee/7/api/javax/ws/rs/QueryParam.html>`__
    Comme pour les paramètres de chemin, il est possible de récupérer la
    valeur des paramètres de la requête comme arguments des méthodes de
    la ressource JAX-RS grâce à l'annotation
    ``@javax.ws.rs.QueryParam``.

    ::

          @GET
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public List<User> search(@QueryParam("name") String name) {
            // ...
          }

`@FormParam <http://docs.oracle.com/javaee/7/api/javax/ws/rs/FormParam.html>`__
    Les données transmises *via* un formulaire HTML peuvent être
    récupérées comme arguments des méthodes de la ressource JAX-RS grâce
    à l'annotation ``@javax.ws.rs.FormParam``. Pour le cas d'une requête
    de formulaire, le contenu attendu est presque toujours de type
    ``application/x-www-form-urlencoded``.

    ::

          @POST
          @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
          public void create(@FormParam("name") String name, @FormParam("age") int age) {
            // ...
          }

    Sur le même principe, il est également possible de récupérer
    d'autres informations d'une requête :

    -  Pour récupérer la valeur d'un en-tête HTTP, il faut utiliser
       l'annotation ``@javax.ws.rs.HeaderParam``
    -  Pour récupérer la valeur d'un Cookie HTTP, il faut utiliser
       l'annotation ``@javax.ws.rs.CookieParam``

`@Context <http://docs.oracle.com/javaee/7/api/javax/ws/rs/core/Context.html>`__
    Si vous avez besoin d'obtenir des informations sur le contexte
    d'exécution de la requête, vous pouvez utilisez l'annotation
    ``@javax.ws.rs.core.Context`` pour obtenir une instance d'une
    classe particulière. Les classes supportées sont :

    -  ``javax.ws.rs.core.UriInfo`` : Cette interface donne accès à
       l'URI de la requête.
    -  ``javax.ws.rs.core.Request`` : Cette interface fournit des
       méthodes utilitaires pour le traitement conditionnel de la
       requête.
    -  ``javax.ws.rs.core.HttpHeaders`` : Cette interface permet
       d'accéder à l'ensemble des en-têtes HTTP de la requête.
    -  ``javax.ws.rs.core.SecurityContext`` : Cette interface permet
       d'accéder aux informations de sécurité et d'authentification.
    -  ``javax.servlet.http.HttpServletRequest`` : La représentation de
       la requête avec l'API Servlet.
    -  ``javax.servlet.http.HttpServletResponse`` : La représentation de
       la réponse avec l'API Servlet.
    -  ``javax.servlet.ServletContext`` : Le contexte d'exécution des
       servlets.
    -  ``javax.servlet.ServletConfig`` : La configuration de la servlet
       traitant la requête.

    ::

          @GET
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public List<User> search(@Context UriInfo uriInfo, @Context Request req) {
            // ...
          }

    Pour des utilisations plus avancées, l'annotation
    ``@javax.ws.rs.core.Context`` peut être utilisée pour injecter
    une instance de ``javax.ws.rs.core.Application``, de
    ``javax.ws.rs.ext.Providers`` et de
    ``javax.ws.rs.ext.ContextResolver<T>``.

Data binding
************

Lorsqu'une méthode d'une ressource retourne une instance d'un objet
Java, JAX-RS va tenter de créer une réponse au format souhaité en
fonction de l'annotation
`@Produces <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Produces.html>`__.
Il existe un ensemble de règles par défaut permettant de passer d'un
objet Java à un document XML ou JSON. On appelle l'ensemble de ces règle
le **data binding**.

Si la réponse attentue est au format JSON alors JAX-RS va construire une
réponse en se basant sur les accesseurs (les getters) de la classe.

Si on souhaite retourner une instance de la classe suivante :

::

    package ROOT_PKG;

    import java.util.ArrayList;
    import java.util.List;

    public class Person {
      
      private String name;
      private int age;
      private List<Person> children = new ArrayList<>();
      
      public Person() {
      }
      
      public Person(String name, int age) {
        this.name = name;
        this.setAge(age);
      }

      public String getName() {
        return name;
      }
      
      public void setName(String name) {
        this.name = name;
      }

      public int getAge() {
        return age;
      }

      public void setAge(int age) {
        this.age = age;
      }

      public List<Person> getChildren() {
        return children;
      }
      
      public Person addChild(Person child) {
        this.children.add(child);
        return child;
      }
    }

Si on définit une ressource de la façon suivante :

::

    package ROOT_PKG;

    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.Produces;
    import javax.ws.rs.core.MediaType;

    @Path("/person")
    public class PersonResource {
      
      @GET
      @Produces(MediaType.APPLICATION_JSON)
      public Person get() {
        Person michel = new Person("Michel Raynaud", 56);
        michel.addChild(new Person("Anne Raynaud", 38)).addChild(new Person("Pierre Blémand", 16));
        michel.addChild(new Person("Damien Raynaud", 32));
        return michel;
      }
    }

Alors un appel HTTP à cette ressource génèrera un document JSON de la
forme :

.. code-block:: json

    {"children":[
      {"children":[
        {"children":[],
         "name":"Pierre Blémand",
         "age":16}
       ],
       "name":"Marie Raynaud",
       "age":38},
      {"children":[],
       "name":"Damien Raynaud",
       "age":32}
     ],
     "name":"Michel Raynaud",
     "age":56}
     
Il est également possible de réaliser l'opération inverse pour récupérer
en paramètre un document JSON transformé en une instance Java.

::

    package ROOT_PKG;

    import javax.ws.rs.POST;
    import javax.ws.rs.Path;
    import javax.ws.rs.Consumes;
    import javax.ws.rs.core.MediaType;

    @Path("/person")
    public class PersonResource {
      
      @POST
      @Consumes(MediaType.APPLICATION_JSON)
      public void post(Person person) {
        // ...
      }
    }

Il est également possible de passer d'une instance Java à un document
XML ou d'un document XML à une instance Java. Pour cela, JAX-RS utilise
`JAXB <https://jaxb.java.net/tutorial/>`__ (Java Architecture for XML
Binding) qui intégré au langage Java. JAXB utilise des annotations pour
fournir des indications sur la façon dont une classe Java peut être
associée à un document XML.

Les principales annotations JAXB sont :

`@XmlRootElement <https://docs.oracle.com/javase/8/docs/api/javax/xml/bind/annotation/XmlRootElement.html>`__
    Une annotation est utilisable sur une classe Java pour indiquer
    quelle peut être utilisée pour représenter la racine d'un document
    XML. On peut utiliser l'attribut ``name`` de l'annotation pour
    préciser le nom de l'élément racine du document XML et l'attribut
    ``namespace`` pour en préciser l'espace de nom.
`@XmlElement <https://docs.oracle.com/javase/8/docs/api/javax/xml/bind/annotation/XmlElement.html>`__
    Une annotation est utilisable sur les accesseurs (getters) des
    propriétés d'une classe. On peut utiliser l'attribut ``name`` de
    l'annotation pour préciser le nom de l'élément racine du document
    XML et l'attribut ``namespace`` pour en préciser l'espace de nom.
    Cette annotation est optionnelle. Par défaut JAXB considère qu'une
    propriété produit un élément XML du même nom et sans espace de nom
    XML.
`@XmlTransient <https://docs.oracle.com/javase/8/docs/api/javax/xml/bind/annotation/XmlTransient.html>`__
    Cette annotation, ajoutée sur les accesseurs d'une propriété d'une
    classe, indique que cette propriété ne doit pas apparaître dans le
    document XML.


.. warning::

    Les annotations JAXB doivent être positionnées sur les *getters* et non
    pas sur les attributs.

Si nous reprenons l'exemple de la classe ``Person``, nous pouvons
ajouter les annotations JAXB :

::

    package ROOT_PKG;

    import java.util.ArrayList;
    import java.util.List;

    import javax.xml.bind.annotation.XmlElement;
    import javax.xml.bind.annotation.XmlElementWrapper;
    import javax.xml.bind.annotation.XmlRootElement;

    @XmlRootElement(name="person", namespace="http://formation.fr/cours/javaee")
    public class Person {
      
      private String name;
      private int age;
      private List<Person> children = new ArrayList<>();
      
      public Person() {
      }
      
      public Person(String name, int age) {
        this.name = name;
        this.age = age;
      }

      @XmlElement(namespace="http://formation.fr/cours/javaee")
      public String getName() {
        return name;
      }
      
      public void setName(String name) {
        this.name = name;
      }

      @XmlElement(namespace="http://formation.fr/cours/javaee")
      public int getAge() {
        return age;
      }

      public void setAge(int age) {
        this.age = age;
      }

      @XmlElement(name="person", namespace="http://formation.fr/cours/javaee")
      @XmlElementWrapper(name="children", namespace="http://formation.fr/cours/javaee")
      public List<Person> getChildren() {
        return children;
      }
      
      public Person addChild(Person child) {
        this.children.add(child);
        return child;
      }
    }

Si nous autorisons une ressource à produire du XML :

::

    package ROOT_PKG;

    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.Produces;
    import javax.ws.rs.core.MediaType;

    @Path("/person")
    public class PersonResource {
      
      @GET
      @Produces(MediaType.APPLICATION_XML)
      public Person get() {
        Person michel = new Person("Michel Raynaud", 56);
        michel.addChild(new Person("Anne Raynaud", 38)).addChild(new Person("Pierre Blémand", 16));
        michel.addChild(new Person("Damien Raynaud", 32));
        return michel;
      }
    }

Alors un appel HTTP à cette ressource générera un document JSON de la
forme :

.. code-block:: xml

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <person xmlns="http://formation.fr/cours/javaee">
      <age>56</age>
      <children>
        <person>
          <age>38</age>
          <children>
            <person>
              <age>16</age>
              <children/>
              <name>Pierre Blémand</name>
            </person>
          </children>
          <name>Anne Raynaud</name>
        </person>
        <person>
          <age>32</age>
          <children/>
          <name>Damien Raynaud</name>
        </person>
      </children>
      <name>Michel Raynaud</name>
    </person>

Il est possible d'indiquer dans les annotations ``@Produces`` et
``@Consumes`` plusieurs formats supportés. Pour la génération de la
réponse, JAX-RS utilise le mécanisme de la négociation de contenu HTTP
pour déterminer quel est le format à utiliser pour la réponse.

.. code-block:: java
    :caption: Exemple de ressource supportant plusieurs formats de représentation

    package ROOT_PKG;

    import javax.ws.rs.Consumes;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.Path;
    import javax.ws.rs.Produces;
    import javax.ws.rs.core.MediaType;

    @Path("/person")
    public class PersonResource {

      @GET
      @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
      public Person get() {
        // ...
      }

      @POST
      @Consumes(MediaType.APPLICATION_JSON)
      @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
      public void post(Person person) {
        // ...
      }
    }

Les annotations JAXB sont également exploitées pour la génération d'un
document JSON. Par exemple si vous utilisez l'annotation ``@XmlElement``
pour spécifier un nom particulier pour l'élément XML, l'attibut JSON
aura également le même nom.

Générer une réponse
*******************

Parfois, il n'est pas suffisant de retourner une instance d'un objet
Java en laissant à JAX-RS le soin de créer la réponse HTTP. C'est
notamment le cas si l'on souhaite retourner un code statut HTTP
différent de 200 ou ajouter des en-têtes HTTP dans la réponse. Pour
cela, il faut retourner une instance de la classe
`javax.rs.core.Response <http://docs.oracle.com/javaee/7/api/javax/ws/rs/core/Response.html>`__.
Cette classe suit le *design pattern builder* et offre un ensemble de
méthodes utilitaires pour construire la réponse. Au final, il suffit
d'appeler la méthode ``build()`` et retourner le résultat.

.. code-block:: java
    :caption: Exemple d'utilisation de la classe ``javax.rs.core.Response``

    package ROOT_PKG;

    import java.net.URI;

    import javax.ws.rs.Consumes;
    import javax.ws.rs.GET;
    import javax.ws.rs.POST;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;
    import javax.ws.rs.Produces;
    import javax.ws.rs.core.Context;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;
    import javax.ws.rs.core.UriInfo;

    @Path("/person")
    public class PersonResource {

      @GET
      @Path("/{name}")
      @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
      public Response get(@PathParam("name") String name) { 
        Person person;
        
        // ...
        
        return Response.ok(person).build();
      }

      @POST
      @Consumes(MediaType.APPLICATION_JSON)
      @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
      public Response create(Person person, @Context UriInfo uriInfo) {
        
        // ... on sauvegarde la représentation de la personne
        
        // on construit l'URI correspondant à la personne
        URI location = uriInfo.getRequestUriBuilder()
                              .path(person.getName())
                              .build();
        
        // On retourne la réponse
        return Response.created(location).entity(person).build();
      }
    }

Gérer des exceptions
********************

Par défaut, si une méthode d'une ressource génère une exception, alors
JAX-RS la transforme en erreur HTTP 500. Si l'on souhaite retourner un
statut d'erreur différent, il est bien évidemment possible d'utiliser la
classe
`javax.rs.core.Response <http://docs.oracle.com/javaee/7/api/javax/ws/rs/core/Response.html>`__,
mais il est plus intéressant de fournir les indications nécessaires à
JAX-RS pour modifier son comportement selon le type d'exception lancé
par la méthode de la ressource.

Il est possible de lancer une exception de type
`WebApplicationException <http://docs.oracle.com/javaee/7/api/javax/ws/rs/WebApplicationException.html>`__
ou une exception en héritant. JAX-RS fournit déjà des exceptions
spécialisées pour les codes de statut les plus courants :
`NotFoundException <http://docs.oracle.com/javaee/7/api/javax/ws/rs/NotFoundException.html>`__,
`BadRequestException <http://docs.oracle.com/javaee/7/api/javax/ws/rs/BadRequestException.html>`__,
`ServerErrorException <http://docs.oracle.com/javaee/7/api/javax/ws/rs/ServerErrorException.html>`__...
et même la possibilité de traiter les redirections avec l'exception
`RedirectionException <http://docs.oracle.com/javaee/7/api/javax/ws/rs/RedirectionException.html>`__.

Il est également possible de déclarer une classe implémentant
l'interface
`ExceptionMapper <http://docs.oracle.com/javaee/7/api/javax/ws/rs/ext/ExceptionMapper.html>`__.
Un ``ExceptionMapper`` est déclaré pour un type d'exception et ses
exceptions filles.

.. code-block:: java
    :caption: Exemple d'un ``ExceptionMapper`` pour les exceptions de type ``ValiditionException``

    package ROOT_PKG;

    import javax.validation.ValidationException;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;
    import javax.ws.rs.core.Response.Status;
    import javax.ws.rs.ext.ExceptionMapper;
    import javax.ws.rs.ext.Provider;

    @Provider
    public class ValidationExceptionMapper implements ExceptionMapper<ValidationException>{

      @Override
      public Response toResponse(ValidationException exception) {
        return Response.status(Status.BAD_REQUEST)
                       .type(MediaType.TEXT_PLAIN)
                       .entity(exception.getMessage())
                       .build();
      }

    }

Dans l'exemple ci-dessus, tout appel à une méthode de ressource qui se
terminera par une exception de type ``ValidationException`` entraînera
un appel de la méthode ``ValidationExcceptionMapper.toResponse`` qui
générera une réponse de type 400 (Bad Request) avec un message en texte
brut correspondant au message de l'exception.

Notez l'utilisation de l'annotation
`@Provider <http://docs.oracle.com/javaee/7/api/javax/ws/rs/ext/Provider.html>`__
dans l'exemple précédent. Cette annotation est utilisée dans JAX-RS pour
signaler des classes utilitaires qui permettent d'étendre le
comportement par défaut de JAX-RS.

La validation avec Bean Validation
**********************************

Le serveur d'application fournit un service nommé `Bean Validation <http://beanvalidation.org/>`__ (JSR303). 
Bean Validation permet d'exprimer les contraintes de validité d'un objet ou des
paramètres d'une méthode de ressource avec des annotations. JAX-RS
utilise les informations de ces annotations pour valider les requêtes
HTTP.

.. code-block:: java
    :caption: Utilisation de Bean Validation sur les attributs d'une classe

    package ROOT_PKG;

    import java.util.ArrayList;
    import java.util.List;

    import javax.validation.constraints.Max;
    import javax.validation.constraints.Min;
    import javax.validation.constraints.Size;
    import javax.xml.bind.annotation.XmlElement;
    import javax.xml.bind.annotation.XmlElementWrapper;
    import javax.xml.bind.annotation.XmlRootElement;

    @XmlRootElement(name="person", namespace="http://formation.fr/cours/javaee")
    public class Person {
      
      @Size(min = 1, message = "Le nom est obligatoire !")
      private String name;

      @Min(value=1, message = "L'âge doit être un nombre positif !")
      @Max(value=99, message = "L'âge ne peut pas dépasser 99 ans !")
      private int age;
      
      private List  <Person> children = new ArrayList  <>();
      
      public Person() {
      }
      
      public Person(String name, int age) {
        this.name = name;
        this.age = age;
      }

      @XmlElement(namespace="http://formation.fr/cours/javaee")
      public String getName() {
        return name;
      }
      
      public void setName(String name) {
        this.name = name;
      }

      @XmlElement(namespace="http://formation.fr/cours/javaee")
      public int getAge() {
        return age;
      }

      public void setAge(int age) {
        this.age = age;
      }

      @XmlElement(name="person", namespace="http://formation.fr/cours/javaee")
      @XmlElementWrapper(name="children", namespace="http://formation.fr/cours/javaee")
      public List  <Person> getChildren() {
        return children;
      }
      
      public Person addChild(Person child) {
        this.children.add(child);
        return child;
      }
    }

.. code-block:: java
    :caption: Utilisation de Bean Validation sur un paramètre de méthode d'une ressource

    package ROOT_PKG;

    import javax.validation.constraints.Size;
    import javax.ws.rs.GET;
    import javax.ws.rs.Path;
    import javax.ws.rs.PathParam;
    import javax.ws.rs.Produces;
    import javax.ws.rs.core.MediaType;
    import javax.ws.rs.core.Response;

    @Path("/person")
    public class PersonResource {

      @GET
      @Path("/{name}")
      @Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
      public Response get(
          @Size(min = 1, message = "Chemin de ressource invalide !") 
          @PathParam("name") String name) {
        Person person;

        // ...

        return Response.ok(person).build();
      }
    }

La documentation des annotations de Bean Validation est disponible dans
la documentation de l'API Java EE :
http://docs.oracle.com/javaee/7/api/javax/validation/constraints/package-summary.html


.. only:: javaee

    Injection des dépendances
    *************************

    Comme les Servlets, les ressources racines (celles identifiées par
    l'annotation
    `@Path <http://docs.oracle.com/javaee/7/api/javax/ws/rs/Path.html>`__
    sur la classe) sont des composants Java EE. À ce titre, elles supportent
    l'injection de dépendance avec, par exemple, l'annotation
    `@Resource <http://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html>`__.


    .. code-block:: java
        :caption: Exemple d'injection d'une ``DataSource``

        package ROOT_PKG;

        import java.sql.Connection;
        import java.sql.ResultSet;
        import java.sql.SQLException;
        import java.sql.Statement;

        import javax.annotation.Resource;
        import javax.sql.DataSource;
        import javax.ws.rs.GET;
        import javax.ws.rs.NotFoundException;
        import javax.ws.rs.Path;
        import javax.ws.rs.PathParam;
        import javax.ws.rs.Produces;
        import javax.ws.rs.core.MediaType;

        @Path("/person")
        public class PersonResource {
          
          @Resource(name="person")
          private DataSource dataSource;

          @GET
          @Path("/{id}")
          @Produces({MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML})
          public Person get(@PathParam("id") long id) throws SQLException {
            try(Connection con = dataSource.getConnection();
              Statement stmt = con.createStatement();
              ResultSet rs = stmt.executeQuery("select name, age from Person where id=" + id)) {

              if (! rs.next()) {
                throw new NotFoundException();
              }
              return new Person(rs.getString("name"), rs.getInt("age"));
            }
          }
        }

Implémenter un client HTTP
**************************

JAX-RS fournit également une API pour implémenter un client HTTP. On
utilise la classe
`ClientBuilder <https://docs.oracle.com/javaee/7/api/javax/ws/rs/client/ClientBuilder.html>`__
pour créer une instance de la classe
`Client <https://docs.oracle.com/javaee/7/api/javax/ws/rs/client/Client.html>`__.

.. code-block:: java
    :caption: Exemple d'utilisation d'un client HTTP

    package ROOT_PKG;

    import javax.ws.rs.client.Client;
    import javax.ws.rs.client.ClientBuilder;
    import javax.ws.rs.client.WebTarget;

    public class ExempleClient {

      public static void main(String[] args) {
        Client client = ClientBuilder.newClient();

        WebTarget target = client.target("http://www.server.net/person");
        Person person = target.request().get(Person.class);
        
        // ...
      }
    }

.. only:: epsi_b3_javaee

    Exercice
    *********

    .. admonition:: API Web de gestion des inscriptions
        :class: hint
        
        **Objectifs**
            Réaliser une API Web avec JAX-RS qui permet de créer (méthode POST), 
            de consulter (méthode GET) et de supprimer (méthode DELETE) une inscription.
            
        Pour cet exercice, utilisez le projet d'inscription qui a servi d'exemple
        pour illustrer le modèle MVC. Le projet est :download:`téléchargeable ici <samples/mvc.zip>`.
        
        Ce projet ne réalise pas totalement une inscription puisqu'il ne réalise
        pas de connexion à une base de données. Pour simplifier l'implémentation, 
        vous pouvez stocker l'inscription créée dans la classe *InscriptionService*
        fournie dans le projet.
        
        .. note::
        
            Comme une inscription contient un mot de passe, il serait intéressant
            de ne pas transmettre le mot de passe lorsque l'on consulte l'inscription.
        
        Pour tester votre application, utilisez l'API cliente de JAX-RS en écrivant
        une simple application Java avec une méthode **main**. Pour cela,
        vous devez rajouter dans le fichier :file:`pom.xml` du projet une dépendance
        vers **RESTeasy client** :
        
        .. code-block:: xml
        
            <dependency>
                <groupId>org.jboss.resteasy</groupId>
                <artifactId>resteasy-client</artifactId>
                <version>3.0.24.Final</version>
            </dependency>
            <!-- Pour le support des représentations au format JSONs -->
            <dependency>
                <groupId>org.jboss.resteasy</groupId>
                <artifactId>resteasy-jackson-provider</artifactId>
                <version>3.0.24.Final</version>
            </dependency>
            <!-- Pour le support des représentations au format XML -->
            <dependency>
                <groupId>org.jboss.resteasy</groupId>
                <artifactId>resteasy-jaxb-provider</artifactId>
                <version>3.0.24.Final</version>
            </dependency>
    

.. _Application: https://docs.oracle.com/javaee/7/api/javax/ws/rs/core/Application.html
.. _@ApplicationPath: https://docs.oracle.com/javaee/7/api/javax/ws/rs/ApplicationPath.html

