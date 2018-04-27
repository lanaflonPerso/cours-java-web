RequestDispatcher et MVC
########################

Le `request dispatcher`_
est un objet fourni par le conteneur Web. Il permet d'inclure ou de
déléguer des traitements lors de la prise en charge d'une requête HTTP.
Nous allons voir dans un premier temps comment cet objet peut être
utilisé. Dans un second temps, nous verrons ce que l'utilisation d'un
request dispatcher apporte dans la conception d'architecture Web en
prenant comme exemple le modèle MVC.

Le request dispatcher
*********************

Nous avons vu précédemment qu'il existe une classe ServletContext_
permettant notamment de stocker les attributs de portée application. Le
ServletContext_ représente le contexte d'une application Web et est
accessible depuis une servlet grâce à la méthode `getServletContext()`_.

Une instance de ServletContext_ permet également de récupérer une
instance de RequestDispatcher_ grâce aux méthodes :

`getResquestDispatcher(String path)`_
    Permet de récupérer une instance de RequestDispatcher pour
    transferer le traitement à la ressource dont le chemin d'URL est
    passé en paramètre

    ::

        RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/un/chemin");

    Selon la documentation, le chemin passé en paramètre **DOIT**
    commencer par /. Cependant, le chemin est interprété relativement au
    contexte racine de l'application.

`getNamedDispatcher(String name)`_
    Permet de récupérer une instance de RequestDispatcher pour
    transférer le traitement à la servlet dont le nom est passé en
    paramètre

    ::

          RequestDispatcher dispatcher = getServletContext().getNamedDispatcher("maServlet");

    Une servlet peut être nommée dans le fichier web.xml grâce à la
    balise <servlet-name> ou avec l'annotation `@WebServlet`_
    grâce à l'attribut name de l'annotation.

Une fois que nous disposons d'une instance d'un RequestDispatcher nous
pouvons appeler une de ses deux méthodes disponibles :

`void RequestDispatcher.include(ServletRequest request, ServletResponse response)`_
    Inclut le contenu de la ressource dans le résultat final renvoyé au
    client. Si le request dispatcher pointe sur un fichier HTML,
    l'ensemble du fichier sera inséré dans la réponse. Si le request
    dispatcher pointe sur une servlet, cette dernière est exécutée et sa
    sortie est insérée dans la réponse.
`void RequestDispatcher.forward(ServletRequest request, ServletResponse response)`_
    Délègue le traitement de la requête à une nouvelle ressource. La
    différence avec la méthode ``include`` est que la servlet qui
    appelle ``forward`` ne doit pas avoir produit de contenu dans la
    réponse.

Avec le request dispatcher, on voit apparaître la possibilité de créer
une chaîne de traitement pour une requête. Par exemple, une servlet peut
être utilisée pour valider les paramètres transmis par la requête et
effectuer un traitement propre à l'application. Puis, *via* un
RequestDispatcher, elle peut déléguer à une autre servlet le soin de
générer la réponse en utilisant la méthode ``forward``. C'est dans ce
modèle de traitement que les attributs de requête vus dans le chapitre
:ref:`attributs_web` vont être utiles. Chaque
servlet impliquée dans le traitement de la requête exploite et produit
des données qu'elle peut récupérer ou stocker comme attribut dans la
requête.

Le modèle MVC
*************

L'utilisation d'un RequestDispatcher_ pour segmenter le traitement d'une
requête HTTP a permis très tôt aux développeurs d'application Web en
Java d'imaginer un modèle d'architecture. Ce modèle est basé sur un
modèle de conception déjà utilisé pour le développement d'application
graphique : le MVC_ (modèle-vue-contrôleur).

Le MVC découpe le traitement applicatif selon trois catégories :

**Le modèle**
    Il contient les données applicatives ainsi que les logiques de
    traitement propres à l'application.
**La vue**
    Elle gère la représentation graphique des données et l'interface
    utilisateur
**Le contrôleur**
    Il est sollicité par les interactions de l'utilisateur ou les
    modifications des données. Il assure la cohérence entre le modèle et
    la vue.

Pour une application Web Java

-  le modèle peut être un simple objet Java qui encapsule la logique de
   l'application
-  la vue peut être une page HTML ou une Java Server Pages (JSP)
-  le contrôleur est une servlet chargée de valider les paramètres de la
   requête avant de les transmettre au modèle pour le traitement. Une
   fois ce traitement terminé, la servlet transmet le résultat à la vue
   grâce au RequestDispatcher.


Exercice
********

.. admonition:: Formulaire MVC
    :class: hint

    **Objectif**
        Développer une page MVC pour la saisie d'un formulaire d'adhésion en
        ligne. Le formulaire doit permettre de saisir les informations
        suivantes : email et mot de passe. Un champ permet de saisir à
        nouveau le mot de passe afin de s'assurer que l'utilisateur n'a pas
        fait d'erreur de saisie. De plus, l'utilisateur doit pouvoir cocher
        la case "J'ai lu et approuvé les conditions générales de ce site".

        Au moment de la soumission du formulaire, le serveur doit effectuer
        les vérifications suivantes :

        #. Le champ email doit être rempli et contenir une adresse mail
           valide
        #. Le champ mot de passe contient au moins 8 caractères et il
           correspond à celui saisi une seconde fois
        #. La case "J'ai lu et approuvé les conditions générales de ce site"
           est bien cochée

        Si une vérification échoue, le formulaire doit être réaffiché avec
        un message d'erreur indiquant clairement ce qui n'est pas correct.
        De plus, le formulaire doit se réafficher en renseignant les données
        saisies précédemment **sauf** le mot de passe.

        Pour cet exercice, n'utiliserez **aucun** contrôle de champ côté
        client.

        Lorsque tous les champs sont saisis correctement, une page de
        confirmation d'adhésion doit être affichée avec la mention :

        .. code-block:: text
        
            Votre inscription a bien été prise en compte le <date> à <heure> pour l'adresse mail <email>.

        Pour réaliser cette application, vous utiliserez une architecture
        MVC en utilisant notamment des JSP pour réaliser les vues. À vous de
        concevoir la ou les classes Java qui représenteront le modèle.

    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`.
   
.. _request dispatcher: https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html
.. _RequestDispatcher: https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html
.. _ServletContext: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContext.html
.. _getServletContext(): https://docs.oracle.com/javaee/7/api/javax/servlet/GenericServlet.html#getServletContext--
.. _getResquestDispatcher(String path): https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContext.html#getRequestDispatcher-java.lang.String-
.. _getNamedDispatcher(String name): https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContext.html#getNamedDispatcher-java.lang.String-
.. _getNamedDispatcher(String name): https://docs.oracle.com/javaee/7/api/javax/servlet/ServletContext.html#getNamedDispatcher-java.lang.String-
.. _void RequestDispatcher.include(ServletRequest request, ServletResponse response): https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html#include-javax.servlet.ServletRequest-javax.servlet.ServletResponse-
.. _void RequestDispatcher.forward(ServletRequest request, ServletResponse response): https://docs.oracle.com/javaee/7/api/javax/servlet/RequestDispatcher.html#forward-javax.servlet.ServletRequest-javax.servlet.ServletResponse-
.. _MVC:  https://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-contr%C3%B4leur
.. _@WebServlet: https://docs.oracle.com/javaee/7/api/javax/servlet/annotation/WebServlet.html

