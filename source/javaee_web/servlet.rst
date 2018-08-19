Les Servlets
############

Une servlet est un **composant Web** de Java EE. Elle permet de traiter
une requête entrante sur un serveur et de générer une réponse dynamique.
La plupart du temps, les servlets sont utilisées pour traiter des
requêtes HTTP et générer dynamiquement une réponse.

L'API **servlet** est définie par la spécification JSR-000369_ et la version 
actuelle est la 4.0.

Structure d'une servlet HTTP
****************************

Une servlet HTTP est une classe Java qui hérite de la classe 
javax.servlet.http.HttpServlet_ :

::

    package ROOT_PKG;

    import javax.servlet.http.HttpServlet;

    public class MyServlet extends HttpServlet {

    }

Par défaut, la classe javax.servlet.http.HttpServlet_
fournit des méthodes doXXX (XXX représentant une méthode HTTP) qui
seront appelées lorsque la servlet devra traiter une requête HTTP de la
méthode correspondante.

.. note::
    Une requête HTTP est identifiée par une méthode. Les méthodes HTTP
    standard sont : HEAD, OPTIONS, GET, POST, PUT, DELETE, PATCH. La méthode
    PATCH a été ajoutée tardivement et n'apparaît pas encore dans l'API
    servlet. Vous pouvez vous reporter à `l'article wikipedia sur
    HTTP <https://fr.wikipedia.org/wiki/Hypertext_Transfer_Protocol>`__ pour
    une explication succincte des différentes méthodes.

HttpServlet_ dispose donc des méthodes doGet, doPost, doPut...
L'implémentation par défaut de ces méthodes consiste à retourner un
message d'erreur HTTP. Chaque servlet doit donc redéfinir les méthodes
qui la concernent.

::

    package ROOT_PKG;

    import java.io.IOException;

    import javax.servlet.ServletException;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /*
     * Exemple d'une servlet acceptant les requêtes HTTP GET 
     */
    public class MyServlet extends HttpServlet {
        
      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
                     throws ServletException, IOException {
        // traitement de la requête et génération du résultat à retourner au client
      }

    }

Les méthodes doXXX ont toutes deux paramètres :
javax.servlet.http.HttpServletRequest_ et javax.servlet.http.HttpServletResponse_
qui représentent respectivement la requête HTTP entrante et la réponse
renvoyée par le serveur.

Pour l'instant, les méthodes qui vont nous intéresser sur ces classes
sont :

`String HttpServletRequest.setCharacterEncoding(String) <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequest.html#setCharacterEncoding-java.lang.String->`__
    Spécifie le format d'encodage des paramètres de la requête. Par
    défaut, l'encodage utilisé est `ISO
    8859-1 <https://fr.wikipedia.org/wiki/ISO_8859-1>`__ (Latin-1).
`String HttpServletRequest.getParameter(String) <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequest.html#getParameter-java.lang.String->`__
    Retourne la valeur d'un paramètre d'une requête GET ou POST. La
    méthode attend le nom du paramètre et retourne sa valeur ou null si
    le paramètre n'existe pas.
`java.util.Map<java.lang.String,java.lang.String[]> HttpServletRequest.getParameterMap() <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletRequest.html#getParameter-java.lang.String->`__
    Retourne une Map des paramètres d'une requête GET ou POST. La clé
    dans la Map correspond au nom du paramètre. La valeur est un tableau
    de chaînes de caractères. En effet, un paramètre peut être présent
    plusieurs fois dans une requête.
`void HttpServletResponse.setContentType(String) <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletResponse.html#setContentType-java.lang.String->`__
    Positionne le type de contenu MIME de la réponse HTTP pour informer
    le client du format de la réponse. Par exemple : "text/html" pour
    une page HTML.
`void HttpServletResponse.setCharacterEncoding(String) <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletResponse.html#setCharacterEncoding-java.lang.String->`__
    Indique l'encodage caractère du flux de réponse. L'appel à
    HttpServletResponse.getWriter() tient compte de l'encodage
    positionné. Il faut donc appeler cette méthode avant
    HttpServletResponse.getWriter()
`java.io.PrintWriter HttpServletResponse.getWriter() <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletResponse.html#getWriter-->`__
    Retourne un objet de type PrintWriter qui permet d'écrire la réponse
    dans le flux de sortie. L'objet PrintWriter offre des méthodes write
    pour générer une réponse au format texte (comme une page HTML).
`javax.servlet.ServletOutputStream HttpServletResponse.getOutputStream() <https://docs.oracle.com/javaee/7/api/javax/servlet/ServletResponse.html#getOutputStream-->`__
    Retourne un objet représentant le flux de sortie en mode binaire.
    Cette méthode est utile lorsque la réponse générée est au format
    binaire (comme une image par exemple).

::

    package ROOT_PKG;

    import java.io.IOException;

    import javax.servlet.ServletException;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /*
     * Une servlet qui salue la personne qui envoie
     * son nom dans le paramètre name.
     */
    public class HelloServlet extends HttpServlet {
        
      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
                     throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        String name = req.getParameter("name");

        resp.setContentType("text/plain");
        resp.setCharacterEncoding("utf-8");
        resp.getWriter().write("Hello " + name + "!");
      }

    }

Configuration du déploiement d'une servlet
******************************************

Une servlet n'est pas une classe Java comme les autres, il s'agit d'un
**composant Java EE** qui va être pris en charge par le serveur
d'application. Le serveur d'application a besoin de savoir pour
quelle(s) URL cette servlet sera responsable de traiter les requêtes et
de fournir la réponse.

La méthode la plus simple pour configurer le déploiement d'une servlet
consiste à utiliser l'annotation `@WebServlet`_ sur la classe.

::

    package ROOT_PKG;

    import java.io.IOException;

    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    @WebServlet("/hello")
    public class HelloServlet extends HttpServlet {

      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
                     throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        String name = req.getParameter("name");

        resp.setContentType("text/plain");
        resp.setCharacterEncoding("utf-8");
        resp.getWriter().write("Hello " + name + "!");
      }

    }

Pour la servlet ci-dessus, l'annotation `@WebServlet`_ précise le motif de
l'URL (URL pattern) pour lequel la servlet devra être sollicitée (dans
cet exemple "/hello"). Une fois l'application déployée dans un serveur
de test en local, une requête de la forme

::

    https://localhost:8080/[nom de l'application]/hello?name=David

devrait répondre

::

    Hello David!

Chemin absolu d'URL dans une application Web
============================================

Le motif d'URL dans l'exemple précédent est "/hello". Le / est
obligatoire est dénote donc un chemin absolu. Néanmoins dans une
servlet, un chemin absolu commence non pas à la racine du serveur mais à
la racine de l'application.

Ainsi pour une application déployée dans le contexte racine
**"/monappli"**, une servlet dont le motif d'URL est **"/hello"** sera
accessible par le chemin **"/monappli/hello"** et non pas "/hello".

Cette astuce est très pratique car elle dispense les servlets de
connaître le contexte racine d'une application. Cela peut néanmoins
entraîner une certaine confusion chez les développeurs entre les URL qui
seront effectivement retournées au client (comme les liens dans une page
Web par exemple) et les URL manipulées côté serveur.

Motif d'URL d'une Servlet
=========================

Comme nous l'avons vu dans la section précédente, une servlet pour être
déployée a besoin d'un ou plusieurs motifs d'URL indiquant le chemin des
requêtes qu'elle prend en charge. Il existe plusieurs syntaxes qui sont
toutes équivalentes :

::

    @WebServlet("/hello")

::

    @WebServlet({"/hello"})

::

    @WebServlet(urlPatterns={"/hello"})

Il est possible de donner plusieurs motifs d'URL indiquant que la même
servlet peut être sollicitée à partir de chemins différents.

::

    @WebServlet({"/hello", "/bonjour"})

::

    @WebServlet(urlPatterns={"/hello", "/bonjour"})

Enfin, il est possible d'utiliser le caractère générique \*. Par contre
son utilisation est limitée car il ne peut apparaître que **comme
premier ou dernier** élément d'un motif :

::

    // Toutes les URL se terminant par .html
    @WebServlet("*.html")

::

    // Toutes les URL commençant par /hello/
    @WebServlet("/hello/*")


Utilisation du fichier de déploiement web.xml
*********************************************

Nous avons vu que l'annotation @WebServlet_ permet d'indiquer comment
une servlet doit être déployée dans le serveur. S'il préfère, le
développeur a la possibilité de spécifier ces informations dans le
fichier de déploiement :file:`web.xml` plutôt que d'utiliser une annotation.

Les annotations n'ont été introduites dans le langage Java que depuis la
version 5. Pour J2EE, le recours au fichier de déploiement :file:`web.xml` était
la seule façon de déclarer les servlets. Ce fichier reste donc encore
aujourd'hui très utilisé par les développeurs, particulièrement pour
déclarer des servlets provenant de frameworks et de bibliothèques tiers.
Pour déclarer une servlet dans une fichier :file:`web.xml`, il suffit d'associer
un identifiant avec le nom de la classe de la servlet. Ensuite, on
précise un ou des motifs d'URL pour cette servlet de la façon suivante :

.. code-block :: xml

    <web-app 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
        xmlns="http://xmlns.jcp.org/xml/ns/javaee" 
        xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd" 
        version="4.0">
      
      <!-- la déclaration de la servlet -->
      <servlet>
        <servlet-name>nomLogiqueDeLaServlet</servlet-name>
        <!-- le nom de la classe implémentant la servlet (précédé du nom du package) -->
        <servlet-class>le.nom.complet.de.la.classe.de.la.Servlet</servlet-class>
      </servlet>
      
      <!-- l'association de la servlet avec un motif d'URL -->
      <servlet-mapping>
        <servlet-name>nomLogiqueDeLaServlet</servlet-name>
        <!-- le motif d'url (par exemple *.html ou /servlet) -->
        <url-pattern>/ma-servlet</url-pattern>
      </servlet-mapping>

    </web-app>

Pour rappel, le fichier :file:`web.xml` doit **obligatoirement** se trouver dans
le répertoire :file:`WEB-INF` de l'application Web finale. Dans un projet Maven,
on placera donc ce fichier dans le répertoire
:file:`src/main/webapp/WEB-INF`.

.. note::
    
    Java EE est une plate-forme pour laquelle les développeurs
    d'applications implémentent des **composants** (Web, métier, ...). Pour
    fournir les informations de déploiement de ces composants, nous verrons
    qu'il est toujours possible d'utiliser des annotations ou des
    descripteurs de déploiement (des fichiers XML). L'utilisation
    d'annotations offre l'avantage de déclarer les informations au plus près
    du code. Au contraire, le descripteur de déploiement centralise
    l'ensemble des informations pour une application. Il permet une plus
    grande souplesse au détriment de la verbosité et de la nécessité de
    maintenir un fichier XML.

Exercice
********

.. admonition:: Traitement d'un formulaire
    :class: hint

    **Objectif**
        Réaliser une application Web qui fournit une page d'accueil
        présentant un formulaire Web. 
        
        Le formulaire permet de saisir un code produit
        et le libellé d'un produit. Lorsqu'utilisateur envoie les données au serveur,
        ce dernier répond par une page qui rappelle le nom du produit et qui
        affiche un code barre 2D correspondant à son code.
        
        Pour la génération du code barre, vous utiliserez une servlet fournie par une
        bibliothèque tierce : **barcode4j**. Cette servlet génère des codes
        barres à la volée.

    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Ajout de barcode4j dans le projet**
        Maven va vous permettre de récupérer automatiquement les
        bibliothèques qui vont vous être utiles pour cet exercice. Ouvrez le
        fichier :file:`pom.xml` du projet et dans la balise ``<dependencies>``,
        ajoutez les deux dépendences suivantes :

        .. code-block:: xml

            <dependency>
              <groupId>net.sf.barcode4j</groupId>
              <artifactId>barcode4j</artifactId>
              <version>2.1</version>
            </dependency>
            <dependency>
              <groupId>avalon-framework</groupId>
              <artifactId>avalon-framework-api</artifactId>
              <version>4.2.0</version>
            </dependency>

        La sauvegarde du fichier :file:`pom.xml` dans votre IDE doit entraîner un
        téléchargement par Maven de ces dépendances et leur ajout dans la
        configuration du projet.

        La servlet fournie par barcode4j s'appelle :
        ``org.krysalis.barcode4j.servlet.BarcodeServlet``

        Une fois la servlet déclarée dans le fichier :file:`web.xml`, 
        vous pouvez y accéder en passant des paramètres HTTP détaillés dans la
        `documentation <http://barcode4j.sourceforge.net/2.1/servlet.html>`__.

        Un code barre 2D correspond au type **datamatrix** pour la servlet
        barcode4J. Autrement dit, il faut passer ``type=datamatrix`` comme
        paramètre à cette servlet.

        .. figure:: assets/servlet/barcode4j-example.png
        
            Exemple de code barre 2D (datamatrix) généré par barcode4

    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

.. _JSR-000369: https://jcp.org/aboutJava/communityprocess/final/jsr369/index.html
.. _javax.servlet.http.HttpServlet: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServlet.html
.. _HttpServlet: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServlet.html
.. _javax.servlet.http.HttpServletRequest: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletRequest.html
.. _javax.servlet.http.HttpServletResponse: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletResponse.html
.. _HttpServletRequest: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletRequest.html
.. _HttpServletResponse: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletResponse.html
.. _@WebServlet: https://docs.oracle.com/javaee/7/api/javax/servlet/annotation/WebServlet.html


