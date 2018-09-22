Web listeners et filtres
########################

Les servlets ne sont pas les seuls composants gérés par le conteneur
Web, ce dernier a également la responsabilité de gérer le cycle de vie
des **listeners** et des **filtres** Web.

Les listeners Web
*****************

Un listener (écouteur) est un terme couramment utilisé en Java pour
désigner un objet qui sera notifié lors d'une modification de son
environnement. Dans les patrons de conception (Design Patterns) Objet,
on l'appelle plus généralement Observateur_.

Pour le conteneur Web Java EE, un listener designe une classe qui
implémente une des interfaces définies dans l'API servlet.

Le principe d'utilisation est le même pour tous les types de listeners
Web. Si l'application souhaite être avertie d'un événement particulier
survenant pour un ServletContext_ (c'est-à-dire pour l'ensemble de
l'application Web), une requête ou une session HTTP alors elle doit
fournir une implémentation d'un listener. Une méthode de ce dernier sera
appelée par le conteneur à chaque fois que l'événement concerné
surviendra lors de la vie de l'application.

Les différents types de listeners sont représentés dans l'API Servlet
par les **interfaces** Java suivantes :

javax.servlet.ServletContextListener_
    Permet d'écouter les changements d'état du ServletContext_. Le
    conteneur Web avertit l'application de la création du
    ServletContext_ grâce à la méthode contextInitialized_
    et de la destruction du ServletContext_ grâce à la méthode
    contextDestroyed_.
    Il est important de comprendre que le ServletContext_ représente
    l'application Web. Donc un ServletContextListener_ est un moyen
    de réaliser des traitements au moment du lancement de l'application
    Web et/ou au moment de son arrêt.
javax.servlet.ServletContextAttributeListener_
    Permet d'écouter les changements d'état des attributs stockés dans
    le ServletContext_ (les attributs de portée application). Le
    conteneur avertit l'application de l'ajout d'un attribut (appel à la
    méthode ServletContextAttributeListener.attributeAdded_,
    de la suppression d'un attribut (appel à la méthode
    ServletContextAttributeListener.attributeRemoved_
    et de la modification d'un attribut (appel à la méthode
    ServletContextAttributeListener.attributeReplaced_.
javax.servlet.ServletRequestListener_
    Permet d'écouter l'entrée et/ou la sortie d'une requête de
    l'environnement de l'application Web. Le conteneur avertit
    l'application de l'entrée d'une requête à traiter grâce à la méthode
    requestInitialized_
    et de la sortie de la requête grâce à la méthode
    requestDestroyed_.
javax.servlet.ServletRequestAttributeListener_
    Permet d'écouter les changements d'état des attributs stockés dans
    la HttpServletRequest_ (les attributs de portée requête). Le
    conteneur avertit l'application de l'ajout d'un attribut (appel à la
    méthode
    ServletRequestAttributeListener.attributeAdded_,
    de la suppression d'un attribut (appel à la méthode
    ServletRequestAttributeListener.attributeRemoved_
    et de la modification d'un attribut (appel à la méthode
    ServletRequestAttributeListener.attributeReplaced_.
javax.servlet.http.HttpSessionListener_
    Permet d'écouter la création et la suppression d'une
    HttpSession_. Le conteneur avertit l'application de la création
    d'une session grâce à la méthode
    sessionCreated_
    et de la suppression d'une session grâce à la méthode
    sessionDestroyed_.
    La suppression d'une session signifie que soit elle a été invalidée
    par l'application elle-même grâce à la méthode
    HttpSession.invalidate_
    soit elle est arrivée à expiration et le conteneur a décidé de
    l'invalider.
javax.servlet.http.HttpSessionAttributeListener_
    Permet d'écouter les changements d'état des attributs stockés dans
    la HttpSession_ (les attributs de portée session). Le conteneur
    avertit l'application de l'ajout d'un attribut (appel à la méthode
    HttpSessionAttributeListener.attributeAdded_,
    de la suppression d'un attribut (appel à la méthode
    HttpSessionAttributeListener.attributeRemoved_
    et de la modification d'un attribut (appel à la méthode
    HttpSessionAttributeListener.attributeReplaced_.

Il existe également deux autres listeners Web : Le HttpSessionActivationListener_
et le HttpSessionBindingListener_.
Ils ne sont pas décrits ici car ils sont réservés à des usages plus
avancés de l'API Servlet.

Déclaration des listeners Web
*****************************

Une classe implémentant une ou plusieurs interfaces la désignant comme
un listener Web doit également être déclarée auprès du conteneur Web.
Pour cela, il suffit d'ajouter l'annotation `@WebListener`_ à la classe :

.. code-block:: java
    :caption: Exemple de ServletRequestListener

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.servlet.ServletRequestEvent;
    import javax.servlet.ServletRequestListener;
    import javax.servlet.annotation.WebListener;

    @WebListener
    public class MyServletRequestListener implements ServletRequestListener {

        @Override
        public void requestInitialized(ServletRequestEvent sre) {
            // ...
        }

        @Override
        public void requestDestroyed(ServletRequestEvent sre) {
            // ...
        }
    }

Si l'\ **on ne souhaite pas utiliser une annotation**, il est également
possible de déclarer un listener dans le fichier de déploiement
:file:`web.xml` grâce à la balise ``listener``.

.. code-block:: xml
    :caption: Déclaration d'un listener dans le fichier web.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app 
      xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" 
      xmlns="https://java.sun.com/xml/ns/javaee" 
      xsi:schemaLocation="https://java.sun.com/xml/ns/javaee 
                          https://java.sun.com/xml/ns/javaee/web-app_3_0.xsd" 
      version="3.0">

        <listener>
            <listener-class>{{ROOT_PKG}}.MyServletRequestListener</listener-class>
        </listener>

    </web-app>

Exemple d'utilisation d'un listener
***********************************

L'exemple (simple) ci-dessous consiste en un ServletContextListener_
dont le rôle est de réaliser un log applicatif signalant respectivement
le lancement et l'arrêt de l'application Web :

Exemple de ``ServletRequestListener``
::

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import javax.servlet.ServletContextEvent;
    import javax.servlet.ServletContextListener;
    import javax.servlet.annotation.WebListener;

    @WebListener
    public class LoggingListener implements ServletContextListener {
      @Override
      public void contextInitialized(ServletContextEvent sce) {
        sce.getServletContext().log("## Lancement de l'application ##");
      }

      @Override
      public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().log("## Arrêt de l'application ##");
      }
    }

Les filtres de Servlet
**********************

Il est parfois intéressant d'effectuer des opérations avant et/ou après
l'invocation de la servlet. Il s'agit souvent d'opérations communes à un
ensemble de requêtes d'une application Web.

Un filtre de Servlet est une classe implémentant l'interface Filter_.
Un filtre a son propre cycle de vie. Une fois créé, le conteneur
initialise le filtre en appelant sa méthode Filter.init_ et il signalera la 
destruction du filtre en appelant sa méthode Filter.destroy_.
L'opération de filtrage est réalisée grâce à la méthode Filter.doFilter_.

.. code-block:: java
    :caption: Exemple d'implémentation d'un filtre Web

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import java.io.IOException;

    import javax.servlet.Filter;
    import javax.servlet.FilterChain;
    import javax.servlet.FilterConfig;
    import javax.servlet.ServletException;
    import javax.servlet.ServletRequest;
    import javax.servlet.ServletResponse;

    public class MyFilter implements Filter {

        @Override
        public void init(FilterConfig filterConfig) throws ServletException {
            // ...
        }

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                                                                       throws IOException, ServletException {
            // ...
        }

        @Override
        public void destroy() {
            // ...
        }

    }

Déclaration des filtres
***********************

La déclaration d'un filtre Web auprès du conteneur se fait soit par
l'annotation `@WebFilter`_ soit dans le fichier de déploiement :file:`web.xml`.

Comme pour une Servlet, un filtre est associé à un ou plusieurs motifs
d'URL (URL pattern) indiquant au conteneur pour quelles requêtes HTTP le
filtre doit être appelé.


.. code-block:: java
    :caption: Déclaration d'un filtre Web par annotation

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import java.io.IOException;

    import javax.servlet.Filter;
    import javax.servlet.FilterChain;
    import javax.servlet.FilterConfig;
    import javax.servlet.ServletException;
    import javax.servlet.ServletRequest;
    import javax.servlet.ServletResponse;
    import javax.servlet.annotation.WebFilter;

    @WebFilter({"/subpart/*", "/otherpart/*"})
    public class MyFilter implements Filter {

        @Override
        public void init(FilterConfig filterConfig) throws ServletException {
            // ...
        }

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                                                                throws IOException, ServletException {
            // ...
        }

        @Override
        public void destroy() {
            // ...
        }

    }

Si **on ne souhaite pas utiliser une annotation**, il est également
possible de déclarer un listener dans le fichier de déploiement web.xml
grâce aux balises ``filter`` et ``filter-mapping``.

.. code-block:: xml
    :caption: Déclaration d'un filtre dans le fichier web.xml

    <?xml version="1.0" encoding="UTF-8"?>
    <web-app 
      xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" 
      xmlns="https://java.sun.com/xml/ns/javaee" 
      xsi:schemaLocation="https://java.sun.com/xml/ns/javaee 
                          https://java.sun.com/xml/ns/javaee/web-app_3_0.xsd" 
      version="3.0">

      <filter>
        <filter-name>MyFilter</filter-name>
        <filter-class>{{ROOT_PKG}}.MyFilter</filter-class>
      </filter>
      
      <filter-mapping>
        <filter-name>MyFilter</filter-name>
        <url-pattern>/subpart/*</url-pattern>
      </filter-mapping>

      <filter-mapping>
        <filter-name>MyFilter</filter-name>
        <url-pattern>/otherpart/*</url-pattern>
      </filter-mapping>
    </web-app>

Il est également possible de déclarer qu'un filtre doit être utilisé
pour des requêtes traitées par des Servlets spécifiques plutôt que
d'utiliser un modèle d'URL.

Implémentation d'un filtre
**************************

L'opération de filtrage est réalisée par la méthode Filter.doFilter_.

.. code-block:: java
    :caption: Principe général d'implémentation d'un filtre

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                                                        throws IOException, ServletException {
        // réaliser des opérations avant le traitement de la requête

        // appeler l'élément suivant dans la chaîne de filtrage
        chain.doFilter(request, response);

        // réaliser des opérations après le traitement de la requête
    }

Si plusieurs filtres doivent être déclenchés pour le traitement d'une
requête, alors l'appel à ``chain.doFilter(...)`` permet de passer au
filtre suivant. Un fois le dernier filtre appelé, l'appel à
``chain.doFilter(...)`` passera au traitement normal de la requête
(Servlet, JSP ou ressource statique).

Il est recommandé d'implémenter des filtres de manière à ce qu'ils
soient indépendants les uns des autres. En effet, si plusieurs filtres
sont appelés pour le traitement d'une requête, l'ordre dans lequel ces
filtres seront appelés n'est pas prédictible s'ils ont été déclarés avec
l'annotation `@WebFilter`_. En revanche, ils seront appelés dans
l'ordre des balises ``filter-mapping`` s'ils ont été déclarés à partir
du fichier de déploiement :file:`web.xml`

.. note::

    Une implémentation de filtre peut très bien ne pas appeler
    ``chain.doFilter(...)`` et choisir de générer directement une réponse.

Cas d'utilisation de filtres
****************************

Deux exemples d'implémentation de filtres simples mais efficaces.

Gestion de l'UTF-8
==================

Un cas facilement compréhensible est celui d'une application Web qui
poste les données de tous ses formulaires HTML en UTF-8. Nous avons vu
que par défaut, le conteneur Web utilise l'encodage ISO-8859-1
(Latin-1). Il est donc nécessaire de positionner le bon encodage grâce à
la méthode `ServletRequest.setCharacterEncoding(String)`_.
Cette opération répétitive est source d'oubli (et donc de bug). Il
serait préférable de garantir que cette méthode soit systématiquement
appelée avant chaque traitement de Servlet. Ce type de comportement peut
très facilement être implémenté au moyen d'un filtre Web.

.. code-block:: java
    :caption: Filtre UTF-8

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import java.io.IOException;

    import javax.servlet.Filter;
    import javax.servlet.FilterChain;
    import javax.servlet.FilterConfig;
    import javax.servlet.ServletException;
    import javax.servlet.ServletRequest;
    import javax.servlet.ServletResponse;
    import javax.servlet.annotation.WebFilter;

    @WebFilter("/*")
    public class Utf8RequestEncodingFilter implements Filter {

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                                                                    throws IOException, ServletException {
            request.setCharacterEncoding("UTF-8");
            chain.doFilter(request, response);
        }

        @Override
        public void init(FilterConfig filterConfig) throws ServletException {
        }

        @Override
        public void destroy() {
        }

    }

Génération de log
=================

Il peut être intéressant de garder une trace des paramètres HTTP reçus
lors des tests ou pour des statistiques. Le filtre ci-dessous écrit dans
les logs du serveur le nom et la valeur de tous les paramètres reçus :

.. code-block:: java
    :caption: Filtre de log de paramètres

  {% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

    import java.io.IOException;
    import java.util.ArrayList;
    import java.util.Arrays;
    import java.util.List;

    import javax.servlet.Filter;
    import javax.servlet.FilterChain;
    import javax.servlet.FilterConfig;
    import javax.servlet.ServletException;
    import javax.servlet.ServletRequest;
    import javax.servlet.ServletResponse;
    import javax.servlet.annotation.WebFilter;

    @WebFilter("/*")
    public class LogFilter implements Filter {

        @Override
        public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
                                                                        throws IOException, ServletException {
            request.getServletContext().log("parameters received: " + parametersToString(request));
            chain.doFilter(request, response);
        }

        private List<String> parametersToString(ServletRequest request) {
            List<String> parameters = new ArrayList<>();
            request.getParameterMap().forEach((k, v) -> parameters.add(k + "=" + Arrays.toString(v)));
            return parameters;
        }

        @Override
        public void init(FilterConfig filterConfig) throws ServletException {
        }

        @Override
        public void destroy() {
        }

    }

.. caution::

    L'utilisation conjointe des deux filtres ci-dessus peut poser problème.
    En effet, la méthode ``request.setCharacterEncoding(...)`` dans la
    classe ``Utf8RequestEncodingFilter`` doit être appelée avant que les
    paramètres de la requête ne soient accédés. Le filtre
    ``Utf8RequestEncodingFilter`` doit donc être placé **avant** le filtre
    ``LogFilter``. Malheureusement, cela ne peut pas être garanti par
    l'utilisation de l'annotation `@WebFilter`_.

On peut imaginer des traitements bien plus complexes grâce aux filtres :
contrôle des droits d'accès (autorisation), optimisation d'image,
chiffrement des données...

.. _Observateur: https://fr.wikipedia.org/wiki/Observateur_%28patron_de_conception%29
.. _ServletContext: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContext.html
.. _ServletContextListener: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextListener.html
.. _javax.servlet.ServletContextListener: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextListener.html
.. _contextInitialized: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextListener.html#contextInitialized-javax.servlet.ServletContextEvent-
.. _contextDestroyed: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextListener.html#contextDestroyed-javax.servlet.ServletContextEvent-
.. _javax.servlet.ServletContextAttributeListener: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextAttributeListener.html
.. _ServletContextAttributeListener.attributeAdded: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextAttributeListener.html#attributeAdded-javax.servlet.ServletContextAttributeEvent-
.. _ServletContextAttributeListener.attributeRemoved: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextAttributeListener.html#attributeRemoved-javax.servlet.ServletContextAttributeEvent-
.. _ServletContextAttributeListener.attributeReplaced: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContextAttributeListener.html#attributeReplaced-javax.servlet.ServletContextAttributeEvent-
.. _javax.servlet.ServletRequestListener: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestListener.html
.. _requestInitialized: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestListener.html#requestInitialized-javax.servlet.ServletRequestEvent-
.. _requestDestroyed: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestListener.html#requestDestroyed-javax.servlet.ServletRequestEvent-
.. _javax.servlet.ServletRequestAttributeListener: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestAttributeListener.html
.. _HttpServletRequest: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletRequest.html
.. _ServletRequestAttributeListener.attributeAdded: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestAttributeListener.html#attributeAdded-javax.servlet.ServletRequestAttributeEvent-
.. _ServletRequestAttributeListener.attributeRemoved: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestAttributeListener.html#attributeRemoved-javax.servlet.ServletRequestAttributeEvent-
.. _ServletRequestAttributeListener.attributeReplaced: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequestAttributeListener.html#attributeReplaced-javax.servlet.ServletRequestAttributeEvent-
.. _javax.servlet.http.HttpSessionListener: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionListener.html
.. _HttpSession: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSession.html
.. _sessionCreated: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionListener.html#sessionCreated-javax.servlet.http.HttpSessionEvent-
.. _sessionDestroyed: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionListener.html#sessionDestroyed-javax.servlet.http.HttpSessionEvent-
.. _HttpSession.invalidate: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSession.html#invalidate--
.. _javax.servlet.http.HttpSessionAttributeListener: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionAttributeListener.html
.. _HttpSessionAttributeListener.attributeAdded: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionAttributeListener.html#attributeAdded-javax.servlet.http.HttpSessionBindingEvent-
.. _HttpSessionAttributeListener.attributeRemoved: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionAttributeListener.html#attributeRemoved-javax.servlet.http.HttpSessionBindingEvent-
.. _HttpSessionAttributeListener.attributeReplaced: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionAttributeListener.html#attributeReplaced-javax.servlet.http.HttpSessionBindingEvent-
.. _HttpSessionActivationListener: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionActivationListener.html
.. _HttpSessionBindingListener: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpSessionBindingListener.html
.. _@WebListener: https://docs.oracle.com/javaee/7/api/javax/servlet/annotation/WebListener.html
.. _Filter: https://docs.oracle.com/javaee/7/api/javax/servlet/Filter.html
.. _Filter.init: https://docs.oracle.com/javaee/7/api/javax/servlet/Filter.html#init-javax.servlet.FilterConfig-
.. _Filter.destroy: https://docs.oracle.com/javaee/7/api/javax/servlet/Filter.html#destroy--
.. _Filter.doFilter: https://docs.oracle.com/javaee/7/api/javax/servlet/Filter.html#doFilter-javax.servlet.ServletRequest-javax.servlet.ServletResponse-javax.servlet.FilterChain-
.. _@WebFilter: https://docs.oracle.com/javaee/7/api/javax/servlet/annotation/WebFilter.html
.. _Filter.filterChain: https://docs.oracle.com/javaee/7/api/javax/servlet/Filter.html#doFilter-javax.servlet.ServletRequest-javax.servlet.ServletResponse-javax.servlet.FilterChain-
.. _ServletRequest.setCharacterEncoding(String): https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequest.html#setCharacterEncoding-java.lang.String-

