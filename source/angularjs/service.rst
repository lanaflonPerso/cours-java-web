.. highlight:: html

Les services
############

Nous avons vu dans le :ref:`chapitre sur les contrôleurs <injection_service>` que |ajs|
dispose d'un moteur d'injection permettant à un contrôleur de recevoir des services.

Un service est un singleton_ permettant d'offrir des méthodes et des données à un
ou plusieurs contrôleurs.

|ajs| fournit `plusieurs services <https://docs.angularjs.org/api/ng/service>`__
par défaut et d'autres sont disponibles comme extension. Les fonctionnalités
principales de |ajs| sont toutes implémentées sous la forme d'un service, il est donc possible
d'y accéder depuis le code de son application.

Par exemple, le service `$interpolate`_ sert à analyser et exécuter une interpolation.
Il est donc possible d'y accéder depuis un contrôleur par exemple :

.. code-block:: javascript
    :caption: Utilisation du service $interpolate
    
    var app = angular.module("myapp", []);
    
    app.controller("myController", ["$interpolate", function($interpolate) {
    	var exp = $interpolate("Bonjour {{ nom }} !");
    	this.value = exp({nom: "AngularJS"});
    }]);

Le service $http
****************

Un service particulièrement intéressant est `$http`_. Ce service permet de réaliser
des requêtes HTTP asynchrones en utilisant XMLHttpRequest_ ou JSONP_. Si la réponse
du serveur est au format JSON, alors il est très simple de récupérer des données auprès
du serveur.

Si le serveur peut retourner un document JSON de la forme :

.. code-block:: json

    [
        {"nom": "Pythagore", "naissance": -580, "mort": -500},
        {"nom": "Socrate", "naissance": -470, "mort": -399},
        {"nom": "Platon", "naissance": -427, "mort": -347},
        {"nom": "Euclide", "naissance": -325, "mort": -265},
    ]

Alors le contrôleur ci-dessous utilise le service `$http`_ pour récupérer
les données et renseigner le modèle :

.. code-block:: javascript

    var app = angular.module("myapp", []);

    app.controller("phiController", ["$scope", "$http", function($scope, $http) {
    	$http.get("http://monserveur.phi.com/phi.json").then(function(resp) {
            $scope.listePhi = resp.data;
    	})
    }]);

.. note::

    Le service `$http`_ fournit des méthodes d'envoi de requête pour les principales méthodes HTTP :
    get_, delete_, head_, post_, put_, patch_
    
.. note::

    Pour les méthodes permettant d'envoyer des données au serveur (comme post_),
    vous pouvez passer les données à envoyer en JSON en deuxième paramètre.
    Pour passer un objet JavaScript, vous pouvez le transformer préalablement
    en document JSON avec la méthode `JSON.stringify()`_.

Créer un service
****************

Il est très utile de créer ses propres services |ajs| pour les besoins de son
application. De plus, un service peut recevoir des dépendances par injection
comme un contrôleur. Un service peut donc utiliser d'autres services.

|ajs| permet de créer des services de quatre façons différentes. Il s'agit
principalement d'offrir le plus de souplesse aux développeurs. Un service
est identifié par son nom qui doit être unique. Ensuite, il est possible
d'injecter ce service dans un contrôleur ou un autre service en passant en paramètre
de construction un paramètre portant le même nom que le service.

Un service comme value
======================

Comme un service est un singleton, il est possible d'enregistrer une classe JavaScript
comme un service. Cette classe pourra ensuite être injectée vers d'autres services
ou d'autres contrôleurs. Pour cela, il suffit d'utiliser la méthode `angular.Module.value()`_ :

Pour l'exemple suivant, nous voulons déclarer un service capable d'offrir des
traductions (par exemple la traduction du nom des jours de la semaine de l'anglais
vers le français).

.. code-block:: javascript
    :caption: Déclaration d'une instance JavaScript comme un service (fichier app/app.js)

    class Traducteur {

        traduireSemaine(week) {
            switch(week) {
            case "monday":
                return "lundi";
            case "tuesday":
                return "mardi";
            case "wednesday":
                return "mercredi";
            case "thursday":
                return "jeudi";
            case "friday":
                return "vendredi";
            case "saturday":
                return "samedi";
            case "sunday":
                return "dimanche";
            }
        }
    }

    var app = angular.module("myapp", []);

    app.value("traducteur", new Traducteur())

    app.controller("semaineController", ["$scope", "traducteur", function($scope, traducteur) {
        $scope.$watch("week", function(value) {
            $scope.semaine = traducteur.traduireSemaine(value);
        });
    }]);

.. code-block:: html
    :caption: Exemple d'utilisation de l'application

    <!doctype html>
    <html>
    <head>
        <meta charset="utf-8">
        <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
        <script src="app/app.js"></script>
    </head>
    <body ng-app="myapp">

        <div ng-controller="semaineController">
            <input ng-model="week" ng-model-options="{onUpdate:'change'}">
            <div>{{ semaine }}</div>
        </div>

    </body>
    </html>

Cette approche est très facile à mettre en place mais reste limitée à des cas
simples de services.

Un service comme un service
===========================

Il est possible d'enregistrer une méthode de construction comme un service.
|ajs| créera la service une seule fois pour ensuite 
l'injecter dans les services ou les contrôleurs qui le nécessitent. Pour enregistrer
un service, on utilise la méthode `angular.Module.service()`_ :


.. code-block:: javascript
    :caption: Déclaration d'un service (fichier app/app.js)

    var app = angular.module("myapp", []);

    app.service("itemsService", ["$http", function($http) {
        this.getItems = function(fnCallback) {
                $http.get("api/test").then(function(resp) {
                fnCallback(resp.data);
            });
        };
    }])

    app.controller("itemController", ["$scope", "itemsService", function($scope, itemsService) {
        itemsService.getItems(function(items) {
            $scope.items = items;
        });
    }]);

Un service via une factory
==========================

Il est possible d'enregistrer une méthode qui servira de fabrique (*factory*)
au service. |ajs| appellera cette méthode une fois et prendra la valeur retournée comme
instance du service pour ensuite l'injecter dans les services ou les contrôleurs
qui le nécessitent. Pour enregistrer une fabrique, on utilise la méthode
`angular.Module.factory()`_ :

.. code-block:: javascript
    :caption: Déclaration d'une fabrique de service (fichier app/app.js)

    var app = angular.module("myapp", []);

    app.factory("itemsService", ["$http", function($http) {
        return {
            getItems(fnCallback) {
                $http.get("api/test").then(function(resp) {
                    fnCallback(resp.data);
                });
            }
        };
    }])

    app.controller("itemController", ["$scope", "itemsService", function($scope, itemsService) {
            itemsService.getItems(function(items) {
            $scope.items = items;
        })
    }]);

Un service via un provider
==========================

Il est possible d'enregistrer une méthode qui servira à créer un objet *provider*.
Cet objet sera ensuite utilisé pour créer le service en appelant sa méthode ``$get``.
|ajs| appellera la méthode ``$get`` une fois et prendra la valeur retournée comme
instance du service pour ensuite l'injecter dans les services ou les contrôleurs
qui le nécessitent. Pour enregistrer un *provider*, on utilise la méthode
`angular.Module.provider()`_. Le *provider* représente la technique la plus avancée
pour instancier un service mais c'est aussi celui qui offre le plus de souplesse. En effet,
un *provider* peut être configuré avant de créer le service en utilisant la méthode
`angular.Module.config()`_. Pour cela, il faut récupérer par injection de dépendance
le *provider* qui se nomme "[nom service]Provider".
Dans notre exemple, il est possible d'utiliser un *provider* pour rendre
configurable l'URI d'accès au service distant.

.. code-block:: javascript
    :caption: Déclaration d'un provider de service (fichier app/app.js)

    var app = angular.module("myapp", []);

    app.provider("itemsService", function() {
        class ItemsService {
            constructor (endpoint, http) {
                this.endpoint = endpoint;
                this.http = http
            }

            getItems(fnCallback) {
                this.http.get(this.endpoint).then(function(resp) {
	                fnCallback(resp.data);
                });
            }
        }

        this.$get = ["$http", function($http) {
            return new ItemsService(this.endpoint, $http);
        }];
    });

    app.controller("itemController", ["$scope", "itemsService", function($scope, itemsService) {
        itemsService.getItems(function(items) {
            $scope.items = items;
        })
    }]);

    app.config(["itemsServiceProvider", function(itemsServiceProvider) {
        itemsServiceProvider.endpoint = "api/test";
    }]);

.. note::

    Notez qu'un *provider* ne peut pas recevoir par injection d'autres services.
    Si besoin, l'injection se fera lors de l'appel à la méthode ``$get`` comme
    c'est le cas dans l'exemple ci-dessus pour récupérer le service `$http`_.

.. |ajs| replace:: `AngularJS <https://docs.angularjs.org/guide>`__
.. _XMLHttpRequest: https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest
.. _JSONP: https://en.wikipedia.org/wiki/JSONP
.. _singleton: https://fr.wikipedia.org/wiki/Singleton_(patron_de_conception)
.. _$interpolate: https://docs.angularjs.org/api/ng/service/$interpolate
.. _$http: https://docs.angularjs.org/api/ng/service/$http
.. _get: https://docs.angularjs.org/api/ng/service/$http#get
.. _delete: https://docs.angularjs.org/api/ng/service/$http#delete
.. _head: https://docs.angularjs.org/api/ng/service/$http#head
.. _post: https://docs.angularjs.org/api/ng/service/$http#post
.. _put: https://docs.angularjs.org/api/ng/service/$http#put
.. _patch: https://docs.angularjs.org/api/ng/service/$http#patch
.. _angular.Module.value(): https://docs.angularjs.org/api/ng/type/angular.Module#value
.. _angular.Module.service(): https://docs.angularjs.org/api/ng/type/angular.Module#service
.. _angular.Module.factory(): https://docs.angularjs.org/api/ng/type/angular.Module#factory
.. _angular.Module.provider(): https://docs.angularjs.org/api/ng/type/angular.Module#provider
.. _angular.Module.config(): https://docs.angularjs.org/api/ng/type/angular.Module#config
.. _JSON.stringify(): https://developer.mozilla.org/fr/docs/Web/JavaScript/Reference/Objets_globaux/JSON/stringify

