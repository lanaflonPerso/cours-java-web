JSP : Java Server Pages
#######################

Nous avons vu que les servlets permettent facilement d'exécuter du code
Java pour traiter une requête HTTP. Cependant, l'API servlet n'est pas
très pratique pour générer une réponse orientée texte (telle qu'une page
HTML). Les Java Server Pages (JSP) ont été la première solution
introduite pour offrir une alternative plus simple pour l'écriture de
patron (template) de réponse.

Développer des JSP avec Wildfly
*******************************

Wildfly est un serveur livré avec une configuration par défaut conçue pour
un environnement de production.

Pour le développement de JSP, nous allons voir qu'il est plus
intéressant de configurer le serveur de test afin qu'il prenne en compte
nos modifications dans les JSP à la volée sans qu'il soit nécessaire de
redéployer l'application. Pour des raisons de performance, la prise en
compte à chaud des modifications n'est pas le comportement par défaut de
Wildfly.

Pour activer ce comportement, il va falloir modifier la configuration du
serveur. Pour cela, allez dans le répertoire d'installation de Wildfly et
ouvrez le fichier :file:`standalone/configuration/standalone.xml`. 
Aux alentours de la ligne 474 du fichier, vous
allez trouver la déclaration suivante :

.. code-block:: xml

    <servlet-container name="default">
        <jsp-config/>
        <websockets/>
    </servlet-container>

Faites une sauvegarde de ce fichier et remplacez cette configuration par
celle-ci :

.. code-block:: xml

    <servlet-container name="default">
        <jsp-config development="true" check-interval="1" modification-test-interval="1" recompile-on-fail="true"/>
        <websockets/>
    </servlet-container>


Attention, si vous faites une mauvaise manipulation, votre serveur peut
ne plus démarrer correctement.


Exercice
********

.. admonition:: Une première JSP
    :class: hint

    **Objectif**
        Créer et afficher dans un navigateur une JSP. À la racine de
        l'application Web (répertoire src/main/webapp dans le projet Maven),
        créer un fichier **index.jsp** avec le contenu suivant :

        .. code-block:: html

            <!DOCTYPE html>
            <html>
              <head>
                <title>Java EE</title>
              </head>
              <body>
                <p>Notre première JSP.</p>
              </body>
            </html>

    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

Si on s'en tient à l'exercice précédent, une page JSP ressemble
exactement à une page statique (comme une page HTML) : il n'en est
rien ! En fait le serveur transforme automatiquement une page JSP en une
servlet équivalente à :

::

    import java.io.IOException;
    import java.io.PrintWriter;

    import javax.servlet.ServletException;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;

    /*
    * En réalité la servlet créée à partir d'une page JSP
    * est plus complexe que le code ci-dessous.
    */
    public class index extends HttpServlet {
        
      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
                     throws ServletException, IOException {
        resp.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.write("<!DOCTYPE html>\n");
        out.write("<html>\n");
        out.write("  <head>\n");
        out.write("    <title>Java EE</title>\n");
        out.write("  </head>\n");
        out.write("  <body>\n");
        out.write("    <p>Notre première JSP.</p>\n");
        out.write("  </body>\n");
        out.write("</html>\n");
      }
    }

Tous les accès HTTP à la JSP ne retournent pas directement la page que
nous avons écrite mais exécutent la servlet qui a été générée par le
serveur.

L'extension **.jsp** d'un fichier suffit au serveur pour identifier une
JSP.
Nous allons voir maintenant comment nous pouvons ajouter du contenu
dynamique dans une JSP.

La spécification JSP a considérablement changé depuis son origine. Cela
signifie qu'il existe différentes façons de dynamiser une page JSP.

Dans la première version de la technologie JSP, il était proposé
d'insérer du code Java grâce aux balises **scriptlets**. Ce procédé est
totalement déprécié et, même si on en trouve de nombreux exemples sur le
Web, nous n'utiliserons absolument pas cette technique dans la suite de
ce chapitre.

EL : Expression Language
************************

Java EE intègre l'expression language (EL). L'EL est directement
utilisable dans une JSP. Il s'agit d'un langage permettant de manipuler
des expressions avec une syntaxe simplifiée. L'EL **n'est pas** un
langage de programmation. Il se limite à l'évaluation d'expression qui
retourne une valeur (booléenne, numérique, chaîne de caractères,
objet,...).

Une expression en EL est facilement reconnaissable car elle est
délimitée par ``${ }``.

.. code-block:: text

      ${myObject}               : l'attribut portant le nom "myObject"
      ${myObject.myProperty}    : équivalent à myObject.getMyProperty()
      ${myObject["myProperty"]} : équivalent à myObject.getMyProperty()
      ${myList[0]}              : pour accéder au premier élément d'une liste
      ${myMap["key"]}           : pour accéder à la valeur associée à la clé "key" d'une map

Dans l'expression :

.. code-block:: text

    ${myObject.myProperty}

myProperty correspond à une propriété JavaBeans de l'attribut myObject.
Cela signifie que cet objet doit posséder une méthode getMyProperty()
permettant d'accéder en lecture à la propriété.

Les opérateurs dans l'expression language
*****************************************

L'EL dispose également de différents opérateurs. Certains opérateurs
peuvent s'écrire indifféremment avec un symbole ou une abréviation :

+-------+-------+--------------------------+
| \+    |       | Addition (attention + ne |
|       |       | peut pas être utilisé    |
|       |       | comme opérateur de       |
|       |       | concaténation de chaîne  |
|       |       | de caractères comme en   |
|       |       | Java)                    |
+-------+-------+--------------------------+
| \-    |       | Soustraction             |
+-------+-------+--------------------------+
| \*    |       | Multiplication           |
+-------+-------+--------------------------+
| /     | div   | Division                 |
+-------+-------+--------------------------+
| %     | mod   | Modulo                   |
+-------+-------+--------------------------+
| ==    | eq    | Égalité                  |
+-------+-------+--------------------------+
| !=    | ne    | Inégalité                |
+-------+-------+--------------------------+
| <     | lt    | Inférieur à              |
+-------+-------+--------------------------+
| >     | gt    | Supérieur à              |
+-------+-------+--------------------------+
| <=    | le    | Inférieur ou égal à      |
+-------+-------+--------------------------+
| >=    | ge    | Supérieur ou égal à      |
+-------+-------+--------------------------+
| &&    | and   | Et logique               |
+-------+-------+--------------------------+
| \|\|  | or    | Ou logique               |
+-------+-------+--------------------------+
| !     | not   | Négation                 |
+-------+-------+--------------------------+
| empty |       | vraie si l'expression à  |
|       |       | droite est nulle, une    |
|       |       | chaîne vide, un tableau  |
|       |       | vide ou une map vide.    |
+-------+-------+--------------------------+

De plus, il est possible d'utiliser les parenthèses et l'opérateur
logique ternaire : **condition ? si vrai : si faux**

Exemple d'expressions

.. code-block:: text

    ${2 + 5}
    ${(2 + 5) < 10} équivalent à ${(2 + 5) lt 10}
    ${empty maliste ? "liste vide" : maliste[0]}
    ${not empty maliste ? maliste[0] : "liste vide"}

.. _jsp_objets_implicites:

Les objets implicites dans une JSP
**********************************

Dans une JSP, il existe une liste pré-définie d'objets qui sont
directement accessibles dans en EL :

**pageScope**
    Map permettant d'accéder aux différents attributs de portée (scope)
    **page**. Les attributs de portée page correspondent aux attributs
    déclarés dans la page.
**requestScope**
    Map permettant d'accéder aux différents attributs de portée (scope)
    **request**.
**sessionScope**
    Map permettant d'accéder aux différents attributs de portée (scope)
    **session**.
**applicationScope**
    Map permettant d'accéder aux différents attributs de portée (scope)
    **application**.
**param**
    Map permettant d'accéder aux paramètres de la requête HTTP.
**paramValues**
    Map permettant d'accéder aux paramètres de la requête HTTP sous
    forme de tableau. Pratique si un paramètre est transmis plusieurs
    fois dans une requête.
**header**
    Map permettant d'accéder aux valeurs des en-têtes HTTP de la
    requête.
**headerValues**
    Map permettant d'accéder aux valeurs du Header HTTP de la requête
    sous forme de tableau. Pratique si un en-tête est transmis plusieurs
    fois dans une requête.
**cookie**
    Map permettant d'accéder aux Cookies transmis dans la requête HTTP.
**initParam**
    Map permettant d'accéder aux paramètres d'initialisation (déclarées
    dans le :file:`web.xml`).
**pageContext**
    L'objet PageContext_
    de la page JSP. On trouve notamment dans cet objet les attributs
    request et response (respectivement de type HttpServletRequest_ et
    HttpServletResponse_).

On peut, par exemple, afficher dynamiquement des informations liées à la
requête dans une JSP :

.. code-block:: html

    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="ISO-8859-1">
        <title>Test JSP</title>
      </head>
      <body>
        <p>Bienvenue sur <strong>${header["Host"]}</strong> !</p>
        
        <p>Vous accédez actuellement à la page <strong>${pageContext.request.requestURI}</strong></p>
        <p>Votre navigateur Web est : <strong>${header["user-agent"]}</strong>.</p>
        <p>${empty param ? "Vous n'avez pas envoyé de paramètre au serveur" 
                            : "Vous avez envoyé des paramètres au serveur"}</p>
        <p>${empty cookie ? "Vous n'avez pas envoyé de cookie au serveur" 
                            : "Vous avez envoyé des cookies au serveur"}</p>
      </body>
    </html>

La résolution de portée des attributs dans une JSP
**************************************************

Nous avons vu qu'il existe dans une JSP les objets implicites :
pageScope, requestScope, sessionScope et applicationScope. Ces objets
permettent d'accéder aux attributs de leur portée respective. Par
exemple :

.. code-block:: text

    ${sessionScope["utilisateur"].nom}

Il est également possible de référencer directement l'attribut
utilisateur dans une page JSP :

.. code-block:: text

    ${utilisateur.nom}

Dans ce cas, l'attribut utilisateur est recherché successivement dans
les portées **page, requête, session (si elle existe) et enfin
application**. Le premier attribut trouvé portant ce nom est utilisé.

La recherche d'un attribut dans les différentes portées est réalisée par
la méthode `JspContext.findAttribute(String name)`_

Expression Language et gestion des exceptions
=============================================

Un apport majeur de l'EL par rapport à du code Java, est la façon dont
sont traités les références nulles et les dépassements d'index dans les
tableaux. Si une référence d'un attribut ou d'une propriété est nulle,
l'expression n'échouera pas, elle retournera simplement vide.

.. code-block:: text

    ${unAttribut.unePropriete.uneAutrePropriete}

L'expression ci-dessus est évaluée à vide si unAttribut est nul ou
unePropriete est nulle ou uneAutrePropriete est nulle. Cela rend le code
plus robuste et ne nécessite pas de vérifier un à un les éléments d'une
expression.

Pour les tableaux, accéder à un index qui dépasse la borne supérieure
est également évalué à vide.

.. code-block:: text

    ${paramValues["unParametre"][1000]}

Les directives de JSP
*********************

Il est possible d'utiliser les directives ``page``, ``include`` et
``taglib``.

La directive page
=================

La directive ``page`` permet de donner des informations sur le contexte
d'exécution de la JSP. Il est recommandé de placer cette directive sur
la première ligne de la JSP.

.. code-block:: jsp

    <%@page pageEncoding="UTF-8" contentType="text/html" %>

Cette directive accepte entre autres les attributs :

contentType
    Le type MIME du contenu généré par la JSP. La valeur par défaut est
    "text/html".
pageEncoding
    L'encodage de la page, la valeur par défaut est "ISO-8859-1".
    **Attention**, le fait de préciser l'encodage dans le header HTML
    n'est pas suffisant pour une JSP. En effet, le header HTML est
    interprété par la client mais pas par la JSP. L'attribut
    ``pageEncoding`` de la directive page est donc là pour informer le
    conteneur Web de l'encodage à utiliser réellement pour envoyer la
    réponse au client.
session
    Valeur booléenne pour indiquer si la page JSP participe à une session HTTP.
errorPage
    Contient un lien vers une page JSP à utiliser si une exception se
    produit lors du traitement de cette JSP. Dans ce cas, c'est le
    traitement de la page JSP d'erreur qui sera retourné au client.
isErrorPage
    Indique si la JSP est une JSP d'erreur. Dans ce cas, ``errorData``
    est disponible dans le ``pageContext``. ``errorData`` est de type
    javax.servlet.jsp.ErrorData_.

    .. admonition:: Exemple d'une JSP d'erreur

        .. code-block:: jsp

            <%@page pageEncoding="UTF-8" isErrorPage="true" contentType="text/html" %>
            <!DOCTYPE html>
            <html>
                <head>
                    <meta charset="UTF-8">
                </head>
                <body>
                    Une erreur est survenue : ${pageContext.errorData.throwable.message}
                </body>
            </html>

La directive include
====================

La directive ``include`` permet d'insérer le contenu d'une page (fichier
statique ou une autre JSP) au moment de la compilation de la JSP (i.e.
la conversion de la JSP en servlet).

.. code-block:: jsp

    <%@include file="fragment.html" %>

L'inclusion se fait à l'endroit où la directive est placée.

Pour la directive ``taglib``, nous y reviendrons ultérieurement.

Les balises d'action JSP
************************

JSP définit un ensemble de balises (action tags) pour réaliser des
actions simples. Ces balises commencent toutes par ``jsp:``

**<jsp:useBean/>**
    Permet de référencer ou de créer un objet Java.

    Pour référencer un objet (un java bean), on utilise les attributs
    suivants 

    -  id : donne le nom de l'attribut dans la page qui référencera
       l'objet
    -  beanName : donne le nom de l'attribut qui contient l'objet
    -  scope : donne la portée dans laquelle se situe l'attribut (page,
       request, session, application)
    -  type : le type Java complet (avec le nom de package) de l'objet


    .. code-block:: jsp
        :caption: Récupération d'un utilisateur en session

        <%@page pageEncoding="UTF-8" contentType="text/html" %>
        <!-- cet exemple ne fonctionne que s'il existe un bean utilisateur en session -->
        <jsp:useBean id="u" beanName="utilisateur" scope="session" type="fr.compagnie.appli.Utilisateur"/>
        <!DOCTYPE html>
        <html>
            <head>
            <meta charset="UTF-8">
            </head>
            <body>
                ${u.nom}
            </body>
        </html>

    .. warning::
    
        L'attribut DOIT exister pour pouvoir être récupéré
        avec ``<jsp:useBean>``. Sinon l'exécution de la JSP provoque une
        exception.

    L'utilité de ``<jsp:useBean>`` pour référencer un attribut est
    limité. Depuis l'introduction de l'EL, il est possible d'accéder
    facilement aux attributs avec des expressions de la forme
    ``${nomAttribut}``.

    Pour créer un objet, on utilise les attributs suivants 

    -  id : donne le nom de l'attribut qui référencera l'objet
    -  scope : donne la portée dans laquelle l'attribut sera stocké
       (page, request, session, application)
    -  class : le type Java complet (avec le nom de package) de l'objet

    .. code-block:: jsp
        :caption: Création d'un objet java.util.Date

        <%@page pageEncoding="UTF-8" contentType="text/html" %>
        <!DOCTYPE html>
        <html>
            <head>
            <meta charset="UTF-8">
            </head>
            <body>
                <jsp:useBean id="now" scope="page" class="java.util.Date"/>
                ${now}
            </body>
        </html>

**<jsp:setProperty/>**
    Permet de positionner les propriétés d'un objet à partir d'une
    valeur (attribut ``value`` de la balise) ou d'un paramètre de la
    requête (attribut ``param`` de la balise).

    .. code-block:: jsp
        :caption: Création d'un objet et positionnement des propriétés

        <%@page pageEncoding="UTF-8" contentType="text/html" %>
        <!DOCTYPE html>
        <html>
            <head>
                <meta charset="UTF-8">
            </head>
            <body>
                <jsp:useBean id="now" scope="page" class="java.util.Date"/>
                <jsp:useBean id="u" scope="session" class="fr.compagnie.appli.Utilisateur"/>
                <jsp:setProperty name="u" property="nom" param="nom"/>
                <jsp:setProperty name="u" property="age" param="age"/>
                <jsp:setProperty name="u" property="dateCreation" value="${now}"/>

                ${u.nom} ${u.age} ${u.dateCreation}
            </body>
        </html>

    Il existe une forme abrégée permettant de remplir automatiquement
    les propriétés d'un bean Java avec les paramètres de la requête
    entrante :

    .. code-block:: jsp

        <jsp:setProperty name="nomDuBean" property="*"/>

**<jsp:getProperty>**
    Affiche dans la page le contenu d'une propriété d'un attribut.


    .. code-block:: jsp
        :caption: Affichage des propriétés

        <%@page pageEncoding="UTF-8" contentType="text/html" %>
        <!DOCTYPE html>
        <html>
            <head>
            <meta charset="UTF-8">
            </head>
            <body>
                <jsp:useBean id="u" scope="page" class="fr.compagnie.appli.Utilisateur"/>
                <jsp:setProperty name="u" property="nom" param="nom"/>
                <jsp:setProperty name="u" property="age" param="age"/>

                <jsp:getProperty name="u" property="nom"/>
                <jsp:getProperty name="u" property="age"/>
            </body>
        </html>

    On obtient le même résultat en utilisant une EL, on préfèrera donc
    cette dernière qui est une forme plus courte et plus expressive :

    .. code-block:: text

        ${u.nom}
        ${u.age}

**<jsp:include/>**
    Permet d'inclure dynamiquement une page (statique ou une autre JSP).
    À la différence de la directive ``<%@include %>``, la balise action
    ``<jsp:include>`` est interprétée à chaque exécution de la JSP. Cela
    signifie que l'adresse de la page à inclure peut être calculée
    dynamiquement grâce à une EL. Cette balise est similaire à un appel
    à RequestDispatcher.include_.
    

    .. code-block:: jsp
        :caption: Inclusion d'une page en fonction d'un paramètre

        <%@page pageEncoding="UTF-8" contentType="text/html" %>
        <!DOCTYPE html>
        <html>
            <head>
                <meta charset="UTF-8">
            </head>
            <body>
                <jsp:useBean id="u" scope="page" class="fr.compagnie.appli.Utilisateur"/>
                <jsp:setProperty name="u" property="nom" param="nom"/>
                <jsp:setProperty name="u" property="age" param="age"/>

                <jsp:include page="${u.age lt 18 ? 'mineur.jsp' : 'majeur.jsp'}" />
            </body>
        </html>

    Il est possible de passer des paramètres à la page incluse grâce à
    la balise action ``<jsp:param/>`` 

    .. code-block:: jsp

        <jsp:include page="maPage.jsp">
            <jsp:param name="param1" value="valeur1" />
            <jsp:param name="param2" value="valeur2" />
        </jsp:include>

**<jsp:forward/>**
    Permet de déléguer le traitement de la requête à une autre ressource
    de l'application. Cette balise est similaire à un appel à
    RequestDispatcher.forward_.

    .. code-block:: jsp
        :caption: Un simple forward vers une autre page en fonction d'un paramètre

        <jsp:useBean id="u" scope="page" class="fr.compagnie.appli.Utilisateur"/>
        <jsp:setProperty name="u" property="nom" param="nom"/>
        <jsp:setProperty name="u" property="age" param="age"/>
        <jsp:forward page="${u.age lt 18 ? 'mineur.jsp' : 'majeur.jsp'}" />

    Il est possible de passer des paramètres à la page grâce à la balise
    action ``<jsp:param/>`` :

    .. code-block:: jsp

        <jsp:forward page="maPage.jsp">
            <jsp:param name="param1" value="valeur1" />
            <jsp:param name="param2" value="valeur2" />
        </jsp:forward>

Les Taglibs et la JSTL
**********************

En plus des balises d'action, l'utilisation des JSP peut être enrichie
grâce à l'inclusion de bibliothèques de balises : les Tag Libraries
(taglib en abbrégé).

Le développement de telles bibliothèques dépasse le cadre de ce cours.
Par contre nous allons voir comment utiliser la bibliothèque standard
fournie par le conteneur Web : **Java Standard Tag Library (JSTL)**.

Pour inclure une bibliothèque de balises dans une JSP, on utilise la
directive ``taglib`` :

.. code-block:: jsp

    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

L'attribut ``uri`` désigne le nom de la bibliothèque. Cette URI ne
pointe pas nécessairement sur une adresse Internet. Il s'agit simplement
d'un nom unique permettant au conteneur Web d'identifier
l'implémentation de la bibliothèque. L'attribut ``prefix`` désigne un
identifiant quelconque qui devra être placé devant chaque balise de la
bibliothèque afin de l'identifier sans ambiguïté. Ce mécanisme suit le
même principe que les espaces de nom XML.

La JSTL est découpée en cinq bibliothèques, chacune devant être incluse
par une directive ``taglib``.

La documentation de la JSTL est consultable sur
https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/

JSTL core
=========

Documentation : https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/c/tld-summary.html

.. code-block:: jsp

    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

Cette bibliothèque contient des balises pour la gestion des
conditions et des boucles (``c:if``, ``c:forEach``) et d'autres balises
permettant une programmation simplifiée dans les JSP.


.. code-block:: jsp
    :caption: Gestion des conditions

    <%@page pageEncoding="UTF-8" contentType="text/html" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
        </head>
        <body>
            <!-- c:if n'autorise pas le else -->
            <c:if test="${param['age'] lt 18}">
                Vous êtes mineur !
            </c:if>
            <c:if test="${param['age'] ge 18}">
                Vous êtes majeur !
            </c:if>

            <!-- c:choose permet de spécifier autant de c:when que l'on souhaite -->
            <c:choose>
                <c:when test="${param['age'] lt 18}">
                    Vous êtes mineur !
                </c:when>
                <c:otherwise>
                    Vous êtes majeur !
                </c:otherwise>
            </c:choose>
        </body>
    </html>

À noter que la bibliothèque core propose également une balise
``out`` qui permet de réaliser un échappement des caractères
réservés en HTML. Les caractères comme < et > seront automatiquement
transformés en &lt; et &gt; :

.. code-block:: jsp

    <c:out value="<div>Quel est le résultat de ce tag ?</div>"/>

Il est également possible de générer des URL absolues grâce à la
balise ``url``. Cette balise se charge de reconstruire l'URL à
partir du contexte racine de l'application. Par exemple, pour le
code JSP suivant :

.. code-block:: text

    <a href="<c:url value="/page_suivante.jsp"/>">Lien</a>

Si l'application est déployée dans le contexte racine **monappli**,
alors le code HTML généré par la JSP sera :

.. code-block:: jsp

    <a href="/monappli/page_suivante.jsp">Lien</a>

JSTL formater
=============

Documentation : https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/fmt/tld-summary.html

.. code-block:: jsp

    <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

Cette bibliothèque fournit des balises pour formater les données
(date, nombre, ...) mais également pour assurer une
internationalisation de l'application (gestion de la langue en
fonction des préférences du client).


.. code-block:: jsp
    :caption: Mise en forme d'un nombre

    <%@page pageEncoding="UTF-8" contentType="text/html" %>
    <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
        </head>
        <body>
            <fmt:formatNumber value="${1024 * 1024}"/>
        </body>
    </html>

JSTL functions
==============

Documentation : https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/fn/tld-summary.html

.. code-block:: jsp

    <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

Cette bibliothèque n'introduit pas de nouvelle balise mais des
fonctions utilisables avec l'expression language. Ces fonctions
servent principalement à manipuler les chaînes de caractères ou à
connaître la taille d'un tableau (``fn:length``)


.. code-block:: jsp
    :caption: Utilisation de diverses fonctions

    <%@page pageEncoding="UTF-8" contentType="text/html" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
        </head>
        <body>
            <c:set var="nom" value="${param['nom']}"/>
            <c:choose>
                <c:when test="${fn:length(param) eq 0}">
                    Vous n'avez envoyé aucun paramètre au serveur !
                </c:when>
                <c:when test="${empty nom}">
                    Vous n'avez pas envoyé votre nom au serveur !
                </c:when>
                <c:when test="${fn:startsWith(fn:toLowerCase(nom), 'david')}">
                    Tiens ! Vous aussi, vous vous appelez David.
                </c:when>
                <c:otherwise>
                    Bonjour ${nom} !
                </c:otherwise>
            </c:choose>
        </body>
    </html>

JSTL SQL
========

Documentation : https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/sql/tld-summary.html

.. code-block:: jsp

    <%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

Comme son nom l'indique, cette bibliothèque permet d'exécuter des
requêtes SQL dans les JSP. Nous verrons par la suite que son
utilisation reste très limitée car dans une architecture Java EE,
les accès aux bases de données sont généralement gérés par des
composants dédiés.

JSTL XML
========

Documentation : https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/x/tld-summary.html

.. code-block:: jsp

    <%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

Cette bibliothèque permet de lire et de manipuler des documents XML
directement dans les JSP.

Analyse d'un document XML

.. code-block:: jsp

    <%@page pageEncoding="UTF-8" contentType="text/html" %>
    <%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
    <!DOCTYPE html>
    <html>
        <head>
            <meta charset="UTF-8">
        </head>
        <body>
            <!-- on peut aussi charger un document XML externe grâce à l'attribut doc -->
            <x:parse var="u">
                <utilisateur>
                    <nom>jean</nom>
                    <age>21</age>
                </utilisateur>
            </x:parse>

            <x:forEach var="e" select="$u/utilisateur/*">
                <x:out select="name($e)"/> : <x:out select="$e"/><br>
            </x:forEach>
        </body>
    </html>


Exercices
*********

.. admonition:: JSP de temps
    :class: hint

    **Objectif**
        Écrire une JSP (sans code Java) qui donne la date et l'heure du
        serveur. La date et l'heure doivent être mises en forme de la façon
        suivante : |today| 12:01:24
    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

.. admonition:: Affichage des paramètres dans une JSP
    :class: hint

    **Objectif**
        Écrire une JSP (sans code Java) qui génère un tableau HTML contenant
        tous les paramètres HTTP reçus. La JSP doit gérer correctement le
        fait qu'un même paramètre peut être transmis plusieurs fois. Dans ce
        cas, les différentes valeurs seront séparées par une virgule. La JSP
        doit gérer correctement le fait qu'un paramètre peut contenir du
        code HTML. Dans ce cas, le code HTML doit être échappé pour
        s'afficher sous la forme d'un texte.

        Si on envoie les paramètres suivants

        .. code-block:: text

            ?language=java&version=1.6&version=1.7&version=1.8&motto=<strong>compile once, run anywhere</strong>

        Le résultat doit être :

        +------------+-----------------------------------------------+
        | motto      | <strong>compile once, run anywhere</strong>   |
        +------------+-----------------------------------------------+
        | language   | java                                          |
        +------------+-----------------------------------------------+
        | version    | 1.6, 1.7, 1.8                                 |
        +------------+-----------------------------------------------+

        L'ordre des lignes dans le tableau HTML est indifférent, cela n'a
        pas d'importance pour l'exercice.

    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

.. _PageContext: https://docs.oracle.com/javaee/7/api/javax/servlet/jsp/PageContext.html
.. _JspContext.findAttribute(String name): https://docs.oracle.com/javaee/7/api/javax/servlet/jsp/JspContext.html#findAttribute-java.lang.String-
.. _javax.servlet.jsp.ErrorData: https://docs.oracle.com/javaee/7/api/javax/servlet/jsp/ErrorData.html
.. _RequestDispatcher.include: https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html#include-javax.servlet.ServletRequest-javax.servlet.ServletResponse-
.. _RequestDispatcher.forward: https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html#forward-javax.servlet.ServletRequest-javax.servlet.ServletResponse-
.. _HttpServletRequest: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletRequest.html
.. _HttpServletResponse: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServletResponse.html

