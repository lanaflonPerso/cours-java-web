Spring MVC
##########

Spring MVC permet de construire des applications Web en Java. Comme son nom
le suggère, il utilise le principe du Modèle/Vue/Contrôleur (MVC) en association
avec le modèle IoC (Inversion of Control) du Spring Framework.

Spring MVC permet de bâtir des applications Web en se basant sur des technologies
Java déjà existantes (comme les JSP pour la création de vues).

Dépendance à Spring MVC
***********************

Pour utiliser Spring MVC, il faut tout d'abord déclarer sa dépendance dans le
fichier pom.xml de notre projet Maven :

.. code-block:: xml
    :caption: Dépendance à Spring MVC
    
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.0.7.RELEASE</version>
    </dependency>    

La DispatcherServlet
********************

Au cœur de Spring MVC, on trouve la DispatcherServlet_. Avec Spring MVC, il n'est
pas nécessaire de créer des *servlets* puisque le framework la fournit déjà. Tout
ce que nous avons à faire est de déclarer cette *servlet* dans notre fichier 
:file:`web.xml`.    

.. code-block:: xml
    :caption: Déclaration de la DispatcherServlet
    
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee 
                                 http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
        version="3.1">

        <context-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>/WEB-INF/root-context.xml</param-value>
        </context-param>

        <listener>
            <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
        </listener>

        <servlet>
            <servlet-name>dispatcher</servlet-name>
            <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
            <init-param>
                <param-name>contextConfigLocation</param-name>
                <param-value>/WEB-INF/spring/servlet-context.xml</param-value>
            </init-param>
            <load-on-startup>1</load-on-startup>
        </servlet>

        <servlet-mapping>
            <servlet-name>dispatcher</servlet-name>
            <url-pattern>/*</url-pattern>
        </servlet-mapping>
        <servlet-mapping>
            <servlet-name>jsp</servlet-name>
            <url-pattern>/WEB-INF/views/*</url-pattern>
        </servlet-mapping>
    </web-app>

La DispatcherServlet_ est ici déclarée et associée à l'URI `/*`, c'est-à-dire à toutes
les requêtes entrantes pour notre application.

Le fichier :file:`web.xml` contient également la déclaration d'un *listener* fourni
par Spring : le ContextLoaderListener_.

.. code-block:: xml
    :caption: Déclaration de la DispatcherServlet
    
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>/WEB-INF/root-context.xml</param-value>
    </context-param>

    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

Comme son nom l'indique, ce *listener* de contexte est appelé au déploiement de l'application
pour charger un contexte d'application Spring. La localisation de ce contexte est
fournie par le paramètre ``contextConfigLocation``, également déclaré dans le fichier
:file:`web.xml`.

Ce contexte d'application Spring contient les beans de l'application. Pour l'instant, nous
pouvons nous contenter d'un contexte vide :

.. code-block:: xml
    :caption: Contexte d'application vide : le fichier root-context.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
	    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	    xsi:schemaLocation="http://www.springframework.org/schema/beans 
	                        http://www.springframework.org/schema/beans/spring-beans.xsd">
    </beans>

La DispatcherServlet_ dispose également de son propre contexte. Ce dernier
va, par exemple, contenir les beans jouant le rôle de contrôleurs ainsi 
que tous les objets nécessaires
au fonctionnement de la partie Web de notre application. La localisation du fichier
décrivant le contexte d'application de cette *servlet* est donnée grâce au paramètre
``contextConfigLocation`` passé à la *servlet* (dans notre exemple, le fichier
:file:`/WEB-INF/spring/servlet-context.xml`).

.. note::

    Le paramètre ``contextConfigLocation`` n'est pas obligatoire pour la DispatcherServlet_.
    S'il est omis, la *servlet* s'attend à trouver un fichier 
    :file:`/WEB-INF/[nom de la servlet]-servlet.xml`.

Enfin, le fichier :file:`web.xml` contient une configuration d'URI pour une *servlet*
nommée **jsp** :

.. code-block:: xml
    :caption: Configuration de la servlet jsp

    <servlet-mapping>
        <servlet-name>jsp</servlet-name>
        <url-pattern>/WEB-INF/views/*</url-pattern>
    </servlet-mapping>

La *servlet* **jsp** est fournie par le serveur d'application. C'est elle qui est
responsable de localiser, de compiler et d'invoquer les JSP. Comme nous allons
utiliser les JSP comme vues pour notre application, nous signalons dans le fichier :file:`web.xml`
que les requêtes de la forme :file:`/WEB-INF/views/*` devront être traitées comme des JSP.
Sinon, ces requêtes seraient également prise en charge par la DispatcherServlet_.

.. note::

    Dans une architecture MVC, un utilisateur est sensé interagir avec les contrôleurs.
    Donc il n'est pas utile de laisser les vues (ici les pages JSP) accessibles
    directement. Voilà pourquoi les pages JSP sont placées dans un sous-répertoire
    de :file:`WEB-INF` : c'est-à-dire dans la partie privée de l'application.

Contexte d'application Web
**************************

Le Spring Framework permet d'appliquer le principe de l'inversion de contrôle (IoC) 
dans un contexte d'application (c'est-à-dire pour un ensemble de *beans*). 
Pour une application Web, il existe une implémentation spécialisée 
nommée le WebApplicationContext_.

Pour une application Web basée sur Spring, on considère qu'il faut dissocier
les *beans* servant à gérer les traitements métier et l'accès aux données
des *beans* traitant les requêtes HTTP (la couche Web). Ainsi, Spring propose
par défaut de créer un contexte d'application général et un contexte d'application
pour une *servlet*. Comme il est possible de construire une hiérarchie de contextes
d'application avec Spring, le contexte d'application général sera automatiquement
utilisé comme contexte d'application parent de celui de la *servlet*. Cela à une
conséquence importante : le contexte d'application de la DispatcherServlet_ a accès
aux *beans* déclarés dans le contexte d'application général. Par contre ces derniers
ne voient pas les *beans* déclarés dans le contexte d'application de la *servlet*.
Cela permet d'isoler les *beans* utilisés par la *servlet* des *beans* globaux 
à l'application.

.. note::

    Il est tout à fait possible de déclarer plusieurs DispatcherServlet_ dans le fichier
    :file:`web.xml` (à condition de les associer à des motifs d'URI différents).
    Cela permet d'avoir une *servlet*
    dédiée pour l'accès à une partie de l'application Web et une *servlet* dédiée
    pour l'accès à une autre partie. Cela peut être utile pour garantir une 
    séparation, par exemple, entre
    la partie publique et la partie administration d'une application. Chaque
    DispatcherServlet_ aura son propre contexte d'application mais toutes auront
    accès au contexte d'application général.

Le contexte d'application d'une *servlet* va permettre de déclarer et de configurer
les contrôleurs et les vues. Pour la gestion des contrôleurs, nous allons voir par la
suite que leur déclaration se fait grâce à des annotations. Pour la gestion des vues,
Spring MVC permet de choisir (voire d'utiliser simultanément) entre plusieurs 
technologies. Pour traduire ce choix, il faut déclarer une implémentation de 
ViewResolver_ dont le rôle est de localiser une vue pour le rendu final de la réponse
du serveur. Pour ce chapitre, nous utiliserons la technologie JSP.

.. code-block:: xml
    :caption: servlet-context.xml
    
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns="http://www.springframework.org/schema/beans"
           xmlns:mvc="http://www.springframework.org/schema/mvc"
           xmlns:context="http://www.springframework.org/schema/context"
           xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd
                               http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
                               http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd">

        <context:component-scan base-package="ROOT_PKG" />
        <mvc:default-servlet-handler/>
        <mvc:annotation-driven />
    	<mvc:resources mapping="/resources/**" location="/resources/" />
        <mvc:view-resolvers>
            <mvc:jsp prefix="/WEB-INF/views/" suffix=".jsp"/>
        </mvc:view-resolvers>
    </beans> 

Dans l'exemple précédent, nous définissons un contexte d'application pour la *servlet*.

La balise ``<context:component-scan base-package="..." />`` implique que Spring
doit analyser toutes les classes présentes dans un package et tous ses sous packages
afin de chercher des classes portant des annotations particulières.

La balise ``<mvc:default-servlet-handler/>`` permet de transmettre les requêtes inconnues
de la DispatcherServlet_ à la *servlet* par défaut. En effet, une application Web contient
implicitement une *servlet* par défaut fournie par le conteneur Web. Elle est responsable, par exemple,
d'afficher la page 404 si la requête n'est pas connue de l'application.

La balise ``<mvc:annotation-driven />`` permet de signaler que la déclaration des *beans*
se fait par annotation dans les classes et non pas dans le fichier du contexte
d'application. Nous verrons qu'il s'agit de la manière la plus simple de déclarer
des contrôleurs.

La balise ``<mvc:resources mapping=".." location=".." />`` permet d'associer un chemin
de ressources (images, fichiers JavaScript, fichiers CSS...) dans l'URI avec un chemin
dans l'application Web. La DispatcherServlet_ peut donc servir ces fichiers directement
en les renvoyant au client.

La section ``<mvc:view-resolvers>`` permet de déclarer comment Spring MVC doit localiser
une vue. Par cette exemple, nous utilisons ``<mvc:jsp />`` qui permet, à partir
d'un identifiant de vue, de déduire le chemin vers une page JSP. Ici, une vue
ayant pour identifiant ``home`` sera comprise comme correspondant à la page
JSP :file:`/WEB-INF/views/home.jsp`.

.. note::

    La balise ``<mvc:jsp />`` est une simplification d'écriture. On peut également
    déclarer dans le contexte d'application un *bean* de type UrlBasedViewResolver_.

Les contrôleurs
***************

Un contrôleur est une classe Java portant l'annotation `@Controller`_. De 
manière générale, l'objectif d'un contrôleur est de réagir à une interaction 
avec l'utilisateur. Pour une application
Web, cela signifie que l'utilisateur envoie une requête HTTP au serveur.

Pour que le contrôleur soit appelé lors du traitement d'une requête, il suffit d'ajouter
l'annotation `@RequestMapping`_ sur une méthode publique de la classe en précisant
la méthode HTTP concernée (par défaut GET) et le chemin d'URI (à partir du contexte
de déploiement de l'application) pris en charge par la méthode.

.. code-block:: java
    :caption: Un contrôleur
    
    package ROOT_PKG;

    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RequestMethod;

    @Controller
    public class ItemController {
	
        @RequestMapping(path="/", method=RequestMethod.GET)
        public String getHome() {
            // ...
            return "index";
        }

        @RequestMapping(path="/item", method=RequestMethod.POST)
        public String addItem() {
            // ...
            return "itemDetail";
        }

    }

Dans l'exemple ci-dessus, le contrôleur déclare la méthode ``getHome`` qui traite
les requêtes se terminant par / et la méthode ``addItem`` qui traite les
requêtes se terminant pas /item. La première n'accepte que les requêtes de type GET
et la seconde que les requêtes de type POST.

.. note::

    Il existe les annotations `@GetMapping`_, `@PutMapping`_, `@PostMapping`_, 
    `@DeleteMapping`_, `@PatchMapping`_ qui fonctionnent comme l'annotation `@RequestMapping`_
    sauf qu'il n'est pas nécessaire de préciser la méthode HTTP concerné puisqu'elle
    est mentionnée dans le nom de l'annotation :

    ::
        
        package ROOT_PKG;

        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.GetMapping;
        import org.springframework.web.bind.annotation.PostMapping;

        @Controller
        public class ItemController {
	
            @GetMapping(path="/")
            public String getHome() {
                // ...
                return "index";
            }

            @PostMapping(path="/item")
            public String addItem() {
                // ...
                return "itemDetail";
            }

        }


.. note::

    L'annotation `@RequestMapping`_ peut être utilisée directement sur la déclaration
    de classe pour donner des indications pour l'ensemble des méthodes de cette classe.
    Par exemple, on peut préciser un chemin de base pour l'URI :
    
    ::

        @Controller
        @RequestMapping(path="/ctrl")
        public class ItemController {
	
            // ...

        }


La signature des méthodes de contrôleur
***************************************

Spring MVC autorise une très grande diversité de signatures pour les méthodes
d'un contrôleur gérant les requêtes HTTP (appelées *handler methods*). 
Hormis le nom de la méthode elle-même pour laquelle nous avons
toute liberté, il est possible de choisir parmi un choix très large pour le type
et le nombre des paramètres ainsi que le type de la valeur de retour de la méthode.

Les paramètres
==============

Pour la liste complète des types de paramètre supportés, reportez-vous à la 
`documentation officielle <https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-arguments>`__

À titre d'exemple, un méthode gérant les requêtes HTTP peut accepter en paramètres :

* La valeur d'un paramètre grâce à l'annotation `@RequestParam`_.

    ::

        package ROOT_PKG;

        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.PostMapping;
        import org.springframework.web.bind.annotation.RequestParam;

        @Controller
        public class ItemController {

            @PostMapping("/item")
            public String addItem(@RequestParam("itemName") String name) {
                // ...
                return "itemDetail";
            }

        }
        
    .. note::

        Depuis Java 8, si le nom du paramètre de la requête est identique au nom du 
        paramètre de la méthode, il n'est pas utile de préciser le nom du paramètre
        de la requête entre parenthèses :
        
        ::

            @PostMapping("/item")
            public String addItem(@RequestParam String itemName) {
                // ...
                return "itemDetail";
            }
     
* La valeur d'un en-tête de la requête HTTP grâce à l'annotation `@RequestHeader`_

    ::

        package ROOT_PKG;

        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.PostMapping;
        import org.springframework.web.bind.annotation.RequestHeader;

        @Controller
        public class ItemController {

            @PostMapping("/item")
            public String addItem(@RequestHeader("host") String host) {
                // ...
                return "itemDetail";
            }

        }
        
    .. note::

        Depuis Java 8, si le nom de l'en-tête de la requête est identique au nom du 
        paramètre de la méthode, il n'est pas utile de préciser le nom de l'en-tête
        de la requête entre parenthèses :
        
        ::

            @PostMapping("/item")
            public String addItem(@RequestHeader String host) {
                // ...
                return "itemDetail";
            }

* Une valeur dans le chemin de la ressource grâce à l'annotation `@PathVariable`_. 
  Dans ce cas, il est possible de déclarer entre accolades une variable dans 
  le chemin de la ressource. 

    ::

        package ROOT_PKG;

        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.PostMapping;
        import org.springframework.web.bind.annotation.PathVariable;

        @Controller
        public class ItemController {

            @PostMapping("{subpath}/item")
            public String addItem(@PathVariable("subpath") String subpath) {
                // ...
                return "itemDetail";
            }

        }

    .. note::

        Depuis Java 8, si le nom de la variable de chemin est identique au nom du 
        paramètre de la méthode, il n'est pas utile de préciser le nom de la variable
        entre parenthèses :
        
        ::

            @PostMapping("{subpath}/item")
            public String addItem(@PathVariable String subpath) {
                // ...
                return "itemDetail";
            }

* La valeur d'un attribut de requête, de session ou de session grâce aux annotations
  `@RequestAttribute`_ et `@SessionAttribute`_ :
  
    ::

        package ROOT_PKG;

        import org.springframework.stereotype.Controller;
        import org.springframework.web.bind.annotation.PostMapping;
        import org.springframework.web.bind.annotation.SessionAttribute;

        @Controller
        public class ItemController {

            @PostMapping("/item")
            public String addItem(@SessionAttribute("basket") Basket basket) {
                // ...
                return "itemDetail";
            }

        }
        
    .. note::

        Depuis Java 8, si le nom de l'attribut est identique au nom du 
        paramètre de la méthode, il n'est pas utile de préciser le nom de l'attribut
        entre parenthèses :
        
        ::
        
            @PostMapping("/item")
            public String addItem(@SessionAttribute Basket basket) {
                // ...
                return "itemDetail";
            }

Toutes les annotations ci-dessus acceptent l'attribut *required* qui permet d'indiquer
si le paramètre doit être renseigné. Si l'attribut *required* vaut *true* (valeur
par défaut) alors l'absence de valeur entraîne une erreur de type 400 (bad request)
et la méthode du contrôleur n'est pas appelée.

.. note::

    Depuis Java 8, il est possible d'utiliser Optional_ comme type de paramètre
    afin de préciser que le paramètre est optionnel (sans avoir à se préoccuper de la
    valeur de l'attribut *required*).

    ::
    
        @PostMapping("/item")
        public String addItem(@SessionAttribute Optional<Basket> basket) {
            if (basket.isPresent()) {
                // ...
            }
            return "itemDetail";
        }

Il est également possible de passer en paramètre une instance d'un objet Java 
présente dans le modèle grâce à l'annotation `@ModelAttribute`_. Si aucune instance n'existe,
l'objet sera automatiquement instancié. Pour un envoi de formulaire, les attributs
de cet objet seront remplis avec la valeur du paramètre portant le même nom.

Par exemple, si on déclare la classe `Item` :

::

    package ROOT_PKG;

    public class Item {
	
        private String name;
        private String code;
        private int quantity;
        
        // Getters/setters omis

    }

On peut déclarer une méthode dans un contrôleur qui prend en paramètre un objet
de type `Item`.

::

    package ROOT_PKG;

    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;

    @Controller
    public class ItemController {

        @PostMapping("/item")
        public String addItem(@ModelAttribute Item item) {
            // ...
            return "itemDetail";
        }

    }

Lors du traitement de la requête POST sur :file:`/item`, un objet de type `Item`
sera créé avec ses attributs renseignés avec les valeurs des paramètres HTTP
*name*, *code* et *quantity*.

.. note::

    L'annotation `@ModelAttribute`_ peut être omise car c'est l'interprétation
    par défaut d'un paramètre d'une méthode d'un contrôleur.

Enfin, Spring MVC reconnaît certains types d'objet en tant que paramètre. C'est
notamment le cas d'un paramètre de type Model_ qui permet à la méthode de consulter
ou d'ajouter des attributs dans le modèle. Cette classe est une abstraction du
modèle au sens MVC. Chaque attribut de ce modèle sera ensuite visible à la vue.
Pour une JSP, cela signifie que chaque attribut ajouté dans ce modèle sera
accessible par son nom dans une EL.

::

    package ROOT_PKG;

    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;

    @Controller
    public class MessageController {

        @PostMapping("/message")
        public String display(Model model) {
            model.addAttribute("message", "Hello world");
            return "showMessage";
        }

    }

La valeur de retour
===================

Pour la liste complète des types de valeur de retour supportés, reportez-vous à la 
`documentation officielle <https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-ann-return-types>`__.

La valeur de retour d'une méthode de gestion de requête de contrôleur est généralement
utilisée pour identifier la vue :

* Si la méthode retourne une chaîne de caractères alors elle est permet au ViewResolver_
  configurer de déduire la vue qui doit être appelée.

* Si la méthode retourne ``void`` ou ``null`` alors la méthode est supposée
  avoir correctement traitée la requête et aucune vue ne sera appelée

* Si la méthode retourne un objet de type ModelAndView_ alors il est utilisé pour
  déduire l'identifiant de la vue et les données du modèle.

* Si le type de retour est annoté par `@ResponseBody`_, cela signifie que l'objet
  retourné constitue la réponse. Il est possible d'utiliser un convertisseur pour
  le transformer, par exemple, en réponse JSON.

Les vues JSP
************

Spring MVC supporte plusieurs technologies pour prendre en charge le rendu
des vues. Pour utiliser des JSP comme vues, il est possible de déclarer
dans le contexte d'application de la DispatcherServlet_ un ViewResolver_ spécifique
aux JSP :

.. code-block:: xml
    :caption: extrait de la déclaration d'un contexte pour une servlet
    
    <mvc:view-resolvers>
        <mvc:jsp prefix="/WEB-INF/views/" suffix=".jsp"/>
    </mvc:view-resolvers>

Ainsi lorsqu'un contrôleur retourne l'identifiant d'une vue, cet identifiant
sera utilisé pour reconstruire le chemin de la JSP grâce au préfixe et au suffixe
déclarés :

    /WEB-INF/views/[id vue].jsp

Spring MVC ne fournit par défaut d'implémentation pour les JSTL (*Java Standard Tag Libraries*).
Il suffit simplement d'ajouter une dépendance dans le fichier :file:`pom.xml`
du projet :

.. code-block:: xml

    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>

Par contre, Spring MVC fournit ses propres bibliothèques de tag (*taglibs*)
qui offrent des fonctionnalités supplémentaires par rapport aux JSTL.


Spring's JSP taglib
===================

La première *taglib* appelée simplement *Spring's JSP taglib* apporte des
fonctionnalités similaires aux JSTL tout en y ajoutant des évolutions ou des
spécificités propres à Spring MVC. Vous pouvez vous reporter à la
`documentation officielle <https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/tags/package-summary.html>`__
pour voir la liste des *tags* supportés.
Cette *taglib* est utilisable *via* la directive ``taglib`` :

.. code-block:: jsp

    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

Par exemple, la balise url_ offre des fonctionnalités supplémentaires par rapport
à son équivalent dans les JSTL. Il est possible de passer des paramètres et de
demander un échappement des caractères pour une utilisation dans du code JavaScript :

.. code-block:: jsp

    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <spring:url value="/destination" javaScriptEscape="true" var="destinationUrl">
            <spring:param name="name" value="${name}"/>
        </spring:url>
        <script>
        var url = "${destinationUrl}";
        alert(url);
        </script>
    </head>
    <body>
    </body>
    </html>

S'il existe dans le modèle un attribut *name* avec la valeur *julie*, alors 
la JSP ci-dessus produira le code HTML suivant :

.. code-block:: html

    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
	
	        
	
        <script>
        var url = "\/sailorapp\/destination?name=julie";
        alert(url);
        </script>
    </head>
    <body>
    </body>
    </html>

Form taglib
===========

La seconde *taglib* appelée *form taglib* permet de créer des formulaires HTML
liés aux *beans* du modèle et d'afficher correctement les messages d'erreurs en
cas d'échec de la validation.

Cette *taglib* est utilisable *via* la directive ``taglib`` :

.. code-block:: jsp

    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

Cette *taglib* fournit le *tag* ``form`` ainsi que des *tags* pour tous les
éléments d'un formulaire : ``input``, ``chekbox``, ``button``... 
Vous pouvez vous reporter à la 
`documentation officielle <https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/tags/form/package-summary.html>`__
pour voir la liste complète des *tags* supportés.

Le *tag* ``form`` est associé à un *bean* de commande. Par defaut, il doit exister
dans le modèle, un attribut dans le nom est *command*. Si le nom par défaut, ne
convient pas, on peut spécifier le nom du *bean* grâce à l'attribut
``modelAttribute`` du *tag* ``form``.

Supposons, que nous disposons d'un *bean* nommé *item* dans le modèle qui serait
du type *Item* :

::

    package ROOT_PKG;

    public class Item {
	
        private String name;
        private String code;
        private int quantity;
        
        // Getters/setters omis

    }

Nous pouvons créer la vue suivante pour fournir un formulaire qui permet d'ajouter
un *item* :

.. code-block:: jsp

    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
    </head>
    <body>

    <form:form servletRelativeAction="/item" modelAttribute="item">
      <p><label>Code : </label><form:input path="code"/> <form:errors path="code"/></p>
      <p><label>Nom : </label><form:input path="name"/> <form:errors path="name"/></p>
      <p><label>Quantité : </label><form:input path="quantity"/> <form:errors path="quantity"/></p>
      <button type="submit">Envoyer</button>
    </form:form>

    </body>
    </html>

La vue ci-dessus utilise la *form taglib* pour créer un formulaire. La balise
``<form:input>`` définit l'attribut ``path`` qui correspond à l'attribut du *bean*
à partir duquel sera déduit le nom et la valeur de cet *input*. La balise
``<form:errors>`` est remplacée par le message d'erreur de validation (s'il y en
a un). Il est possible d'utiliser l'attribut ``path`` pour filtrer les messages
à afficher pour un attribut particulier du *bean* de commande. Cela permet, par
exemple, de créer un formulaire dans lequel les messages d'erreur sont affichés
à côté de la zone de saisie concernée.

.. note::

    Reportez-vous à la `documentation officielle <https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-view-jsp-formtaglib>`__
    pour des exemples plus détaillés de formulaires.

Exercices
*********

.. admonition:: POST-redirect-GET et attribut flash
    :class: hint

    **Objectif**
        Réaliser une application Web qui accepte un formulaire dans lequel
        un utilisateur peut saisir des données personnelles (nom, email, age).
        
        Le formulaire est soumis au serveur avec une requête POST. Les champs
        sont validés par le serveur. En cas d'erreur de saisie, le formulaire
        est affiché à nouveau avec les messages d'erreur associés à chaque champ.
        
        Si les données sont correctes, le serveur doit rediriger le client vers
        une page de confirmation qui répète les informations de l'utilisateur.
        
        Pour cet exercice, vous utiliserez la technique du `POST/Redirect/GET <https://fr.wikipedia.org/wiki/Post-Redirect-Get>`__.
        
    **POST/Redirect/GET avec Spring MVC**
    
        Un contrôleur peut déclencher une redirection en préfixant la chaîne de caractères
        retournée par ``redirect:``. Le contenu est alors identifié comme une adresse
        relative à la racine de l'application Web (et non comme un identifiant de vue).
        
        De plus, Spring MVC introduit la notion `d'attributs Flash <https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-flash-attributes>`__.
        Ces attributs sont stockés en session jusqu'à la prochaine
        requête de l'utilisateur. Ils sont donc faits pour mémoriser très temporairement
        un contexte d'exécution le temps d'une redirection. Pour utiliser les attributs
        flash, il suffit d'attendre en paramètre de la méthode d'un contrôleur
        un argument de type RedirectAttributes_. Grâce à ce paramètre, on peut
        mémoriser un attribut flash avant d'effectuer la redirection. L'attribut
        flash sera automatiquement ajouté dans le modèle pour le traitement du
        contrôleur après la redirection.
        
        Ci-dessous un exemple simple utilisant une redirection avec un attribut flash :
        
        ::
        
            package ROOT_PKG;

            import org.springframework.stereotype.Controller;
            import org.springframework.web.bind.annotation.GetMapping;
            import org.springframework.web.bind.annotation.ModelAttribute;
            import org.springframework.web.servlet.mvc.support.RedirectAttributes;

            @Controller
            public class IndexController {
	
                @GetMapping(path="/")
                public String home(RedirectAttributes redirectAttributes) {
                    Item item = new Item();
                    item.setCode("BV-34");
                    item.setName("Mon item");
                    redirectAttributes.addFlashAttribute("item", item);
                    return "redirect:/redirection";
                }

                @GetMapping(path="/redirection")
                public String redirectHome(@ModelAttribute Item item) {
                    // Le paramètre item correspond à l'instance ajoutée comme attribut flash
                    return "view";
                }
            }


    **Modèle Maven du projet à télécharger**
        :download:`webapp-template-spring-mvc.zip <assets/templates/webapp-template-spring-mvc.zip>`

    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

La gestion des exceptions
*************************

Spring MVC nous permet de transformer des exceptions en erreur HTTP pour le client
(voire même créer une réponse complète avec une vue dédiée).

Certaines exceptions fournies par Spring MVC sont directement comprises et transformées
en erreur. Par exemple, HttpRequestMethodNotSupportedException_ permet de signaler
une erreur HTTP 405. Ce comportement est géré par la classe DefaultHandlerExceptionResolver_.
Reportez-vous à la documentation de cette classe pour la liste complète des exceptions supportées.

Un contrôleur peut fournir des méthodes de gestion des exceptions. Ces méthodes
doivent être annotées avec `@ExceptionHandler`_. L'annotation permet de préciser
la classe de l'exception que la méthode peut gérer. Une méthode de gestion d'exception
accepte des types de paramètres et une valeur de retour similaires aux méthodes
de gestion de requête. Une méthode de gestion d'exception attend également en paramètre
l'exception à traiter.

::

    package ROOT_PKG;

    import org.springframework.http.HttpStatus;
    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.annotation.ExceptionHandler;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.ResponseStatus;

    @Controller
    public class ItemController {
	
        @ExceptionHandler(ItemException.class)
        @ResponseStatus(HttpStatus.BAD_REQUEST)
        public String handleItemException(ItemException e, Model model) {
            model.addAttribute("message", e.getMessage());
            return "itemError";
        }

        @PostMapping("/item")
        public String addItem(@ModelAttribute Item item, Model model) throws ItemException {
            if (item.getQuantity() == 0) {
                throw new ItemException("Item not available");
            }
            // ...
            model.addAttribute("item", item);
            return "itemDetail";
        }

    }

Dans l'exemple précédent, on déclare un contrôleur dont la méthode *addItem* peut
jeter une *ItemException* qui est une exception de l'application. Le contrôleur
déclare également une méthode pour gérer les exceptions du même type. Ainsi, si
cette exception est effectivement lancée lors de l'exécution de la méthode *addItem*,
Spring MVC appellera la méthode *handleItemException* et utilisera sa valeur de retour
pour en déduire la vue. Notez que la méthode *handleItemException* est annotée
avec `@ResponseStatus`_ qui permet de modifier le statut HTTP de la réponse. Dans
cet exemple, une exception *ItemException* produira une réponse avec le code HTTP
400 (*Bad Request*).

.. note::

    Il est possible de modifier le comportement par défaut de traitement des exceptions
    en déclarant dans le contexte de la *servlet* un ou plusieurs HandlerExceptionResolver_.
    Vous pouvez vous reporter à la 
    `documentation officielles <https://docs.spring.io/spring/docs/current/spring-framework-reference/web.html#mvc-exceptionhandlers>`__.

Validation des paramètres d'une requête
***************************************

Spring MVC repose sur le mécanisme de validation de *bean* fourni par le Spring Framework.
Ce dernier peut utiliser un mécanisme propre ou une implémentation de l'API
standard *Bean Validation* (JSR-303) s'il en existe une de disponible dans le classpath.
Dans cette section, nous nous limiterons à l'utilisation de l'API *Bean Validation*.
Pour qu'elle fonctionne, il faut disposer d'une implémentation comme par exemple celle
fournie par Hibernate. Dans le fichier :file:`pom.xml`, il suffit d'ajouter :

.. code-block:: xml
    :caption: dépendance d'une implémentation de Bean Validation
    
    <dependency>
        <groupId>org.hibernate</groupId>
        <artifactId>hibernate-validator</artifactId>
        <version>5.4.2.Final</version>
    </dependency>
 
*Bean Validation* repose sur une famille d'annotations qui sont positionnées sur
les attributs d'un bean ou les paramètres d'une méthode pour indiquer les contraintes
sur les valeurs possibles. 

.. code-block:: java
    :caption: Exemple d'utilisation des annotations de validation

    package ROOT_PKG;

    import javax.validation.constraints.Max;
    import javax.validation.constraints.Min;
    import javax.validation.constraints.NotNull;
    import javax.validation.constraints.Size;

    public class Item {
	
        @NotNull
        private String name;

        @Size(min=4)
        private String code;

        @Min(0)
        @Max(1000)
        private int quantity;

        // Getters/setters omis

    }

.. note::

    La liste des annotations de Bean Validation est disponible dans la 
    `documentation de Java EE 7 <https://docs.oracle.com/javaee/7/api/javax/validation/constraints/package-summary.html>`__.

Spring MVC est capable d'appeler une implémentation de *Bean Validation* afin de 
valider les données en entrée. Pour cela, il faut préciser que le paramètre
doit être validé grâce à l'annotation `@Valid`_. Si les données sont invalides, 
la méthode du contrôleur n'est pas appelée et Spring MVC retourne directement 
une erreur HTTP 400 (requête invalide) au client.

::

    package ROOT_PKG;

    import javax.validation.Valid;

    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;

    @Controller
    public class ItemController {

        @PostMapping("/item")
        public String addItem(@Valid @ModelAttribute Item item, Model model) {
            // ...
            model.addAttribute("item", item);
            return "itemDetail";
        }

    }


Afin d'avoir un contrôle plus fin de la validation, il est possible d'ajouter
à la méthode du contrôleur un paramètre de type BindingResult_. Ce dernier doit
immédiatement suivre la paramètre pour lequel on veut contrôler le résultat
du *binding* Dans ce cas,
la méthode du contrôleur sera appelée même si le paramètre est invalide. Il est
possible d'appeler la méthode `BindingResult.hasErrors()`_ pour vérifier si une
erreur s'est produite.

::

    package ROOT_PKG;

    import javax.validation.Valid;

    import org.springframework.stereotype.Controller;
    import org.springframework.ui.Model;
    import org.springframework.validation.BindingResult;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;

    @Controller
    public class ItemController {
	
        @PostMapping("/item")
        public String addItem(@Valid @ModelAttribute Item item, BindingResult itemBindingResult, 
                              Model model) {
            if (itemBindingResult.hasErrors()) {
                // ...
            }
            // ...
            model.addAttribute("item", item);
            return "itemDetail";
        }

    }

Méthodes de modèle
******************

Il est parfois utile d'ajouter des éléments dans un modèle quelle que soit la requête
émise vers un contrôleur. De cette façon, ces éléments seront disponibles dans
la vue. Par exemple, si un contrôleur permet de manipuler une instance d'un modèle,
on peut dédier une méthode à la récupération de cette instance et annotée la méthode
avec `@ModelAttribute`_.

::

    package ROOT_PKG;

    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PathVariable;
    import org.springframework.web.bind.annotation.RequestMapping;

    @Controller
    @RequestMapping(path="/item/{code}")
    public class ItemEditController {
	
	    @ModelAttribute
	    public Item getItem(@PathVariable String code) {
		    Item item = new Item();
		    item.setCode(code);
		
		    // ...
		
		    return item;
	    }
	
	    @GetMapping
	    public String viewItem(@ModelAttribute Item item) {

		    // ...
		
		    return "showItem";
	    }
    }

Dans l'exemple ci-dessus, la méthode *getItem* est systématiquement appelée
avant la méthode de traitement de la requête. Elle récupère le code dans le
chemin de la ressource et elle retourne une instance de la classe *Item*.
Cette instance est automatiquement ajoutée dans le modèle (avec le nom *item*).
Elle sera donc accessible depuis une vue. Cette instance de la classe *Item*
peut également directement être passée en paramètre de la méthode de traitement
de la requête comme c'est le cas pour la méthode *viewItem* de l'exemple ci-dessus.

Méthodes de binder
******************

Le *binding* est l'étape qui permet de définir la façon de passer d'un format
de données à une représentation objet (et *vice-versa*). Spring fournit des *binding*
par défaut notamment pour transformer une chaîne de caractères en nombre. Il
est possible d'ajouter ces propres définitions de *binders*. Pour cela, il
suffit d'ajouter dans un contrôleur une méthode annotée avec `@InitBinder`_ et
ayant au moins un paramètre de type WebDataBinder_.

::

    package ROOT_PKG;

    import java.text.SimpleDateFormat;
    import java.util.Date;

    import org.springframework.beans.propertyeditors.CustomDateEditor;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.WebDataBinder;
    import org.springframework.web.bind.annotation.InitBinder;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestParam;

    @Controller
    public class DateController {

        @InitBinder
        public void initBinder(WebDataBinder binder) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
            binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
        }

        @PostMapping("/date")
        public String updateDate(@RequestParam Date date) {

            // ...

            return "success";
        }

    }

Dans l'exemple ci-dessus, le contrôleur contient une méthode annotée avec 
`@InitBinder`_. Cette méthode est appelée avant l'appel de la méthode de traitement
de la requête. Elle enregistre un SimpleDateFormat_ pour permettre de convertir
une chaîne de caractères en Date_ à partir d'un format particulier.

Utiliser le contexte de l'application
*************************************

Nous avons vu au début du chapitre qu'une DispatcherServlet_ possède son propre
contexte d'application qui est indépendant du contexte de l'application. Néanmoins
le contexte de la DispatcherServlet_ a accès aux *beans* du contexte d'application.
Il est donc facile d'utiliser l'IoC.

::

    package ROOT_PKG;

    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.ModelAttribute;
    import org.springframework.web.bind.annotation.PostMapping;

    @Controller
    public class ItemController {
	
        @Autowired
        private ItemRepository itemRepository;

        @PostMapping("/item")
        public String addItem(@ModelAttribute Item item) {
            itemRepository.save(item);
            return "itemDetail";
        }

    }

Dans l'exemple ci-dessus, on suppose qu'il existe un *bean* déclaré dans le
contexte de l'application de type *ItemRepository*. Le contrôleur peut récupérer
ce *bean* par injection.

ControllerAdvice
****************

Nous avons vu qu'il est possible de déclarer des méthodes annotées avec `@ExceptionHandler`_, 
`@ModelAttribute`_ et `@InitBinder`_ dans un contrôleur. Si nous voulons utiliser
les mêmes méthodes à travers plusieurs contrôleurs, il est possible de créer
une classe annotée avec `@ControllerAdvice`_. Cette classe regroupe toutes les
méthodes communes est indique les contrôleurs, le package ou même l'annotation
pour lesquels elle s'applique.

::

    package ROOT_PKG;

    import java.text.SimpleDateFormat;
    import java.util.Date;

    import org.springframework.beans.propertyeditors.CustomDateEditor;
    import org.springframework.http.HttpStatus;
    import org.springframework.ui.Model;
    import org.springframework.web.bind.WebDataBinder;
    import org.springframework.web.bind.annotation.ControllerAdvice;
    import org.springframework.web.bind.annotation.ExceptionHandler;
    import org.springframework.web.bind.annotation.InitBinder;
    import org.springframework.web.bind.annotation.ResponseStatus;

    @ControllerAdvice("ROOT_PKG")
    public class ItemControllerAdvice {

        @InitBinder
        public void initBinder(WebDataBinder binder) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
            binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, false));
        }

        @ExceptionHandler(ItemException.class)
        @ResponseStatus(HttpStatus.BAD_REQUEST)
        public String handleItemException(ItemException e, Model model) {
            model.addAttribute("message", e.getMessage());
            return "itemError";
        }
    }

Dans l'exemple ci-dessus, tous les contrôleurs déclarés dans le package spécifié
par l'annotation `@ControllerAdvice`_ seront enrichis par les méthodes
de ce *ControllerAdvice*.

.. _ViewResolver: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/reactive/result/view/ViewResolver.html
.. _HandlerExceptionResolver: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/HandlerExceptionResolver.html
.. _DefaultHandlerExceptionResolver: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/mvc/support/DefaultHandlerExceptionResolver.html
.. _UrlBasedViewResolver: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/view/UrlBasedViewResolver.html
.. _DispatcherServlet: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/DispatcherServlet.html
.. _ContextLoaderListener: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/context/ContextLoaderListener.html
.. _WebApplicationContext: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/context/WebApplicationContext.html
.. _@Controller: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/stereotype/Controller.html
.. _@RequestMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html
.. _@GetMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/GetMapping.html
.. _@PutMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/PutMapping.html
.. _@PostMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/PostMapping.html
.. _@DeleteMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/DeleteMapping.html
.. _@PatchMapping: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/PatchMapping.html
.. _@RequestParam: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/RequestParam.html
.. _@SessionAttribute: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/SessionAttribute.html
.. _@RequestAttribute: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/RequestAttribute.html
.. _@RequestHeader: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/RequestHeader.html
.. _@PathVariable: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/PathVariable.html
.. _Optional: https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html
.. _@ModelAttribute: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/ModelAttribute.html
.. _@InitBinder: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/InitBinder.html
.. _Model: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/ui/Model.html
.. _ModelAndView: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/ModelAndView.html
.. _@ResponseBody: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/ResponseBody.html
.. _HttpRequestMethodNotSupportedException: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/HttpRequestMethodNotSupportedException.html
.. _@ExceptionHandler: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/ExceptionHandler.html
.. _@ResponseStatus: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/ResponseStatus.html
.. _@Valid: https://docs.oracle.com/javaee/7/api/javax/validation/Valid.html
.. _BindingResult: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/validation/BindingResult.html
.. _BindingResult.hasErrors(): https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/validation/Errors.html#hasErrors--
.. _WebDataBinder: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/WebDataBinder.html
.. _SimpleDateFormat: https://docs.oracle.com/javase/8/docs/api/java/text/SimpleDateFormat.html
.. _Date: https://docs.oracle.com/javase/8/docs/api/java/util/Date.html
.. _@ControllerAdvice: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/bind/annotation/ControllerAdvice.html
.. _url: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/tags/UrlTag.html
.. _RedirectAttributes: https://docs.spring.io/spring-framework/docs/5.0.4.RELEASE/javadoc-api/org/springframework/web/servlet/mvc/support/RedirectAttributes.html
