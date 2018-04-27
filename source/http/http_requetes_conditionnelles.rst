.. _requetes_conditionnelles:

HTTP : les requêtes conditionnelles
###################################

Les requêtes conditionnelles permettent au client de préciser dans les
en-têtes de requête des conditions qui, selon qu'elles sont vraies ou
fausses, doivent changer le comportement du serveur. Les requêtes
conditionnelles sont utilisées dans deux cas :

-  Pour la gestion de cache lors d'une requête GET. Le client demande au
   serveur de lui retourner la représentation de la ressource si cette
   dernière diffère de la version dont le client dispose déjà.
-  Pour garantir l'intégrité des données lors d'une requête non sûre
   (PUT, POST, PATCH ou DELETE). Le client désire que l'action soit
   effectuée uniquement si la ressource n'a pas été modifiée depuis son
   dernier accès.

Les requêtes conditionnelles peuvent se baser sur la date de dernière
modification de la ressource que le serveur est sensé communiqué
(principalement en réponse à une requête GET ou HEAD) grâce à l'en-tête
de réponse
`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__.

Une réponse HTTP avec l'en-tête
`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__

.. code-block:: http

    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=utf-8
    Content-Length: 17
    Last-Modified: Sat, 24 Mar 2018 08:32:00 GMT

    Hello the world!

Les requêtes conditionnelles peuvent également se baser sur
l'en-tête ``Entity-Tag``. Un ``Entity-Tag`` est une chaîne de caractères
(délimitée par ") que le serveur peut communiquer (principalement en
réponse à une requête GET ou HEAD) grâce à l'en-tête de réponse
`ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__. Ce tag
reste identique tant que la ressource ou sa représentation associée
n'ont pas été modifiées. Un ``Entity-Tag`` est opaque pour le client et
ce dernier n'a pas besoin de connaître l'algorithme utilisé par le
serveur pour le produire.

Une réponse HTTP avec l'en-tête
`ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__

.. code-block:: http

    HTTP/1.1 200 OK
    Content-Type: text/plain; charset=utf-8
    Content-Length: 17
    ETag: "71295647"

    Hello the world!

`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__
et `ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__ ne sont
normalement pas fournis par le serveur en réponse à la création ou la
modification d'une ressource. En effet, la représentation transmise par
le client *via* une méthode ``PUT`` ou ``POST`` peut ne pas correspondre
exactement à la représentation qui sera retournée par le serveur lors
d'une requête ``GET``. En effet, le serveur ajoute souvent des
informations à la ressource lors de sa création. Il est donc communément
admis que la représentation de la ressource envoyée par le client ne
peut pas être considérée comme fiable. Pour éviter toute mise en cache
prématurée, le serveur ne renvoie donc pas les en-têtes
`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__
et `ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__.

Demander une représentation à jour
**********************************

Lorsque le client dispose déjà d'une représentation de la resource, il
peut demander au serveur de lui retourner une nouvelle représentation
uniquement si celle-ci diffère de celle qu'il connaît déjà. L'intérêt
principal et de limiter la consommation de bande passante. Mais cela
peut aussi être un moyen de savoir si la ressource a été modifiée par un
autre client ou un processus asynchrone. Pour ce cas d'utilisation, le
client a besoin de connaître la date de dernière modification (obtenue
grâce à l'en-tête de réponse
`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__)
ou la valeur de l' ``Entity-Tag`` (obtenue grâce à l'en-tête de réponse
`ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__)

Le client peut construire sa requête en utilisant l'un des en-têtes
suivants :

`If-Modified-Since <https://tools.ietf.org/html/rfc7232#section-3.3>`__
    Permet de spécifier au serveur que la ressource doit avoir été
    modifiée depuis la date donnée pour traiter la requête.

    Requête conditionnelle avec ``If-Modified-Since``

    .. code-block:: http

        GET /individu/00001 HTTP/1.1
        Host: www.monserveur.fr
        If-Modified-Since: Sat, 24 Mar 2018 08:32:00 GMT

    Si la ressource **n'a pas été modifiée** depuis cette date, le
    serveur devrait retourner le code **304** (Not modified).

    Réponse lorsque la ressource n'a pas été modifiée depuis la date
    donnée

    .. code-block:: http

        HTTP/1.1 304 Not Modified
        Content-Length: 0

    Si la ressource a été effectivement modifiée, le serveur doit
    traiter la requête normalement.

`If-None-Match <https://tools.ietf.org/html/rfc7232#section-3.2>`__
    Permet de spécifier au serveur que la ressource doit avoir été
    modifiée depuis le dernier état connu pour traiter la requête. Le
    client demande au serveur de comparer l'\ ``Entity-Tag`` de la
    représentation de la ressource avec celui envoyé dans la requête.

    Requête conditionnelle avec ``If-None-Match``

    .. code-block:: http

        GET /individu/00001 HTTP/1.1
        Host: www.monserveur.fr
        If-None-Match: "71295647"

    Si l'\ ``Entity-Tag`` de la représentation de la ressource
    **correspond à celui envoyé** par le client, alors le serveur en
    déduit qu'il n'y a pas eu de modification et il devrait retourner le
    code **304** (Not modified).

    Réponse lorsque l'\ ``Entity-Tag`` correspond à celui envoyé par le
    client

    .. code-block:: http

        HTTP/1.1 304 Not Modified
        Content-Length: 0

    Si les ``Entity-Tags`` diffèrent, alors le serveur doit traiter la
    requête normalement.

Créer une ressource si elle n'existe pas déjà
*********************************************

La méthode ``PUT`` a une double sémantique de création et de mise à
jour. Cependant, un client désire parfois créer uniquement une ressource
et ne souhaite pas la modifier si elle existe déjà. Dans ce cas, on peut
utiliser l'en-tête ``If-None-Match`` avec la valeur spéciale ``*`` (ce
qui signifie que le serveur doit traiter la requête si aucune
représentation de la ressource n'est disponible).

Requête de création uniquement

.. code-block:: http

    PUT /individu/David+Gayerie HTTP/1.1
    Host: www.monserveur.fr
    If-None-Match: *
    Content-Type: application/x-www-form-urlencoded; charset=utf-8
    Content-Length: 65

    name=Gayerie&firstname=David&email=david.gayerie@yopmail.com

Si le serveur dispose d'une représentation pour cette ressource (et donc
si elle existe déjà), il doit répondre un code **412** (Precondition
Failed) :

Réponse lorsque la ressource existe déjà

.. code-block:: http

    HTTP/1.1 412 Precondition Failed
    Content-Length: 0

Altérer une ressource sous condition
************************************

Dans un environnement client/serveur, la mise à jour de données pose
systématiquement un problème : comment savoir si les données que je mets
à jour n'ont pas été altérées par un autre client depuis le dernier
accès. Pour le Web, on trouve plusieurs solutions basées sur le principe
du verrou optimiste ou le principe du verrou pessimiste
(optimistic/pessimistic lock). HTTP fournit un mécanisme de verrou
optimiste grâce à différents en-têtes. Le client peut altérer une
ressource avec une méthode ``PUT``, ``POST``, ``PATCH`` ou ``DELETE`` en
spécifiant au serveur la condition de validité de la requête. Pour ce
cas d'utilisation, le client a besoin de connaître la date de dernière
modification (obtenue grâce à l'en-tête de réponse
`Last-Modified <https://tools.ietf.org/html/rfc7232#section-2.2>`__)
ou la valeur de l'\ ``Entity-Tag`` (obtenue grâce à l'en-tête de réponse
`ETag <https://tools.ietf.org/html/rfc7232#section-2.3>`__)

Le client peut construire sa requête en utilisant l'un des en-têtes
suivants :

`If-Unmodified-Since <https://tools.ietf.org/html/rfc7232#section-3.4>`__
    Permet de spécifier au serveur qu'il ne doit traiter la requête que
    si la ressource n'a pas été modifiée depuis la date donnée par
    l'en-tête ``If-Unmodified-Since``.

    Requête conditionnelle avec ``If-Unmodified-Since``

    .. code-block:: http

        PUT /individu/David+Gayerie HTTP/1.1
        Host: www.monserveur.fr
        If-Unmodified-Since: Sat, 24 Mar 2018 08:32:00 GMT
        Content-Type: application/x-www-form-urlencoded; charset=utf-8
        Content-Length: 65

        name=Gayerie&firstname=David&email=david.gayerie@yopmail.com

    Si la ressource a effectivement été modifiée, le serveur doit
    retourner un code **412** (Precondition Failed) :

    Réponse lorsque la ressource a été modifiée depuis la date donnée

    .. code-block:: http

        HTTP/1.1 412 Precondition Failed
        Content-Length: 0

`If-Match <https://tools.ietf.org/html/rfc7232#section-3.1>`__
    Permet de spécifier au serveur qu'il ne doit traiter la requête que
    si la ressource n'a pas été modifiée depuis le dernier état connu.
    Le client demande au serveur de comparer l'\ ``Entity-Tag`` de la
    représentation de la ressource avec celui donné par l'en-tête
    ``If-Match``.

    Requête conditionnelle avec ``If-Match``

    .. code-block:: http

        PUT /individu/David+Gayerie HTTP/1.1
        Host: www.monserveur.fr
        If-Match: "71295647"
        Content-Type: application/x-www-form-urlencoded; charset=utf-8
        Content-Length: 65

        name=Gayerie&firstname=David&email=david.gayerie@yopmail.com

    Si l'\ ``Entity-Tag`` de la représentation de la ressource **ne
    correspond pas à celui envoyé** par le client, alors le serveur en
    déduit que la ressource a été modifiée entre temps et il devrait
    retourner le code **412** (Precondition failed) sans payload dans la
    réponse.

    Réponse lorsque l'\ ``Entity-Tag`` ne correspond pas à celui envoyé
    par le client

    .. code-block:: http

        HTTP/1.1 412 Precondition failed
        Content-Length: 0

    Si les ``Entity-Tags`` sont identiques, alors le serveur doit
    traiter la requête normalement.

Si la ressource a été modifiée mais que le serveur est capable de
déduire que l'état actuel est le même que celui résultant du traitement
de la requête, alors le serveur peut retourner un code statut **2XX**.
Ainsi la requête n'est pas traitée mais le résultat attendu par le
client est déjà effectif.

Altérer une ressource si elle existe
************************************

Parfois, un client désire modifier une ressource et ne souhaite pas que
sa requête soit traitée si elle n'existe pas. Dans ce cas, on peut
utiliser l'en-tête ``If-Match`` avec la valeur spéciale ``*`` (ce qui
signifie que le serveur doit traiter la requête si au moins une
representation de la ressource est disponible).

Requête de modification uniquement

.. code-block:: http

    DELETE /individu/David+Gayerie HTTP/1.1
    Host: www.monserveur.fr
    If-Match: *

Si le serveur ne dispose pas d'une représentation pour cette ressource
(et donc si elle n'existe pas), il doit répondre un code **412**
(Precondition Failed) :

Réponse lorsque la ressource n'existe pas

.. code-block:: http

    HTTP/1.1 412 Precondition Failed
    Content-Length: 0

Exercice
********

.. admonition:: requêtes conditionnelles
    :class: hint

    Vous devez utiliser l'API Web du site
    http://rest-bookmarks.herokuapp.com pour expérimenter les requêtes
    conditionnelles. À partir d'un bookmark que vous aurez créé avec cette
    API, vous devez utiliser les requêtes conditionnelles pour :

    -  demander une représentation d'un bookmark que si ce dernier a été mis
       à jour
    -  empêcher de créer un bookmark identifié par la même URI de ressource
    -  signaler une erreur pour la suppression d'un bookmark qui n'existe
       pas

    Écrivez la liste des commandes cURL pour réaliser les actions
    ci-dessus.

