.. highlight:: html

Introduction à AngularJS
########################

|ajs| est un framework JavaScript open source développé par Google. Il permet
de concevoir des interactions riches dans une page Web et plus spécifiquement
des SPA (*Single Page Application*).

Contrairement à des bibliothèques comme JQuery_, l'objectif de |ajs| n'est
pas de fournir des fonctionnalités avancées pour manipuler le DOM_. |ajs| est
un framework MVC_ grâce auquel le développeur conçoit un modèle, des contrôleurs
et des services. À partir de là, il est possible de développer des vues (des pages
HTML) qui vont afficher les données du modèle. Une interaction utilisateur
(clique, survole du pointeurs de souris, entrée clavier...) peut solliciter un
contrôleur qui va mettre à jour le modèle. En retour, un mécanisme de *bind* va
déclencher une mise à jour de la vue en fonction des données modifiées dans le modèle. 

Installation de AngularJS
*************************

|ajs| s'installe comme un fichier JavaScript dans les pages HTML qui le nécessitent.
Vous pouvez `télécharger le fichier <https://angularjs.org/>`__ depuis le site ou
bien vous pouvez le déclarer comme dépendance grâce à Bower_ :

.. code-block:: shell

    bower install angularjs --save 

.. note::

    Bower_ est un gestionnaire de dépendances et de packages pour les ressources
    Web. Bower_ est accessible depuis NPM_ (le gestionnaire de packages de 
    Node.js).

    .. code-block:: shell
        :caption: installation de Bower
            
        npm install -g bower

    Puis vous pouvez initialiser un projet géré par Bower_ en tapant la commande
    suivante dans le répertoire du projet Web :
    
    .. code-block:: shell
    
        bower init

    Bower_ installe les fichiers téléchargés dans les répertoire :file:`bower_components`.
    Pour |ajs|, il faut donc ajouter dans les fichiers HTML la balise ``<script>``
    suivante :
    
    ::
    
        <script src="bower_components/angular/angular.js"></script>

.. note::

    Pour des raisons de portabilité, les exemples de ce chapitre référencent |ajs| à
    partir d'une URI CDN (*Content Delivery Network*).
        
Premier exemple sans contrôleur
*******************************

.. code-block:: html
    :linenos:

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <div>
            <label>Nom :</label>
            <input type="text" ng-model="nom">
        </div>
        <div>Bonjour <span ng-bind="nom"> !</div>
    </body>
    </html>

|ajs| permet d'ajouter des directives dans la page HTML (la vue). Ces directives
permettent de réaliser des mises à jour automatiques de la page. Certaines directives
sont facilement identifiables car elles sont préfixées par **ng-**. Cependant,
certaines balises HTML sont également considérées comme des directives par
|ajs|. C'est notamment le cas de la balise ``<input>`` pour notre exemple précédent.
La liste complète des directives supportées est disponible dans la
`documentation <https://docs.angularjs.org/api/ng/directive>`__. Nous verrons
dans un chapitre avancé qu'il est possible de définir ses propres directives.

Pour l'exemple précédent, les directives sont les suivantes :

ng-app
    À la ligne 7, la balise ``<body>`` contient l'attribut ``ng-app`` qui est
    une directive permettant de signaler une portion de page gérée par |ajs|.
    Après le chargement de la page, |ajs| recherche la directive ``ng-app``
    qui permet de délimiter une application |ajs|.
input
    À la ligne 10, la balise ``<input>`` est bien une directive car elle est
    utilisée dans le corps d'une application |ajs|. Cela va permettre d'associer
    la valeur de l'input à une donnée du modèle.
ng-model
    À la ligne 10 toujours, la directive ``ng-model`` permet de lier la valeur
    de la balise ``<input>`` avec un attribut du modèle appelé ``nom``. Nous
    n'avons pas besoin de créer le modèle, |ajs| le fait implicitement pour nous :
    c'est ce qu'on appelle le ``scope``. Le lien (*binding*) est bidirectionnel :
    toute modification de la valeur dans la balise ``<input>`` met à jour l'attribut
    du modèle et toute modification de l'attribut du modèle met à jour
    la valeur de la balise ``<input>``    
ng-bind
    À la ligne 12, la directive ``ng-bind`` permet de lier le contenu de la
    balise ``<span>`` avec  la valeur de l'attribut ``nom`` du modèle. Tout
    changement de la valeur de cet attribut entraîne une mise à jour du contenu
    de la balise. 

Pour comprendre la notion de lien bidirectionnel (*binding*), vous pouvez essayer
l'exemple ci-dessous :

.. code-block:: html
    :linenos:

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <div>
            <label>Nom :</label>
            <input type="text" ng-model="nom">
        </div>
        <div>
            <label>Nom :</label>
            <input type="text" ng-model="nom">
        </div>
    </body>
    </html>

Dans cet exemple, les deux directives input_ sont liées au même attribut de modèle.
Le changement de valeur d'un input_ entraîne le changement de valeur de l'attribut
du modèle qui entraîne la mise à jour de la valeur de l'autre input_.

Normalisation des noms
**********************

|ajs| utilise un mécanisme dit de *normalisation des noms*. 
Les conventions de nommage ne sont pas nécessairement les mêmes en HTML et en JavaScript.

Par convention, lorsqu'une directive apparaît dans le code HTML, si son nom est
composé de plusieurs mots, alors ils sont séparés par un tiret (par exemple ``ng-app``).

Par contre, dans le code JavaScript, le nom des directives se note en `écriture
dromadaire <https://fr.wikipedia.org/wiki/Camel_case>`__ (par exemple ngApp_).

De plus, afin de permettre d'écrire avec |ajs| des pages HTML valides, il est
possible de préfixer les directives par **data-** afin de respecter le mécanisme
HTML 5 d'ajout `d'attributs non standards <https://www.w3schools.com/tags/att_global_data.asp>`__.

.. code-block:: html
    :caption: Utilisation du préfixe data- en HTML 5

    <body data-ng-app>
    ...
    </body>

Expression et interpolation
***************************

|ajs| fournit son propre `langage d'expression <https://docs.angularjs.org/guide/expression>`__
qui permet de définir une expression liée au modèle ou un appel de méthode
pour la gestion des événements.

.. code-block:: javascript
    :caption: Exemple d'expressions
    
    2 + 2
    var1 + var2
    maValeur > 0 ? "ok" : "ko"
    items[index]

De plus, |ajs| fournit un mécanisme d'interpolation qui permet d'écrire des expressions
n'importe où dans la section d'une page HTML gérée par ngApp_. Pour cela, il
faut entourer l'expression avec **{{}}**.

.. code-block:: html

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        2 + 3 = {{2 + 3}}
    </body>
    </html>

L'interpolation joue le même rôle que la directive ngBind_ puisqu'elle permet
de créer une liaison entre une portion du texte HTML et le résultat de l'évaluation
de l'expression. Nous pouvons donc réécrire notre premier exemple en utilisant
une interpolation :

.. code-block:: html
    :linenos:

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <div>
            <label>Nom :</label>
            <input type="text" ng-model="nom">
        </div>
        <div>Bonjour {{nom}} !</div>
    </body>
    </html>
 
À la ligne 12, nous avons remplacé la directive ngBind_ par une interpolation
de l'expression ``nom`` pour lier le texte HTML à la valeur de l'attribut ``nom``
dans le modèle.

Quelques directives
*******************

Cette section présente quelques directives fournies par |ajs|. 
Une directive peut apparaître dans une page HTML comme une balise ou un attribut
(et plus rarement comme une classe dans l'attribut ``class``).
Pour une liste complète des directives disponibles, reportez-vous à la 
`documentation officielle <https://docs.angularjs.org/api/ng/directive/>`__.

Tout d'abord, |ajs| fournit des directives qui portent le même nom que des
balises HTML. Il s'agit de : a_, form_, textarea_, input_, script_ et select_.
Cela signifie que ces balises sont comprises par |ajs| qui en étend le comportement.
Hormis pour la balise script_, ces directives existent pour permettre une intégration
plus simple pour le développeur. Par exemple la directive form_ permet d'ajouter 
des fonctionnalités avancées pour la validation de formulaire.

Ensuite, |ajs| fournit une directive pour chaque événement HTML.
Ainsi on trouve les directives ngBlur_, ngChange_, ngClick_, ngCopy_, ngCut_, ngDblclick_,
ngFocus_, ngKeydown_, ngKeyup_, ngKeypress_, ngMousedown_, ngMouseup_, ngMouseleave_,
ngMouseenter_, ngMousemove_, ngMouseover_, ngPaste_, ngSubmit_. Ces directives
permettent de spécifier des expressions |ajs| et donc de lier un
événement à un appel d'une méthode de contrôleur. Nous verrons au chapitre suivant comment
déclarer et utiliser des contrôleurs dans notre application.

|ajs| fournit également des directive pour certains attributs HTML qu'il peut être
utile de lier à des attributs du modèle pour gérer dynamiquement le style ou les liens.
On trouve ainsi la directive ngSrc_ pour les images, la directive ngHref_ pour les liens
et plus généralement les directives ngClass_ et ngStyle_ pour l'ensemble des éléments
HTML. 

.. code-block:: html
    :caption: Exemple d'utilisation de ngClass, ngStyle et ngSrc
    :linenos:

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <style>
            .theme-soft {
                background-color: white;
                color: black;
            }

            .theme-dark {
                background-color: black;
                color: white;
            }
        </style>
    </head>
    <body ng-app class="ng-class: classeFond">
        <div>
            <label>Thème :</label>
            <select ng-model="classeFond">
                <option value="">--</option>
                <option value="theme-soft">Thème clair</option>
                <option value="theme-dark">Thème sombre</option>
            </select>
        </div>

        <div>
            <label>Couleur :</label>
            <select ng-model="couleur">
                <option value="">--</option>
                <option value="red">rouge</option>
                <option value="yellow">jaune</option>
                <option value="green">vert</option>
                <option value="blue">bleu</option>
            </select>
        </div>
        <div ng-style="{'color': couleur}">Bonjour Angular !</div>

        <div>
            <label>Image :</label>
            <select ng-model="photo">
                <option value="">--</option>
                <option value="https://cdn.pixabay.com/photo/2018/02/15/21/55/sunset-3156440_960_720.jpg">Soleil</option>
                <option value="https://cdn.pixabay.com/photo/2017/12/18/01/41/the-sea-3025268_960_720.jpg">Océan</option>
                <option value="https://cdn.pixabay.com/photo/2017/01/18/21/34/cyprus-1990939_960_720.jpg">Arbres</option>
            </select>
        </div>
        <div><img ng-src="{{photo}}"></div>
    </body>
    </html>

Enfin, |ajs| offre des directives particulières pour dynamiser le rendu de la page.

ngApp_
    Cette directive permet d'indiquer la portion de la page HTML qui est gérée
    par |ajs| (il est possible de placer cette directive directement sur la
    balise ``html`` de la page). Elle permet d'initialiser |ajs| sans avoir
    besoin d'écrire de code JavaScript. La directive ngApp_ accepte comme
    valeur un nom d'application. Nous verrons au chapitre suivant que cela
    permet d'étendre le framework avec notre propre code. Notamment pour créer
    des contrôleurs.

ngBind_
    Cette directive permet de remplacer le contenu HTML d'un élément par le résultat
    de l'expression passée à ngBind_. De plus cette directive crée une liaison (*binding*)
    qui assure que le contenu HTML de l'élément sera mis à jour lorsque l'expression
    sera réévaluée.

ngDisabled_
    Cette directive permet de gérer dynamiquement la valeur de l'attribut ``disabled``
    pour les éléments HTML qui le supporte (``<input>``, ``<button>``, ``<select>``...).

ngHide_ / ngShow_
    Ces directives permettent de cacher (respectivement afficher) un élément HTML
    si son expression est évaluée ``true``.

ngIf_
    Cette directive crée l'arborescence HTML si son expression est évaluée à ``true``.

ngInclude_
    Cette directive insère un document à partir de l'URI donnée.
    
ngRepeat_
    Cette directive réalise une itération sur une liste et produit une arborescence
    DOM_ pour chacun des éléments de la liste :
    
    ::
    
        <!doctype html>
        <html>
        <head>
            <meta charset="utf-8">
            <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        </head>
        <body ng-app>
            <ul>
                <li ng-repeat="item in ['Premier', 'Deuxième', 'Troisième']">{{item}}</li>
            </ul>
        </body>
        </html>

    
ngModel_
    Cette directive associe un élément ``<input>``, ``<select>`` ou
    ``<textarea>`` avec un attribut du modèle. Elle crée un lien bidirectionnel
    (*binding*) entre l'élément et le modèle.

ngModelOptions_
    Cette directive permet de modifier la manière dont la liaison doit se faire
    entre la directive ngModel_ et le modèle. ngModelOptions_ accepte un objet
    JavaScript avec les options ``updateOn`` et ``debounce``.
    
    updateOn
        donne le nom de l'événement HTML qui déclenche la mise à jour du modèle.
        Par exemple, il est possible de spécifier la valeur :code:`"blur"` pour
        réaliser la mise à jour lorsque l'élément perd le focus.
    debounce
        donne en millisecondes un délai entre l'événement de mise à jour et la
        mise à jour du modèle. Cela permet un décalage entre la saisie et la
        mise à jour de la vue.
        
    .. note::
        
        ngModelOptions_ accepte aussi un attribut ``timezone`` si l'élément
        associé est un ``<input>`` représentant une date afin d'indiquer le fuseau
        horaire qui doit être utilisé pour afficher la date.
    

.. code-block:: html
    :caption: Exemple d'utilisation de directives

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <input type="checkbox" ng-model="selectionne">Cliquez pour activer/désactiver<br>
        <label>Expéditeur</label>
        <input type="text" ng-model="expediteur" ng-model-options="{debounce: 500}" 
                           ng-disabled="! selectionne">
        <div ng-show="selectionne">Ceci est un message de {{expediteur}}</div>
    </body>
    </html>

.. |ajs| replace:: `AngularJS <https://docs.angularjs.org/guide>`__
.. _Bower: https://bower.io/
.. _JQuery: https://jquery.com
.. _DOM: https://www.w3schools.com/js/js_htmldom.asp
.. _MVC: https://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-contr%C3%B4leur
.. _NPM: https://www.npmjs.com/
.. _input: https://docs.angularjs.org/api/ng/directive/input
.. _select: https://docs.angularjs.org/api/ng/directive/select
.. _ngApp: https://docs.angularjs.org/api/ng/directive/ngApp
.. _ngBind: https://docs.angularjs.org/api/ng/directive/ngBind
.. _a: https://docs.angularjs.org/api/ng/directive/a
.. _form: https://docs.angularjs.org/api/ng/directive/form
.. _textarea: https://docs.angularjs.org/api/ng/directive/textarea
.. _script: https://docs.angularjs.org/api/ng/directive/script
.. _ngHref: https://docs.angularjs.org/api/ng/directive/ngHref
.. _ngBlur: https://docs.angularjs.org/api/ng/directive/ngBlur
.. _ngChange: https://docs.angularjs.org/api/ng/directive/ngChange
.. _ngClick: https://docs.angularjs.org/api/ng/directive/ngClick
.. _ngCopy: https://docs.angularjs.org/api/ng/directive/ngCopy
.. _ngCut: https://docs.angularjs.org/api/ng/directive/ngCut
.. _ngDblClick: https://docs.angularjs.org/api/ng/directive/ngDblclick
.. _ngFocus: https://docs.angularjs.org/api/ng/directive/ngFocus
.. _ngKeyDown: https://docs.angularjs.org/api/ng/directive/ngKeydown
.. _ngKeyUp: https://docs.angularjs.org/api/ng/directive/ngKeyUp
.. _ngKeyPress: https://docs.angularjs.org/api/ng/directive/ngKeypress
.. _ngMouseDown: https://docs.angularjs.org/api/ng/directive/ngMousedown
.. _ngMouseUp: https://docs.angularjs.org/api/ng/directive/ngMouseup
.. _ngMouseLeave: https://docs.angularjs.org/api/ng/directive/ngMouseleave
.. _ngMouseEnter: https://docs.angularjs.org/api/ng/directive/ngMouseenter
.. _ngMouseMove: https://docs.angularjs.org/api/ng/directive/ngMousemove
.. _ngMouseOver: https://docs.angularjs.org/api/ng/directive/ngMouseover
.. _ngPaste: https://docs.angularjs.org/api/ng/directive/ngPaste
.. _ngSubmit: https://docs.angularjs.org/api/ng/directive/ngSubmit
.. _ngSrc: https://docs.angularjs.org/api/ng/directive/ngSrc
.. _ngClass: https://docs.angularjs.org/api/ng/directive/ngClass
.. _ngStyle: https://docs.angularjs.org/api/ng/directive/ngStyle
.. _ngApp: https://docs.angularjs.org/api/ng/directive/ngApp
.. _ngBind: https://docs.angularjs.org/api/ng/directive/ngBind
.. _ngDisabled: https://docs.angularjs.org/api/ng/directive/ngDisabled
.. _ngHide: https://docs.angularjs.org/api/ng/directive/ngHide
.. _ngShow: https://docs.angularjs.org/api/ng/directive/ngShow
.. _ngIf: https://docs.angularjs.org/api/ng/directive/ngIf
.. _ngInclude: https://docs.angularjs.org/api/ng/directive/ngInclude
.. _ngRepeat: https://docs.angularjs.org/api/ng/directive/ngRepeat
.. _ngModel: https://docs.angularjs.org/api/ng/directive/ngModel
.. _ngModelOptions: https://docs.angularjs.org/api/ng/directive/ngModelOptions

