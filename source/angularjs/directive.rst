.. highlight:: html

Les directives
##############

Les directives sont au cœur des applications |ajs|. S'il existe déjà une liste
importante de directive, il est tout à fait possible de créer ses propres directives.

.. note::

    Pour une documentation complète sur la création de directives, reportez-vous
    à la `documentation officelle <https://docs.angularjs.org/guide/directive>`__.

Une première directive
**********************

La création d'une directive peut s'avérer complexe car |ajs| offre une grande
souplesse dans leur création.

Pour commencer, nous pouvons considérer qu'une directive est définie par les
propriétés suivantes :

restrict
    Cette propriété définit où il est possible de déclarer la directive dans
    le page HTML. Cette propriété est une chaîne de caractères pouvant contenir
    les lettres suivantes :
    
    E
        Pour signaler que la directive est utilisable comme élément (balise) dans
        la page HTML.
    A
        Pour signaler que la directive est utilisable comme attribut d'un élément
        dans la page HTML.
    C
        Pour signaler que la directive est utilisable dans la définition de
        l'attribut ``class`` d'un élément dans la page HTML. Cette possibilité
        est très peu utilisée... sauf pour la directive ngClass_.
    M
        Pour signaler que la directive est utilisable dans un commentaire de
        la page HTML. Cette possibilité n'est pas réellement utilisée en pratique.

    Une même directive peut autoriser plusieurs options. Par exemple ``"EA"``
    pour signaler que la directive peut apparaître comme élément ou comme attribut
    d'un élément dans la page HTML.

template
    Cette propriété donne un *template* HTML qui sera inséré par la directive. Ce
    *template* peut contenir des expressions ou des directives |ajs|.

templateUrl
    Cette propriété donne l'URL du *template* HTML qui sera chargé depuis le serveur.

replace
    Une valeur booléenne pour indiquer si le résultat de la directive remplace
    l'élément qui contient la directive.

Pour déclarer une directive, on utilise la méthode `angular.Module.directive()`_.

.. code-block:: javascript
    :caption: Exemple d'une directive (fichier app/app.js)

    var app = angular.module("myapp", []);

    app.directive("hello", function() {
        return {
            restrict: "AE",
            template: "<div>Hello AngularJS</div>",
            replace: true
        }
    });


.. code-block:: html
    :caption: La page de l'application

    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body data-ng-app="myapp">
        <!-- Utilisation de la directive comme élément -->
        <div><hello></div>

        <!-- Utilisation de la directive comme attribut -->
        <div hello></div>
    </body>
    </html>

Directive et scope
******************

Dans une application |ajs|, le modèle est représenté par un contexte, ou plus
exactement par une hiérarchie de contextes. Le contexte courante est nommé
``$scope``. Une directive peut soit utiliser le contexte courant soit utiliser
un nouveau contexte soit utiliser un contexte isolé. Lors de la création de la
directive, on préciser l'attribut ``scope`` qui peut avoir les valeurs suivantes :

false
    Signifie que la directive utilisera le contexte actuel.
true
    Signifie qu'un nouveau contexte sera créé pour cette directive. Ce contexte
    héritera du contexte parent.
Un objet JavaScript
    Signifie que la directive utilisera un contexte isolé. Ce contexte n'a
    aucune relation avec le contexte courant. Le contenu du contexte est défini
    par l'objet JavaScript passé comme valeur.
    
Pour un contexte isolé, les attributs du contexte peuvent avoir des valeurs
spéciales qui permettent d'activer un liaison (*binding*).

``@``
    Permet de lier l'attribut à un attribut DOM du même nom. La valeur de cet
    attribut sera interprété comme une chaîne de caractères (pouvant contenir
    des expressions d'interpolation {{ }}). Ce lien est unidirectionnel.
``=``
    Permet de lier l'attribut à un attribut DOM du même nom. La valeur de cet
    attribut sera interprété comme le nom d'un propriété. Ce lien est bidirectionnel.
``&``
    Permet de lier l'attribut à un attribut DOM du même nom. La valeur de cet
    attribut sera interprété comme une fonction à appeler dans la directive.

Ci-dessous un exemple de directive liant un attribut à une expression :

.. code-block:: javascript
    :caption: Le fichier app/app.js
    
    var app = angular.module("myapp", []);

    app.directive("hello", function() {
        return {
            restrict: "AE",
            scope: {name: '@'},
            template: "<div>Hello {{name}}</div>",
            replace: true
        }
    });


.. code-block:: html
    :caption: La page de l'application

    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body data-ng-app="myapp">
        <input ng-model=username>
        <hello name="{{username | uppercase}}">
    </body>
    </html>

Ci-dessous un exemple de directive liant un attribut à un attribut du modèle :

.. code-block:: javascript
    :caption: Le fichier app/app.js
    
    var app = angular.module("myapp", []);

    app.directive("hello", function() {
        return {
            restrict: "AE",
            scope: {modelName: '='},
            template: "<div>Hello {{modelName}}</div>",
            replace: true
        }
    });


.. code-block:: html
    :caption: La page de l'application

    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body data-ng-app="myapp">
        <input ng-model=username>
        <hello model-name="username">
    </body>
    </html>

Directive et contenu
********************

Une directive utilise parfois le contenu de l'élément qui la déclare. C'est le
cas notamment de la directive ngRepeat_ qui utilise le contenu de l'élément comme
*template* à répéter pour chaque élément d'une collection.

Pour créer une directive capable de manipuler les éléments DOM fils de la directive,
il faut ajouter positionner l'attribut ``transclude`` à ``true``. On peut ensuite
utilise la directive ngTransclude_ dans le *template* de la directive pour indiquer
la position à laquelle les éléments fils doivent être placés.

.. code-block:: javascript
    :caption: Le fichier app/app.js
    
    var app = angular.module("myapp", []);

    app.directive("hello", function() {
        return {
            restrict: "AE",
            transclude: true,
            template: "<div>Bonjour <span ng-transclude></span></div>",
            replace: true
        }
    });


.. code-block:: html
    :caption: La page de l'application

    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body data-ng-app="myapp">
        <input ng-model=username>
        <div hello>
            monsieur ou madame {{username}}
        </div>
    </body>
    </html>

Compilation et liaison
**********************

|ajs| gère le cycle de vie d'une directive en deux étapes : la *compilation*
et la *liaison* (*link*).

Pendant l'étape de compilation, |ajs| recherche les directives présentes dans la
vue en parcourant l'arbre DOM à partir de sa racine. L'étape de compilation réalise
par exemple le téléchargement et l'ajout du *template* dans l'arborescence DOM.
Chaque directive fournit lors de sa compilation une fonction de liaison 
(*link function*) qui est collecté par |ajs| comme résultat de la compilation.

Pendant l'étape de liaison, |ajs| invoque les méthodes de liaison dans 
**l'ordre inverse** de leur collecte. L'étape de liaison sert à créer la portée
(si nécessaire) et à mettre en place le *binding*. Si la directive est associée
à un contrôleur, ce dernier est créé et passé en paramètre de la fonction de liaison.

Une directive peut fournir ses propres fonctions de compilation, de liaison
et un contrôleur associé. Pour cela, il suffit de rajouter dans la déclaration
de la directive les propriété suivantes :

compile
    fournit la fonction de compilation de la directive. Cette fonction à la signature
    suivante : 
    
    .. code-block:: javascript
    
        function compile(element, attrs) {
            // ...
        }

    Les arguments de cette fonction sont :

    element
        un objet qui représente l'élément DOM de la directive. |ajs|
        fournit sa propre API de manipulation d'élément qui est très proche
        de celle de JQuery_. Reportez-vous à la `documentation <https://docs.angularjs.org/api/ng/function/angular.element>`__.
    attr
        un objet représentant les attributs de l'élément DOM de la directive.
    
    La fonction de compilation doit retourner la fonction de liaison de la directive.
    Cette fonction sera appelée par |ajs| lors de la phase de liaison (*link*).    
    
link
    fournit la fonction de liaison de la directive. Cet attribut est utile lorsque
    l'on ne désire par fournir de fonction de compilation. Cette fonction à
    la signature suivante :
    
    .. code-block:: javascript
    
        function compile(scope, element, attrs, controller) {
            // ...
        }
       
    Les arguments de cette fonction sont :

    scope
        la portée de la directive.
    element
        un objet qui représente l'élément DOM de la directive. |ajs|
        fournit sa propre API de manipulation d'élément qui est très proche
        de celle de JQuery_. Reportez-vous à la `documentation <https://docs.angularjs.org/api/ng/function/angular.element>`__.
    attr
        un objet représentant les attributs de l'élément DOM de la directive.
    controller
        le contrôleur de la directive (et/ou les contrôleurs requis)

controller
    fournit la fonction de construction d'un contrôleur. Comme pour la création
    d'un contrôleur dans un module, cette dernière peut utiliser l'injection
    de dépendance en spécifiant des paramètres.

.. |ajs| replace:: `AngularJS <https://docs.angularjs.org/guide>`__
.. _angular.Module.directive(): https://docs.angularjs.org/api/ng/type/angular.Module#directive
.. _ngClass: https://docs.angularjs.org/api/ng/directive/ngClass
.. _ngTransclude: https://docs.angularjs.org/api/ng/directive/ngTransclude
.. _ngRepeat: https://docs.angularjs.org/api/ng/directive/ngRepeat
.. _JQuery: https://jquery.com

