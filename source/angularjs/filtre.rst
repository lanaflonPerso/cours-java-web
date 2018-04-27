.. highlight:: html

Les filtres
###########


Les filtres |ajs| permettent de modifier le résultat d'une expression. Ils
peuvent être utilisés pour formater une donnée ou pour filtrer (d'où leur nom)
une liste de données. 

Utilisation d'un filtre
***********************

Le filtre se place après l'expression (séparé par un **|**).
|ajs| propose `plusieurs implémentations de filtres <https://docs.angularjs.org/api/ng/filter>`__.

Par exemple, il est possible d'utiliser le filtre date_ pour formater une date :

::

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <div>{{ '2018-02-01T12:00:00' | date: 'dd MMMM yyyy'}}</div>
    </body>
    </html>

Le filtre date_ accepte un paramètre donné après **:** et qui correspond au
format de la date.

Il est possible d'enchaîner plusieurs filtres à la suite. Ainsi, on peut transformer
la date en écrivant le nom du mois en majuscules grâce au filtre uppercase_ :

::

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    </head>
    <body ng-app>
        <div>{{ '2018-02-01T12:00:00' | date: 'dd MMMM yyyy' | uppercase}}</div>
    </body>
    </html>

Les filtres de liste : filter, orderBy, limitTo
***********************************************

Prenons comme exemple, une application qui déclare un contrôleur pour créer
une liste de données dans *$scope* :

.. code-block:: javascript
    :caption: Fichier app/app.js

    var app = angular.module("myapp", []);

    app.controller("phiController", ["$scope", function($scope) {
    	
    	$scope.listePhi = [
    		{nom: 'Pythagore', naissance: -580, mort: -500},
    		{nom: 'Socrate', naissance: -470, mort: -399},
    		{nom: 'Platon', naissance: -427, mort: -347},
    		{nom: 'Euclide', naissance: -325, mort: -265},
    	];
    	
    }]);

L'application utilise la directive ngRepeat_ pour créer un tableau HTML des données :

::

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <table border="1">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Naissance</th>
                    <th>Décès</th>
                </tr>
            </thead>
            <tbody ng-controller="phiController">
                <tr ng-repeat="p in listePhi">
                    <td>{{p.nom}}</td>
                    <td>{{p.naissance}}</td>
                    <td>{{p.mort}}</td>
                </tr>
            </tbody>
        </table>
    </body>
    </html>
    
filter
======

Le filtre filter_ permet de lier un ou plusieurs attributs du modèle comme valeur
de filtre des éléments de la liste.

.. code-block:: html
    :caption: filtre d'une liste à partir d'une chaîne de caractères

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <div><input ng-model="filtreListe"></div>
        <table border="1">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Naissance</th>
                    <th>Décès</th>
                </tr>
            </thead>
            <tbody ng-controller="phiController">
                <tr ng-repeat="p in listePhi | filter: filtreListe">
                    <td>{{p.nom}}</td>
                    <td>{{p.naissance}}</td>
                    <td>{{p.mort}}</td>
                </tr>
            </tbody>
        </table>
    </body>
    </html>

Si le paramètre de filter_ s'évalue comme une chaîne de caractères alors, le filtre retient
l'élément si au moins un de ses attributs contient la chaîne

Le filtre filter_ accepte également un objet en paramètre. Dans ce cas, chaque
attribut de l'objet permet de filtrer la valeur de l'attribut des éléments de 
la liste du même nom. Il est ainsi possible de réaliser un filtre multi-critères.

.. code-block:: html
    :caption: filtre d'une liste à partir d'un objet

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <div><input ng-model="filtreListe.$"></div>
        <table border="1">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Naissance</th>
                    <th>Décès</th>
                </tr>
                <tr>
                    <td><input ng-model="filtreListe.nom"></td>
                    <td><input ng-model="filtreListe.naissance"></td>
                    <td><input ng-model="filtreListe.mort"></td>
                </tr>
            </thead>
            <tbody ng-controller="phiController">
                <tr ng-repeat="p in listePhi | filter: filtreListe">
                    <td>{{p.nom}}</td>
                    <td>{{p.naissance}}</td>
                    <td>{{p.mort}}</td>
                </tr>
            </tbody>
        </table>
    </body>
    </html>

.. note::

    Pour l'objet filtre, l'attribut **$** est un attribut spécial utilisé
    pour filtrer toutes le colonnes.

orderBy
=======

Le filtre orderBy_ permet de trier une liste selon le nom d'un attribut. Ce filtre accepte plusieurs
paramètres. Le premier paramètre indique le nom de l'attribut sur lequel le tri doit être fait.
Le second paramètre (optionnel) est une expression booléenne indiquant si le tri
doit se faire dans l'ordre inverse.

::

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <div>
            <select ng-model="tri" ng-init="tri = 'naissance'">
                <option value="nom">Nom</option>
                <option value="naissance">Naissance</option>
                <option value="mort">Décès</option>
            </select>
            <select ng-model="ordre" ng-init="ordre = 'ascendant'">
                <option value="ascendant">Ascendant</option>
                <option value="descendant">Descendant</option>
            </select>
        </div>
        <table border="1">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Naissance</th>
                    <th>Décès</th>
                </tr>
            </thead>
            <tbody ng-controller="phiController">
                <tr ng-repeat="p in listePhi | orderBy: tri : ordre == 'descendant'">
                    <td>{{p.nom}}</td>
                    <td>{{p.naissance}}</td>
                    <td>{{p.mort}}</td>
                </tr>
            </tbody>
        </table>
    </body>
    </html>

.. note::

    Dans l'exemple précédent, nous utilisons la directive ngInit_ qui permet
    d'assigner une valeur par défaut à un attribut du modèle au moment de
    l'initialisation de l'application.

limitTo
=======

Le filtre limitTo_ permet de donner le nombre maximum d'éléments à conserver
dans une liste.

::

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <div>
            <label>Nb éléments : </label>
            <input ng-model="nbElements" ng-model-options="{debounce: 500}">
        </div>
        <table border="1">
            <thead>
                <tr>
                    <th>Nom</th>
                    <th>Naissance</th>
                    <th>Décès</th>
                </tr>
            </thead>
            <tbody ng-controller="phiController">
                <tr ng-repeat="p in listePhi | limitTo: nbElements">
                    <td>{{p.nom}}</td>
                    <td>{{p.naissance}}</td>
                    <td>{{p.mort}}</td>
                </tr>
            </tbody>
        </table>
    </body>
    </html>

.. note::

    Le filtre limitTo_ accepte également un second paramètre (optionnel) indiquant
    l'index du premier élément à afficher. Cela permet de réaliser facilement
    un mécanisme de pagination côté client.

.. note::

    Le filtre limitTo_ peut également être utilisé pour limiter la taille d'une
    chaîne de caractères.

Créer un filtre
***************

Créer un filtre avec |ajs| est une opération relativement simple. Pour cela,
on utilise la méthode `angular.Module.filter()`_. Cette méthode attend le nom
du filtre et une fonction de construction du filtre. Cette fonction doit
retourner une fonction (le filtre proprement dit) qui prend au moins un paramètre
correspondant à la valeur à filtrer. Les paramètres supplémentaires correspondent
aux options du filtre.

Si nous souhaitons implémenter le filtre *replace* permettant de remplacer un mot
par un autre dans une chaîne de caractères,
nous pouvons l'ajouter au module de notre application :

.. code-block:: javascript
    :caption: Implémentation du filtre replace (fichier app/app.js)

    var app = angular.module("myapp", []);

    app.filter("replace", [function() {
    	return function (v, mot, nouveauMot) {
    		if (nouveauMot == null || nouveauMot == undefined) {
    			nouveauMot = "";
    		}
    		return String(v).replace(String(mot), String(nouveauMot));
    	}
    }]);

.. code-block:: html
    :caption: Exemple d'utilisation du filtre replace
    
    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">
        <div>
            {{ "Bonjour le monde" | replace: "monde" }}
        </div>
        <div>
            {{ "Bonjour le monde" | replace: "monde" : "world" }}
        </div>
        <div>
            <input ng-model="mot" ng-init="mot = 'monde'">
            {{ "Bonjour le monde" | replace: "monde" : mot }}
        </div>
    </body>
    </html>


.. |ajs| replace:: `AngularJS <https://docs.angularjs.org/guide>`__
.. _date: https://docs.angularjs.org/api/ng/filter/date
.. _uppercase: https://docs.angularjs.org/api/ng/filter/uppercase
.. _ngRepeat: https://docs.angularjs.org/api/ng/directive/ngRepeat
.. _ngInit: https://docs.angularjs.org/api/ng/directive/ngInit
.. _filter: https://docs.angularjs.org/api/ng/filter/filter
.. _orderBy: https://docs.angularjs.org/api/ng/filter/orderBy
.. _limitTo: https://docs.angularjs.org/api/ng/filter/limitTo
.. _angular.Module.filter(): https://docs.angularjs.org/api/ng/type/angular.Module#filter

