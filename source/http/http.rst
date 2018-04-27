Le protocole HTTP
#################

**L'Hypertext Transfer Protocol** (HTTP) est un protocole de la
`couche application <https://en.wikipedia.org/wiki/Application_layer>`__.
Il est le fondement de l'échange de données pour le World Wide Web.
Comme tous les protocoles applicatifs d'Internet, HTTP est orienté
texte.

HTTP version 1.1 est défini par un ensemble de RFC (Requests For
Comments) maintenu par un groupe de travail de l'IETF (Internet
Engineering Task Force) :

-  `RFC 7230 <https://tools.ietf.org/html/rfc7230>`__ - HTTP/1.1: Message
   Syntax and Routing - Description de la structure des messages
   échangés et des procédures de connexion
-  `RFC 7231 <https://tools.ietf.org/html/rfc7231>`__ - HTTP/1.1:
   Semantics and Content - Description des méthodes, des codes d'état et
   des en-têtes
-  `RFC 7232 <https://tools.ietf.org/html/rfc7232>`__ - HTTP/1.1:
   Conditional Requests - Le support des requêtes conditionnelles
-  `RFC 7233 <https://tools.ietf.org/html/rfc7233>`__ - HTTP/1.1: Range
   Requests - Le support de requête pour obtenir un contenu partiel
-  `RFC 7234 <https://tools.ietf.org/html/rfc7234>`__ - HTTP/1.1: Caching
   - La gestion du cache client et des caches des éléments
   intermédiaires
-  `RFC 7235 <https://tools.ietf.org/html/rfc7235>`__ - HTTP/1.1:
   Authentication - La gestion de l'authentification HTTP

Depuis 1999, le protocole HTTP était défini par la "célèbre" `RFC
2616 <https://tools.ietf.org/html/rfc2616>`__. En juin 2014, une
reécriture a été publiée afin de clarifier certains points et
d'améliorer la structure globale de la spécification en la scindant en
six RFC distinctes.

Structure des messages
**********************

HTTP est un protocole **sans état conversationnel** dans un
environnement **client/serveur**. Le client émet une requête qui
contient les informations suffisantes pour permettre au serveur de
fournir une réponse.

Une requête HTTP GET

.. code-block:: http

    GET /html/rfc7230 HTTP/1.1
    Host: tools.ietf.org
                    

La réponse du serveur

.. code-block:: http

    HTTP/1.1 200 OK
    Content-Type: text/html; charset=utf-8
    Content-Length: 420

    <html>
    ...
    </html>

Une requête HTTP débute par une ligne de requête (request line) terminée
par un saut de ligne
(`CRLF <https://fr.wikipedia.org/wiki/Carriage_Return_Line_Feed>`__).
Cette ligne contient la méthode HTTP que le client souhaite exécuter, le
chemin de la ressource cible sur laquelle la méthode doit s'appliquer et
enfin la version du protocole HTTP utilisée (HTTP/1.1).

On trouve ensuite une liste d'en-têtes et une ligne vide qui marque la
fin des en-têtes. Si la requête a un contenu (un *corps de message*), il
est ensuite transmis.

Structure d'une requête HTTP

.. code-block:: text

    [méthode] [ressource cible] HTTP/1.1
    [Nom de l'en-tête]: [Valeur de l'en-tête]
    ...
    [ligne vide]
    [corps de message]

Lorsque le serveur reçoit la requête, il reconstitue l'URI de la requête
afin de déterminer quelle réponse il doit retourner au client. L'URI de
la requête est déterminée à partir de la ressource cible et de la valeur
de l'en-tête ``Host``. Ainsi pour la requête suivante :

.. code-block:: http

    GET /html/rfc7230 HTTP/1.1
    Host: tools.ietf.org
                    

Le serveur infère que le client veut exécuter la méthode ``GET`` sur
l'URI :

    https://tools.ietf.org/html/rfc7230

On pourra retenir comme règle simple que le contenu de l'en-tête
``Host`` correspond au nom de l'hôte dans l'URI et que la ressource
cible correspond au chemin suivant l'hôte dans l'URI.

Il existe au moins trois cas particuliers pour lesquels cette rêgle ne
s'applique pas :

-  Si l'URI ne contient aucun chemin (par exemple https://tools.ietf.org),
   alors on présume que la ressource cible est **/**.
-  La méthode ``OPTIONS`` autorise \* comme ressource cible pour
   désigner le serveur dans sa globalité plutôt qu'une ressource
   particulière.
-  Pour la création d'un tunnel HTTP grâce à la méthode ``CONNECT``,
   l'URI complète doit figurer dans la ligne de requête.

Lorsqu'on saisit une URI dans la barre d'adresse du navigateur, ce
dernier effectue le traitement inverse d'un serveur. Il transforme l'URI
en une requête HTTP valide en utilisant la méthode ``GET``.

Une réponse HTTP débute par une ligne de réponse (response line)
terminée par un saut de ligne
(`CRLF <https://fr.wikipedia.org/wiki/Carriage_Return_Line_Feed>`__).
Celle-ci donne la version du protocole de réponse, le code de statut du
traitement de la requête et enfin un message décrivant le code statut.
On trouve ensuite une liste d'en-têtes et une ligne vide qui marque la
fin des en-têtes. Si la réponse a un contenu (un *corps de message*), il
est ensuite transmis.

Structure d'une réponse HTTP

.. code-block:: text

    HTTP/1.1 [code statut] [message]
    [Nom de l'en-tête]: [Valeur de l'en-tête]
    ...
    [ligne vide]
    [corps de message]

En HTTP 1.1, seul l'en-tête *Host* est obligatoire.

Exercice
********

.. admonition:: Écrivons en HTTP
    :class: hint

    Afficher le contenu de la page Web
    http://www.meteo-villes.com/ ... **avec telnet** !
    Pour rappel, le protocole HTTP est associé au port 80.

    Essayez ensuite avec l'URI http://www.google.com. Quelle est la
    différence dans la réponse du serveur ?

.. admonition:: Introduction à cURL
    :class: hint

    cURL est un outil en ligne de commande permettant de récupérer des
    données à partir d'une URL. Il supporte de nombreux protocoles dont
    HTTP. Vous le téléchargez à partir `du site
    officiel <https://curl.haxx.se/download.html>`__.

    Utilisation simple de cURL

    .. code-block:: shell

        curl https://duckduckgo.com/

    cURL offre de nombreuses options. Celles qui vont nous être utiles :

    `-i`
        Affiche le contenu complet de la réponse HTTP. On visualise ainsi la
        ligne de statut et les en-têtes retournés par le serveur.
    `-v`
        Mode verbeux affichant notamment la requête émise et la réponse reçue.
    `-X` [méthode]
        Permet de préciser la méthode HTTP à utiliser dans la requête (``GET`` par défaut).
    `-H` "[en-tête]"
        Permet d'ajouter ou de modifier un en-tête de la requête.
    `--data-binary` [data]
        Ajoute les données spécifiées comme corps du message
    `-o` [nom de fichier]
        Permet de sauvegarder la réponse retournée par le serveur dans un
        fichier.

    Utilisation avancée de cURL

    .. code-block:: shell
    
        curl -v -X GET -H "Accept: text/html" https://duckduckgo.com/ -o /dev/null

    L'exemple ci-dessus permet d'obtenir une exécution en mode verbeux d'une
    requête ``GET`` pour l'hote duckduckgo.com pour la ressource / en ajoutant
    l'en-tête ``Accept`` avec la valeur ``text/html``. Le corps de la
    réponse est sauvegardé dans /dev/null, c'est-à-dire nulle part, afin que
    le terminal n'affiche que la ligne de statut et les en-têtes de la
    réponse.

    Utilisation avancée de cURL

    .. code-block:: shell
    
        curl -v -X POST -H "Content-type: application/json" --data-binary '{"formation": "Web Service", "année": "2018"}' http://api.web.fr/cours

    L'exemple ci-dessus permet d'exécuter une méthode POST sur une API Web
    hypothétique en envoyant un document JSON. cURL calculera
    automatiquement pour nous la taille du message à envoyer. Il n'est donc
    pas nécessaire de préciser l'en-tête ``Content-length``.

    Reprenez les URL de l'exercice précédent pour vous familiariser avec
    cURL : http://www.meteo-villes.com/ et http://www.google.com. 
    
    Essayez ensuite d'utiliser la méthode HEAD puis
    la méthode POST plutôt que la méthode GET dans vos requêtes. Quelles
    différences constatez-vous ?

Les codes de statut
*******************

Dans la ligne de réponse, le serveur transmet le `code de
statut <https://tools.ietf.org/html/rfc7231#section-6>`__ du traitement
de la requête. Il s'agit d'un nombre sur 3 chiffres. Les codes de statut
HTTP sont regroupés par familles identifiées par le chiffre des
centaines.

-  **1xx  réponse informationnelle.** La requête a été reçue et son
   traitement est en cours. Ce type de réponse n'est pas définitif :
   cela signifie que le client doit attendre une nouvelle réponse du
   serveur
-  **2xx  succès.** La requête a été reçue avec succès, comprise et
   acceptée par le serveur.
-  **3xx  redirection.** Une action supplémentaire a besoin d'être faite
   par le client pour terminer la requête.
-  **4xx  erreur du client.** La requête est syntaxiquement incorrecte
   ou ne peut pas être prise en compte. La requête ne doit pas être
   émise à nouveau telle quelle.
-  **5xx  erreur du serveur.** La serveur a échoué dans la prise en
   compte de la requête bien que cette dernière soit valide.

Parmi les codes existants, certains sont plus remarquables et doivent
être connus :

.. list-table:: Famille 2XX
    :widths: 5 10 30
    :header-rows: 1

    * - Code
      - Libellé
      - Description
    * - `200 <https://tools.ietf.org/html/rfc7231#section-6.3.1>`__
      - OK
      - Le traitement de la requête est un succès et la réponse contient un
        message correspondant au résultat du traitement.
    * - `201 <https://tools.ietf.org/html/rfc7231#section-6.3.2>`__
      - Created
      - La requête est un succès et sa prise en compte a entraîné la création
        d'une ou plusieurs ressources.
    * - `204 <https://tools.ietf.org/html/rfc7231#section-6.3.5>`__
      - No Content
      - La requête est un succès et la réponse ne contient pas de message.

.. list-table:: Famille 3XX
    :widths: 5 10 30
    :header-rows: 1

    * - Code
      - Libellé
      - Description
    * - `301 <https://tools.ietf.org/html/rfc7231#section-6.4.2>`__
      - Moved Permanently
      - Indique que le serveur connaît la ressource à laquelle le client désire
        accéder mais qu'elle n'est plus disponible à l'URI spécifiée. L'en-tête
        de réponse ``Location`` permet au serveur d'indiquer la nouvelle URI à
        laquelle le client pourra accéder à la ressource.
    * - `303 <https://tools.ietf.org/html/rfc7231#section-6.4.4>`__
      - See Other
      - La requête a été exécutée mais la réponse doit être consultée à une
        autre URI. L'en-tête de réponse ``Location`` permet au serveur
        d'indiquer l'URI vers laquelle le client peut exécuter un **GET** pour
        accéder au résultat.
    * - `307 <https://tools.ietf.org/html/rfc7231#section-6.4.7>`__
      - Temporary redirect
      - La requête n'a pas été traitée par le serveur et le client doit refaire
        la même requête vers une URI différente. L'en-tête de réponse
        ``Location`` permet au serveur d'indiquer la nouvelle URI à laquelle le
        client pourra renvoyer sa requête.
    * - `304 <https://tools.ietf.org/html/rfc7232#section-4.1>`__
      - Not Modified
      - Code d'état utilisé lors d'une requête conditionnelle pour spécifier au
        client que la ressource n'a pas été modifiée depuis son dernier accès.
        Il s'agit d'une redirection car ce code est utilisé la plupart du temps
        pour la gestion de la mise en cache. Le serveur notifie ainsi le client
        qu'il peut utiliser la représentation qu'il a déjà obtenue (et mise en
        cache) lors de son dernier accès.

.. list-table:: Famille 4XX
    :widths: 5 10 30
    :header-rows: 1

    * - Code
      - Libellé
      - Description
    * - `400 <https://tools.ietf.org/html/rfc7231#section-6.5.1>`__
      - Bad Request
      - La requête n'a pas pu être traitée car elle est syntaxiquement
        incorrecte.
    * - `404 <https://tools.ietf.org/html/rfc7231#section-6.5.4>`__
      - Not Found
      - Le serveur ne dispose pas de représentation pour la ressource cible.
    * - `405 <https://tools.ietf.org/html/rfc7231#section-6.5.5>`__
      - Method Not Allowed
      - La ressource cible est connue du serveur mais le client ne peut pas
        utiliser la méthode spécifiée dans la requête.
    * - `406 <https://tools.ietf.org/html/rfc7231#section-6.5.13>`__
      - Not Acceptable
      - Indique qu'il n'existe pas de représentation au format demandé par le
        client pour la ressource cible (échec de la négociation de contenu).
    * - `409 <https://tools.ietf.org/html/rfc7231#section-6.5.8>`__
      - Conflict
      - La requête ne peut pas être traitée sans entrer en conflit avec l'état
        courant d'une ressource sur le serveur.
    * - `412 <https://tools.ietf.org/html/rfc7232#section-4.2>`__
      - Precondition failed
      - Lors d'une requête conditionnelle, indique que la requête n'a pas pu
        être traitée car une de ses préconditions n'est pas satisfaite.
    * - `415 <https://tools.ietf.org/html/rfc7231#section-6.5.13>`__
      - Unsupported Media Type
      - Indique que le message envoyé par le client utilise un format qui n'est
        pas supporté par le serveur. Par exemple, le client envoie au serveur un
        message au format XML alors que ce dernier s'attend à un document PDF.

.. list-table:: Famille 5XX
    :widths: 5 10 30
    :header-rows: 1

    * - Code
      - Libellé
      - Description
    * - `500 <https://tools.ietf.org/html/rfc7231#section-6.6.1>`__
      - Internal Server Error
      - Une erreur inattendue a empêché le serveur de traiter la requête.

Les méthodes HTTP
*****************

Les `méthodes HTTP <https://tools.ietf.org/html/rfc7231#section-4>`__
désignent le type d'opération que le client désire réaliser. Attention,
leur nom s'écrit en majuscules dans une requête HTTP.

`GET <https://tools.ietf.org/html/rfc7231#section-4.3.1>`__
    Demande au serveur une représentation de la ressource cible.
`HEAD <https://tools.ietf.org/html/rfc7231#section-4.3.2>`__
    Comme un GET sauf que la réponse ne contient jamais de corps. Cette
    méthode est utile pour obtenir les informations des en-têtes et
    valider une requête sans envoyer ni recevoir de corps de message.
`PUT <https://tools.ietf.org/html/rfc7231#section-4.3.4>`__
    Crée ou met à jour l'état d'une ressource identifiée par l'URI.
`PATCH <https://tools.ietf.org/html/rfc5789#section-2>`__
    Change partiellement l'état d'une ressource cible. PATCH ne fait pas
    partie de la liste initiale des méthodes HTTP. Elle a été ajoutée en
    2010 par la `RFC 5789 <https://tools.ietf.org/html/rfc5789>`__.
`DELETE <https://tools.ietf.org/html/rfc7231#section-4.3.5>`__
    Détruit l'association de l'URI avec l'état de la ressource.
`POST <https://tools.ietf.org/html/rfc7231#section-4.3.3>`__
    La sémantique de la méthode POST est probablement la plus compliquée
    à saisir car cette méthode est utilisable dans différentes
    situations pour :

    -  Fournir un bloc de données (formulaire) à un processus de
       traitement
    -  Poster un message dans un système de centralisation d'articles
    -  Créer une nouvelle ressource qui sera identifiée par le serveur
    -  Ajouter des informations à la représentation d'une ressource

    Lorsqu'un client reçoit une réponse à une méthode ``POST``, il peut
    être important de savoir si la réponse correspond à une
    représentation d'une ressource ou s'il s'agit du résultat d'un
    traitement. Pour un code statut 200, l'en-tête de réponse
    ``Content-Location`` sert à faire cette différence. S'il est
    présent, l'en-tête ``Content-Location`` signale que le corps de la
    réponse correspond bien à la représentation d'une ressource dont
    l'URI est donnée par cet en-tête.

`OPTIONS <https://tools.ietf.org/html/rfc7231#section-4.3.7>`__
    Permet d'obtenir les options de communication (par exemple : les
    méthodes autorisées pour l'URI). Le serveur doit retourner ces
    informations dans les en-têtes de réponse. Ainsi l'en-tête de
    réponse
    `Allow <https://tools.ietf.org/html/rfc7231#section-7.4.1>`__
    liste les méthodes HTTP autorisées pour cette URI.
`TRACE <https://tools.ietf.org/html/rfc7231#section-4.3.8>`__
    Permet de simuler un écho de la requête. Cette méthode n'est pas
    utilisée pour la réalisation d'API Web car elle est surtout utile
    pour tester la configuration du réseau et obtenir des informations
    des proxies.
`CONNECT <https://tools.ietf.org/html/rfc7231#section-4.3.6>`__
    Établit un tunnel à travers un proxy. Cette méthode n'est pas
    utilisée pour la réalisation d'API Web.

Propriétés des méthodes HTTP
****************************

Les méthodes HTTP sont classées selon trois propriétés : la **sûreté**,
**l'idempotence** et **le support du cache** (cacheable).

Sûreté (safety)
    Une méthode est sûre si le client ne s'attend à aucune modification
    d'état sur le serveur. Une méthode sûre est assimilable à une simple
    lecture de données. En tant que telle, elle doit pouvoir être
    exécutée entre 0 et N fois sans que cela n'affecte la ressource
    associée. **Les méthodes GET, HEAD et OPTIONS doivent être sûres**.

    L'implémentation d'un serveur peut amener des modifications lors de
    l'exécution d'une méthode sûre. Par exemple, une requête ``GET``
    peut générer des fichiers de log sur le serveur. Ce qu'il est
    important de retenir, c'est que ce type de modification n'est pas de
    la responsabilité du client.

Idempotence (idempotent)
    Une méthode est idempotente si l'effet obtenu est le même qu'elle
    soit exécutée 1 ou N fois. Autrement dit, toutes choses étant égales
    par ailleurs, la répétition d'une requête utilisant une méthode
    idempotente conduit au même résultat. **Les méthodes GET, HEAD,
    OPTIONS, PUT et DELETE doivent être idempotentes.**

    En HTTP, la notion d'idempotence est fortement associée à la reprise
    sur erreur. En effet, les requêtes utilisant des méthodes
    idempotentes peuvent être répétées en cas d'erreur de communication.
    Par exemple, si un client émet une requête ``DELETE`` et qu'il
    n'obtient pas de réponse du serveur, il peut émettre à nouveau sa
    requête jusqu'à obtenir une réponse. Cela fait de HTTP un protocole
    adapté pour des réseaux connectés mais peu fiables (Wifi, réseau
    data de téléphonie mobile...)

.. _cacheable:

Support du cache (cacheable)
    Une méthode *cacheable* indique que sa réponse peut être stockée par
    le client ou un proxy pour une utilisation ultérieure. Attention, il
    ne s'agit en rien d'une règle obligatoire et la gestion du cache en
    HTTP est régie par la `RFC
    7234 <https://tools.ietf.org/html/rfc7234>`__. **HTTP définit les
    méthodes GET, HEAD et POST comme étant *cacheables***. Les méthodes
    non *cacheables* forcent la suppression des données mises en cache
    pour l'URI lorsqu'elles sont soumises au serveur.

+------------+------------+-------------+------------+
|            | Sûre       | Idempotente | Cacheable  |
+============+============+=============+============+
| GET        | **oui**    | **oui**     | **oui**    |
+------------+------------+-------------+------------+
| HEAD       | **oui**    | **oui**     | **oui**    |
+------------+------------+-------------+------------+
| PUT        | non        | **oui**     | non        |
+------------+------------+-------------+------------+
| PATCH      | non        | non         | non        |
+------------+------------+-------------+------------+
| DELETE     | non        | **oui**     | non        |
+------------+------------+-------------+------------+
| POST       | non        | non         | **oui**    |
+------------+------------+-------------+------------+
| OPTIONS    | **oui**    | **oui**     | non        |
+------------+------------+-------------+------------+

Les en-têtes HTTP
*****************

Les en-têtes de requête et de réponse permettent d'enrichir le contexte
de la requête ou la réponse. Ils servent à fournir des données pour le
support d'un ensemble de fonctionnalités de HTTP :

-  Gestion du cycle de vie de la connexion client/serveur
-  Compression du corps du message
-  Gestion de la taille et du contenu des entités de requête et de
   réponse
-  Négociation de contenu
-  Requêtes conditionnelles
-  Gestion des stratégies de cache
-  ...

Le nom des en-têtes est insensible à la casse.
Les en-têtes peuvent être envoyés dans n'importe quel ordre.
A titre d'exemple, on citera :

`Host <https://tools.ietf.org/html/rfc7230#section-5.4>`__ (requête)
    L'en-tête ``Host`` est le seul obligatoire en HTTP 1.1 pour un
    requête. Il contient le nom et le port du serveur. Sa présence
    permet notamment la gestion de serveurs HTTP virtuels sur un même
    port.

    Une requête HTTP avec l'en-tête ``Host``

    .. code-block:: http

        GET / HTTP/1.1
        Host: www.monserveur.fr:9090
                            

`Content-Type <https://tools.ietf.org/html/rfc7231#section-3.1.1.5>`__ (requête et réponse)
    Si une requête ou une réponse contient un message, il est nécessaire
    pour le destinataire d'identifier le format du contenu. L'en-tête
    HTTP ``Content-Type`` fournit cette information sous la forme d'un
    `type MIME <https://fr.wikipedia.org/wiki/Type_MIME>`__.

    Une liste (non exhaustive) des types MIME les plus courants est :

    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/plain                          | Un fichier texte                                                                                                   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/plain;charset=utf-8            | Un fichier texte encodé en UTF-8                                                                                   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/html                           | Un fichier HTML                                                                                                    |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/xml ou application/xml         | Un fichier XML                                                                                                     |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | text/json ou application/json       | Un fichier JSON                                                                                                    |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | image/jpeg                          | Une image au format jpeg                                                                                           |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | application/x-www-form-urlencoded   | Le format de données pour la soumission d'un formulaire HTML                                                       |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+
    | application/octet-stream            | Un flux d'octets sans type particulier. Il s'agit du format par défaut si l'en-tête ``Content-type`` est absent.   |
    +-------------------------------------+--------------------------------------------------------------------------------------------------------------------+

    Une requête HTTP avec l'en-tête ``Content-Type``

    .. code-block:: http

        POST /utilisateur HTTP/1.1
        Host: www.monserveur.fr:9090
        Content-Type: application/x-www-form-urlencoded
        Content-Length: 36

        nom=David&prenom=Gayerie&taille=174

    Le IANA (Internet Assigned Numbers Authority) maintient un `registre
    des types
    MIME <http://www.iana.org/assignments/media-types/media-types.xhtml>`__
    qui lui ont été officiellement soumis.

`Content-Length <https://tools.ietf.org/html/rfc7230#section-3.3.2>`__ (requête et réponse)
    Si une requête ou une réponse contient un message, il est nécessaire
    pour le destinataire d'en connaître la taille afin d'identifier la
    fin du message HTTP. En effet le mécanisme HTTP du *pipelining*
    permet de soumettre plusieurs requêtes (et donc de recevoir
    plusieurs réponse) sur une même connexion TCP. La capacité de
    délimiter les requêtes d'une part et les réponses d'autre part est
    donc cruciale. L'en-tête ``Content-Length`` sert à communiquer la
    taille en octets du message.

    Une requête HTTP avec l'en-tête ``Content-Length``

    .. code-block:: http

        POST /utilisateur HTTP/1.1
        Host: www.monserveur.fr:9090
        Content-Type: application/x-www-form-urlencoded
        Content-Length: 36

        nom=David&prenom=Gayerie&taille=174

    Une réponse HTTP avec l'en-tête ``Content-Length``

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-Type: text/plain; charset=utf-8
        Content-Length: 17

        Hello the world!

    Il est possible de ne pas fournir l'en-tête ``Content-Length`` en
    utilisant la technique de `l'encodage de transfert en
    bloc <https://fr.wikipedia.org/wiki/Chunked_transfer_encoding>`__
    (chunked transfer encoding). Cette technique est très largement
    utilisée par les serveurs qui génèrent du contenu dynamique pour
    lequel il serait coûteux de mettre en cache la réponse avant de la
    transmettre pour connaître sa taille définitive.

Exercice
********

.. admonition:: Écriture d'un client HTTP en Java
    :class: hint

    JAX-RS est l'API officielle en Java pour écrire des API Web. Cette API
    fournit également une classe ``ClientBuilder`` permettant d'implémenter
    un client HTTP.

    Pour cet exercice, il vous faut développer un client pour deux API Web :

    -  Le premier `freegeoip.net <http://freegeoip.net/>`__ permet de
       connaître la géolocalisation d'une adresse IP.
    -  Le second est l'API Web de World of Warcraft. La documentation est
       disponible sur le site `battle.net pour les
       développeurs <https://dev.battle.net/io-docs>`__.

    Pour écrire ces applications clientes, vous pouvez partir du template de
    projet Maven téléchargeable :download:`ici <assets/templates/jaxrs-client-template.zip>`.


