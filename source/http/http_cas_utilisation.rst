HTTP : les cas d'utilisation
############################

À travers différents cas d'utilisation, nous allons clarifier le rôle
des méthodes HTTP et exploiter différents codes statut.

Obtenir la représentation d'une ressource
*****************************************

Lorsqu'un client désire obtenir la représentation d'une ressource auprès
d'un serveur, il utilise **toujours** la méthode ``GET``. En cas du
succès, le serveur doit répondre le code 200 ainsi que la représentation
de la ressource.

La requête

.. code-block:: http

    GET /web+service HTTP/1.1
    Host: www.dictionary.info

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Content-language: en
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service always on 
    as in the concept of utility computing.

Obtenir uniquement les meta-informations d'une ressource
********************************************************

Un client peut souhaiter obtenir des meta-informations sur une
ressource. Par exemple, il souhaite vérifier qu'une ressource existe
sans nécessairement obtenir sa représentation. Dans ce cas, il doit
utiliser la méthode ``HEAD``. Cette méthode se comporte comme la méthode
``GET`` mais sans retourner le corps du message

La requête

.. code-block:: http

    HEAD /web+service HTTP/1.1
    Host: www.dictionary.info

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Content-language: en
    Content-length: 226

Pour une requête ``HEAD``, le serveur peut ou non retourner les
informations relatives à la taille du message (l'en-tête
`Content-length <https://tools.ietf.org/html/rfc7230#section-3.3.2>`__).

Créer une ressource dont on connait l'URI
*****************************************

Lorsqu'un client veut créer une ressource sur le serveur, il faut
distinguer le cas où le client connaît l'URI finale de la ressource du
cas où c'est au serveur de déterminer l'URI finale. Dans le cas où
l'utilisateur connaît l'URI, la méthode sera **toujours** un ``PUT``. En
cas de succès, le serveur devrait répondre le code 201.

La requête

.. code-block:: http

    PUT /individu/David+Gayerie HTTP/1.1
    Host: exemple.fr
    Content-type: application/json; charset=utf-8
    Content-length: 91

    {"name" : "Gayerie", 
     "firstname" : "David", 
     "email" : "david.gayerie@yopmail.com"}

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 201 Created
    Content-length: 0

Dans l'exemple ci-dessus, le client souhaite créer une nouvelle
ressource identifiée par l'URI http://exemple.fr/individu/David+Gayerie.

La plupart du temps, la ressource créée par le serveur n'est pas
strictement conforme à la représentation transmise par le client. Le
serveur peut, par exemple, ajouter des données telles que la date de
création ou la version. Dans la sémantique HTTP, le serveur est libre
d'ignorer tout ou partie des informations transmises par le client et de
rajouter les informations qui lui semble nécessaires. Ainsi un client ne
peut jamais être sûr que la représentation transmise au serveur
correspondra bien à celle obtenue par en réponse à une requête ``GET``
sur l'URI de la ressource. Pour éviter au client de faire une requête
``GET`` supplémentaire, on admet qu'une requête ``PUT`` peut retourner
une représentation de la ressource qui vient d'être créée.

Créer une ressource dont on ne connait pas l'URI
************************************************

Dans le cas où l'utilisateur ne connaît pas l'URI finale de la
ressource, la méthode sera **toujours** un ``POST``. En cas de succès,
le serveur devrait répondre le code 201 et un en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__
donnant au client l'URI de la nouvelle ressource.

La requête

.. code-block:: http

    POST /individu/ HTTP/1.1
    Host: exemple.fr
    Content-type: application/x-www-form-urlencoded; charset=utf-8
    Content-length: 65

    name=Gayerie&firstname=David&email=david.gayerie@yopmail.com

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 201 Created
    Location: http://exemple.fr/individu/000001
    Content-length: 0

Dans l'exemple ci-dessus, le client souhaite créer une ressource et le
serveur décide d'identifier cette nouvelle ressource par l'URI
http://exemple.fr/individu/000001. Dans ce cas, la méthode ``POST`` a la
sémantique d'un ajout d'une ressource à un ensemble (celui des
individus).

La plupart du temps, la ressource créée par le serveur n'est pas
strictement conforme à la représentation transmise par le client. Le
serveur peut, par exemple, ajouter des données telles que la date de
création ou la version. Dans la sémantique HTTP, le serveur est libre
d'ignorer tout ou partie des informations transmises par le client et de
rajouter les informations qui lui semble nécessaires. Ainsi un client ne
peut jamais être sûr que la représentation transmise au serveur
correspondra bien à celle obtenue par en réponse à une requête ``GET``
sur l'URI fournie par l'en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__.
Pour éviter au client de faire une requête ``GET`` supplémentaire, on
admet qu'une requête ``POST`` peut retourner une représentation de la
ressource qui vient d'être créée.

Supprimer l'accès à une ressource
*********************************

La requête

.. code-block:: http

    DELETE /individu/000001 HTTP/1.1
    Host: exemple.fr

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 204 No content

Mettre à jour une ressource
***************************

La mise à jour complète d'une ressource existante se fait grâce à la
méthode ``PUT``.

La requête

.. code-block:: http

    PUT /individu/David+Gayerie HTTP/1.1
    Host: exemple.fr
    Content-type: application/json; charset=utf-8
    Content-length: 91

    {"name" : "Gayerie", 
     "firstname" : "David", 
     "email" : "david.gayerie@yopmail.com"}

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 204 No content

La requête de l'exemple ci-dessus est strictement identique à celle de
la section `*Créer une ressource dont on connaît
l'URI* <#creer_une_ressource_put>`__. Seule la réponse du serveur fait
la différence : 204 signifie que la requête a été acceptée mais sans
préciser une création (cela signifie que l'opération a été une mise à
jour). Le client ne sait pas *a priori* s'il demande une création ou une
modification. Cela correspond parfaitement à la caractéristique
d'idempotence de la méthode ``PUT`` : la requête peut donc être répétée
1 à N fois et produira la même résultat sur le serveur.

Nous verrons avec les requêtes conditionnelles que le client peut, s'il
le désire, s'assurer que sa requête est bien une requête de mise à jour.

Mettre à jour partiellement une ressource
*****************************************

La méthode ``PATCH`` a été introduite par la `RFC
5789 <https://tools.ietf.org/html/rfc5789>`__ afin de fournir une méthode
pour la mise à jour partielle d'une ressource.

La requête

.. code-block:: http

    PATCH /individu/David+Gayerie HTTP/1.1
    Host: exemple.fr
    Content-type: application/json-patch+json; charset=utf-8
    Content-length: 53

    {"op" : "add", 
     "path" : "/taille", 
     "value" : 174}

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 204 No content

La difficulté de l'utilisation de la méthode ``PATCH`` vient de la
nécessité pour le serveur et le client de partager un format de
représentation permettant de décrire les modifications à apporter.
L'exemple précédent utilise le format JSON patch proposé par la `RFC
6902 <https://tools.ietf.org/html/rfc6902>`__. Le client demande au
serveur d'ajouter l'attribut "taille" à la ressource avec pour valeur le
nombre 174. JSON patch a précisément été créé pour être utilisé
conjointement avec la méthode ``PATCH``.

La méthode ``PATCH`` est relativement peu implémentée et utilisée. Même
si la mise à jour partielle semble une opération élémentaire sur des
données, des utilisations judicieuses de ``POST`` et ``PUT`` suffisent
généralement à produire une API Web efficace.

Exécuter un processus de traitement
***********************************

Il est parfois utile de demander à un serveur de traiter de
l'information pour obtenir un résultat. Le résultat n'est pas une
ressource dont le serveur serait le dépositaire. Il s'agit juste d'une
information qui est calculée mais non conservée par le serveur. Dans ce
cas, le client doit utiliser la méthode ``POST``.

La requête

.. code-block:: http

    POST /calculatrice HTTP/1.1
    Host: www.monserveur.fr
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 40

    operande=2&operande=3&operation=addition

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain
    Content-length: 1

    5

Dans l'exemple précédent, la réponse ne contient ni l'en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__ ni
l'en-tête
`Content-location <https://tools.ietf.org/html/rfc7231#section-3.1.4.2>`__.
Cela signifie que la réponse à la requête ``POST`` n'est associée à
aucune ressource du serveur. Donc, il s'agit bien d'un simple résultat
de traitement.

Connaître les méthodes autorisées
*********************************

Si un client tente d'appliquer une méthode HTTP interdite sur une
ressource, le serveur répond généralement par le code statut 405 (Method
not allowed).

Afin de permettre au client d'être informé de la liste des méthodes
autorisées pour une URI, le serveur peut ajouter l'en-tête
`Allow <https://tools.ietf.org/html/rfc7231#section-7.4.1>`__ dans sa
réponse. Cet en-tête liste les méthodes autorisées séparées par une
virgule.

Le client peut également émettre une requête avec la méthode ``OPTIONS``
pour obtenir cet en-tête
`Allow <https://tools.ietf.org/html/rfc7231#section-7.4.1>`__ :

La requête

.. code-block:: http

    OPTIONS /individu/David+Gayerie HTTP/1.1
    Host: exemple.fr

La réponse du serveur en cas de succès

.. code-block:: http

    HTTP/1.1 200 OK
    Content-length: 31
    Content-type: text/plain
    Allow: GET, HEAD, DELETE, PUT, OPTIONS

    GET, HEAD, DELETE, PUT, OPTIONS

La méthode ``OPTIONS`` est souvent désactivée sur les serveurs Web pour
des raisons de sécurité. Le comble est donc que la plupart des requêtes
OPTIONS aboutissent à un code d'erreur 405 (method not allowed).

Traitement asynchrone d'une requête
***********************************

Parfois, le serveur ne peut pas traiter complètement une requête dans un
temps acceptable. Dans ce cas, il peut retourner le code 202 qui
signifie qu'il a bien compris et accepté la requête mais qu'il ne l'a
pas encore traitée.

La requête

.. code-block:: http

    DELETE /individu/000001 HTTP/1.1
    Host: exemple.fr

La réponse du serveur lorsque la requête est traitée en asynchrone

.. code-block:: http

    HTTP/1.1 202 Accepted
    Location: http://exemple.fr/jobs/1948321
    Content-type: text/plain
    Content-length: 53

    Traitement http://exemple.fr/jobs/1948321 en cours...

Dans l'exemple ci-dessus, la requête a conduit à la création d'une
ressource temporaire représentant le traitement en cours. L'en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__
donne l'URI où le client pourra se rendre pour consulter l'état du
traitement.

Les redirections
****************

Les redirections correspondent aux codes statut de la famille 3XX. Elles
permettent au serveur de réorienter le client vers une nouvelle URI. À
la réception d'un code de redirection, le client doit comprendre que
pour terminer sa requête, il doit exécuter une nouvelle requête vers une
URI fournie dans la réponse par le serveur grâce à l'en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__.

Évolution du service
====================

Le cas le plus simple d'utilisation des redirections est celui où le
serveur évolue dans le temps. Des évolutions peuvent entraîner une
modification des URI. Plutôt que de retourner simplement une erreur, le
serveur propose une redirection pour assurer une continuité du service.
Dans ce cas, le serveur peut retourner un code statut **301** (Moved
Permanently) avec un en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__
donnant la nouvelle URI.

Le serveur signale un changement de l'URI du service

.. code-block:: http

    HTTP/1.1 301 Moved Permanently
    Location: http://mon.nouveau.serveur.fr/ma/ressource/cible

.. _canonicalisation:


URI volatile et canonicalisation d'URI
======================================

Nous verrons que dans une architecture REST, une ressource ne doit être
identifié que par une seule URI. Pourtant il existe de nombreux cas
d'utilisation où l'on désire rendre accessible la représentation d'une
ressource à partir de différentes URI. Par exemple, imaginons une suite
de news, chaque article dispose de sa propre URI mais on peut souhaiter
exposer une URI permettant d'accéder au dernier article publié. Cette
URI désignera forcément dans le temps des ressources différentes. Elle
est volatile. Dans ce cas, le serveur peut retourner pour cette URI le
code statut **307** (Temporary redirect) qui demande au client de
refaire la même requête vers l'URI donnée en réponse par l'en-tête
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__.

Requête sur une URI *volatile*

.. code-block:: http

    GET /articles/latest HTTP/1.1
    Host: www.mynews.fr

Redirection du serveur...

.. code-block:: http

    HTTP/1.1 307 Temporary redirect
    Location: http://www.mynews.fr/articles/les+nouvelles+du+monde.html

La redirection est coûteuse car elle oblige le client à émettre une
nouvelle requête vers le serveur. Si le serveur peut répondre
directement, il peut renvoyer une code 2XX avec le message attendu et
ajouter l'en-tête de réponse
`Content-location <https://tools.ietf.org/html/rfc7231#section-3.1.4.2>`__
qui indique au client la véritable URI pour cette ressource (appelée URI
canonique).

... ou canonicalisation grâce à l'en-tête
`Content-location <https://tools.ietf.org/html/rfc7231#section-3.1.4.2>`__

.. code-block:: http

    HTTP/1.1 200 OK
    Content-Location: http://www.mynews.fr/articles/les+nouvelles+du+monde.html
    Cache-control: no-store
    Content-type: text/plain
    Content-length: 35

    Il n'y pas de nouvelle du monde :(

Séparer le traitement de la requête de son résultat
===================================================

Nous avons vu précédemment qu'il est possible de réaliser des requêtes
asynchrones en HTTP. Mais il existe d'autres cas pour lesquels le
serveur ne souhaite pas retourner directement de réponse au client.

Dans la navigation Web, un cas répandu est le
`POST/Redirect/GET <https://fr.wikipedia.org/wiki/Post-Redirect-Get>`__.
La méthode ``POST`` n'est pas idempotente. Lorsqu'un utilisateur remonte
dans son historique de navigation jusqu'à une requête ``POST``, le
navigateur n'a pas d'autre choix que de demander à l'utilisateur s'il
désire soumettre à nouveau cette requête. Il est donc souhaitable de
faire disparaître les méthodes non idempotentes de l'historique de
navigation. Or un navigateur Web ne conserve pas l'historique d'une
requête dont la réponse est une redirection (ou plus exactement, il lui
substitue la requête de redirection). Il est donc possible de supprimer
les requêtes ``POST`` de l'historique de navigation en s'assurant que
les réponses sont toujours des redirections avec une méthode ``GET``
vers une page de résultat : il s'agit du modèle du POST/Redirect/GET.
Pour cela, le développeur de site Web doit s'assurer que le code statut
en réponse à une méthode ``POST`` est un code **303** (See Other).
L'en-tête de réponse
`Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__
indique à quelle URI le client doit soumettre la requête ``GET`` de
redirection.

Une requête ``POST``

.. code-block:: http

    POST /individu/ HTTP/1.1
    Host: exemple.fr
    Content-Type: application/x-www-form-urlencoded; charset=utf-8
    Content-Length: 65

    name=Gayerie&firstname=David&email=david.gayerie@yopmail.com

La réponse du serveur avec une redirection

.. code-block:: http

    HTTP/1.1 303 See Other
    Location: http://exemple.fr/individu/000001

302, 303 et 307 : quelles différences ?
HTTP définit trois codes statut de redirection assez proches : 302
(Found), 303 (See Other) et 307 (Temporary Redirect). Il existe
cependant une différence majeure entre ces trois codes qui correspond à
des cas d'utilisation différents.

302
    Il s'agit d'un code hérité de HTTP 1.0. Sa signification est
    ambiguë. C'est d'ailleurs pour cela que les codes 303 et 307 ont
    fait leur apparition dans HTTP 1.1. Pour une application serveur, il
    est déconseillé de s'en servir. Pour une application cliente, il est
    conseillé de le traiter comme un code statut 303
303
    Ce code stipule que la requête **a été traitée** par le serveur.
    Cependant le client ne peut connaître le résultat que s'il soumet
    une requête ``GET`` à l'URI fournie en réponse dans l'en-tête
    `Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__.
307
    Ce code stipule que la requête **n'a pas été traitée** par le
    serveur. Le client doit donc soumettre à nouveau **la même** requête
    quelle que soit la méthode à l'URI fournie en réponse dans l'en-tête
    `Location <https://tools.ietf.org/html/rfc7231#section-7.1.2>`__.

Exercice
********

.. admonition:: utilisation d'une API Web
    :class: hint

    Vous devez utiliser l'API Web du site
    http://rest-bookmarks.herokuapp.com pour réaliser les opérations
    suivantes :

    -  Créer une nouvelle ressource bookmark (montrez qu'il est possible
       d'utiliser deux méthodes HTTP différentes)
    -  Obtenir la représentation de la ressource bookmark que vous avez
       créée
    -  Mettre à jour la ressource bookmark que vous avez créée
    -  Supprimer la ressource bookmark que vous avez créée
    -  Mettre à jour la dernière ressource bookmark ajoutée par n'importe
       quel client

    Utilisez des commandes cURL pour réaliser les actions ci-dessus.

    Pendant vos tests, il est très fortement conseillé d'utiliser l'option
    **-v** de cURL afin de bien visualiser la requête que vous envoyez mais
    également le code statut et les en-têtes retournés par le serveur.

