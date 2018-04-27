.. _http_gestion_cache:

HTTP : la gestion du cache
##########################

La gestion du cache décrite par la `RFC
7234 <https://tools.ietf.org/html/rfc7234>`__ est une part importante de
HTTP. En effet, HTTP étant utilisé sur des réseaux peu fiables, la
gestion du cache permet d'améliorer les performances ou de palier à des
défaillances. Si un élément intermédiaire du réseau, ou même le client,
dispose d'un système de mise en cache, il peut l'utiliser s'il sait que
les données qu'il contient sont à jour ou si le serveur distant est
temporairement indisponible.

HTTP ne préconise pas d'implémentation particulière pour un système de
gestion de cache (en fait HTTP ne considère pas la gestion de cache
comme obligatoire mais comme fortement recommandée). Par contre, HTTP
propose des en-têtes de requête et de réponse permettant aux différents
éléments d'un réseau (agent utilisateur, serveur d'origine et
intermédiaire) de fournir des informations aux autres éléments sur la
fraîcheur des informations et sur la stratégie de cache à privilégier.

Typiquement, un client pourra fournir des préférences sur le fait qu'il
accepte ou non des données issues d'un cache. Un serveur indiquera un
moyen de déterminer la date limite de fraîcheur de la réponse. Quant aux
intermédiaires, ils peuvent se signaler s'ils décident de répondre en
lieu et place du serveur d'origine.

La gestion de cache HTTP est un sujet complexe car elle implique de
comprendre et d'utiliser des stratégies différentes ainsi que la mise en
place d'heuristiques de calcul afin d'éviter des incohérences dans les
réponses qui peuvent être fournies par un cache HTTP. Dans le suite du
chapitre, nous nous limiterons donc aux principes généraux.

Les navigateurs Web les plus courants implémentent tous un cache local
pour l'utilisateur.

Serveur d'origine et intermédiaires
***********************************

Un serveur d'origine est celui qui fait autorité pour répondre à une
requête. Par exemple, il peut s'agir du serveur qui détient un document
particulier. En théorie, un client qui souhaite obtenir ce document doit
faire une requête HTTP au serveur d'origine. Cependant, HTTP supporte le
recours à des intermédiaires, formant ainsi une chaîne de connexions
entre le client qui émet la requête initiale (appelé agent utilisateur
ou *user agent*) et le serveur d'origine. Un intermédiaire agit à la
fois comme un serveur (car il doit retourner une réponse à une requête
cliente) et comme un client (car il doit obtenir l'information auprès de
l'élément suivant dans la chaîne de connexions).

HTTP définit trois types d'intermédiaires :

proxy (serveur mandataire)
    Un **proxy** est utilisé par un client pour transmettre des messages
    à sa place. Il est en général configuré pour accepter (ou refuser)
    des requêtes pour des URI particulières. Dans des organisations, un
    proxy est souvent utilisé pour transmettre des requêtes depuis un
    réseau interne vers un réseau publique (Internet). On résume
    l'action d'un proxy en disant qu'il se substitue à un client pour
    des requêtes vers N serveurs.
gateway ou reverse proxy (passerelle)
    Une **gateway** (ou reverse proxy) est un intermédiaire qui agit
    comme un serveur d'origine. Les reverse proxies sont souvent
    utilisés comme des accelérateurs HTTP (pour la mise en place de
    cache). Ils peuvent également permettre d'isoler des serveurs
    d'origine d'un réseau publique ou non sécurisé. On résume l'action
    d'un reverse proxy en disant qu'il se substitue à N clients pour des
    requêtes vers un serveur.
tunnel
    Un **tunnel** agit comme un relais entre deux connexions sans
    changer la nature des messages échangés. Un tunnel est utilisé pour
    établir des connexions sécurisées ou pour utiliser un protocole
    tiers à travers HTTP. Dans la mesure où HTTP impose que les messages
    circulant dans un tunnel ne peuvent pas être mis en cache, ce type
    d'intermédiaire ne nous intéressera pas dans ce chapitre.

Un **proxy** et un **reverse proxy** sont souvent pourvus d'un système
de gestion cache. Dans le cas d'un reverse proxy utilisé comme
accélérateur, il s'agit même de la principale raison de sa mise en
place. Ces intermédiaires vont donc pouvoir décider d'écourter la chaîne
de connexions en répondant directement à partir des données dont ils
disposent en cache. Ils auront également besoin de contacter de temps en
temps le serveur d'origine (directement ou indirectement) pour
renouveler le contenu de leur cache.

Principe générale de la gestion du cache
****************************************

Un cache est un ensemble de réponses précédemment reçues. Chaque réponse
est associée à un clé d'identification. Si une nouvelle requête est
émise avec la même clé d'identification, alors le gestionnaire du cache
peut fournir une réponse à la place du serveur d'origine. La clé
d'identification d'un cache correspond à l'URI de la ressource ainsi que
la méthode HTTP de la requête et *certains* en-têtes de la requête. Le
gestionnaire de cache est également responsable de la mise à jour et de
la suppression des réponses stockées dans le cache

Les clients (agent utilisateur ou intermédiaires) peuvent disposer d'un
gestionnaire de cache. Ce gestionnaire sera consulté avant d'émettre la
requête vers le serveur.

Un client disposant d'un gestionnaire de cache suivra un algorithme
proche de celui-ci :

-  Si la requête ne correspond à aucune réponse en cache, alors la
   requête est émise au serveur. Si la réponse l'autorise alors elle
   sera mise en cache. La reponse du serveur est utilisée comme réponse
   à la requête.
-  Si la requête invalide le cache, alors la requête est émise au
   serveur. En cas de succès, le gestionnaire de cache invalide une
   éventuelle réponse en cache. La reponse du serveur est utilisée comme
   réponse à la requête.
-  Si la requête correspond à une réponse déjà en cache, le gestionnaire
   de cache vérifie la fraîcheur de la réponse en cache :

   -  Si la réponse en cache ne nécessite pas de revalidation auprès du
      serveur alors elle est utilisée directement comme réponse à la
      requête.
   -  Si la réponse en cache nécessite une revalidation auprès du
      serveur alors la revalidation est effectuée :

      -  Si le serveur considère que la réponse en cache est toujours
         valide, alors elle est utilisée directement comme réponse à la
         requête.
      -  Si le serveur considère que cette réponse n'est plus valide, le
         cache est mis à jour à partir de la réponse du serveur et la
         réponse du serveur est utilisée comme réponse à la requête.
      -  Si la requête au serveur échoue, soit une erreur est retournée
         en réponse à la requête soit le réponse en cache est utilisée
         comme réponse à la requête.

La fraîcheur d'une réponse
**************************

La capacité d'un gestionnaire de cache à juger de la fraîcheur
(`freshness <https://tools.ietf.org/html/rfc7234#section-4.2>`__)
d'une réponse en cache est un mécanisme fondamental pour la gestion de
cache. Une réponse en cache est considérée comme "fraîche" si elle peut
être utilisée comme réponse sans que le serveur d'origine n'ait à la
revalider.

La fraîcheur est déduite à partir d'une date limite. Cette date limite
de fraîcheur est soit donnée par le serveur d'origine soit déduite à
partir d'informations fournies par le serveur d'origine.

Le serveur peut fournir un des deux en-têtes suivants dans sa réponse
pour permettre de calculer la date limite de fraîcheur :

`Expires <https://tools.ietf.org/html/rfc7234#section-5.3>`__
    L'en-tête de réponse
    `Expires <https://tools.ietf.org/html/rfc7234#section-5.3>`__
    permet au serveur de donner la date limite de fraîcheur de sa
    réponse. Cela ne signifie pas qu'après cette date, la ressource
    cesse d'être valide ou même n'existera plus. Il s'agit juste de
    forcer un gestionnaire de cache à effectuer une requête de
    validation une fois cette date passée.

    Si le serveur ne souhaite pas que sa réponse soit mise en cache, il
    peut fournir une date passée dans l'en-tête
    `Expires <https://tools.ietf.org/html/rfc7234#section-5.3>`__.

    En général, un gestionnaire de cache ne tiendra compte de l'en-tête
    `Expires <https://tools.ietf.org/html/rfc7234#section-5.3>`__ que
    s'il est accompagné de l'en-tête
    `Date <https://tools.ietf.org/html/rfc7231#section-7.1.1.2>`__.
    Ce dernier donne la date du serveur au moment de la génération de la
    réponse. Cela permet au client d'effectuer d'éventuelles corrections
    d'horloge s'il existe des différences entre la date du serveur et la
    date du client.

    La requête

    .. code-block:: http

        GET /web+service HTTP/1.1
        Host: www.dictionary.info

    La réponse du serveur avec l'en-tête Expires

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-type: text/plain; charset=utf-8
        Date: Mon, 26 Mar 2018 15:00:00 GMT
        Expires: Fri, 1 Jan 2021 00:00:00 GMT
        Last-Modified: Sat, 24 Mar 2018 08:32:00 GMT
        Content-length: 226

        A Web Service is a method of communication between two electronic devices over a network.
        It is a software function provided at a network address over the web with the service 
        always on as in the concept of utility computing.

`Cache-Control <https://tools.ietf.org/html/rfc7234#section-5.2>`__
    `Cache-Control <https://tools.ietf.org/html/rfc7234#section-5.2>`__
    est l'en-tête au cœur de la gestion de cache en HTTP 1.1. Il est
    assez complexe à appréhender car il peut porter plusieurs
    informations et son interprétation change selon qu'il apparaît dans
    un requête ou dans une réponse. Pour l'instant, disons simplement
    que
    `Cache-Control <https://tools.ietf.org/html/rfc7234#section-5.2>`__
    peut être utilisé pour retourner la directive
    `max-age <https://tools.ietf.org/html/rfc7234#section-5.2.2.8>`__
    qui indique **le nombre de secondes avant que la réponse ne soit
    plus fraîche**.

    La requête

    .. code-block:: http

        GET /web+service HTTP/1.1
        Host: www.dictionary.info

    La réponse du serveur avec l'en-tête Cache-Control et la directive
    ``max-age``

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-type: text/plain; charset=utf-8
        Date: Mon, 26 Mar 2018 15:00:00 GMT
        Last-Modified: Sat, 24 Mar 2018 08:32:00 GMT
        Cache-control: max-age=3600
        Content-length: 226

        A Web Service is a method of communication between two electronic devices over a network.
        It is a software function provided at a network address over the web with the service 
        always on as in the concept of utility computing.

    Si une réponse contient un en-tête ``Expires`` et un en-tête
    ``Cache-Control``, alors un client capable d'interpréter les deux
    en-têtes doit **ignorer** l'en-tête ``Expires``.

Si la réponse du serveur ne contient ni l'en-tête
`Expires <https://tools.ietf.org/html/rfc7234#section-5.3>`__, ni
l'en-tête
`Cache-Control <https://tools.ietf.org/html/rfc7234#section-5.2>`__ mais
que la méthode HTTP de la requête est
:ref:`cacheable <cacheable>`, alors le gestionnaire de
cache peut appliquer une heuristique afin de déduire une date limite de
fraîcheur.

La revalidation
***************

Lorsqu'un gestionnaire de cache détecte qu'une donnée n'est plus
fraîche. Il doit demander une revalidation auprès du serveur d'origine.
La revalidation consiste à émettre une :ref:`requête
conditionnelle <requetes_conditionnelles>` basée sur la
date de dernière modification ou sur l'entity-tag selon les informations
fournies précédemment par le serveur.

Le résultat de la revalidation dépend du résultat de la requête
conditionnelle :

-  Si le serveur répond 304 (Not modified), alors la réponse en cache
   est utilisée comme réponse à la requête.
-  Si le serveur retourne une réponse complète avec un code 2XX, alors
   le serveur informe que la réponse en cache n'est plus valide. La
   réponse retournée par le serveur est celle utilisée pour répondre à
   la requête et le cache est mis à jour en accord avec la réponse du
   serveur.
-  Si le serveur ne répond pas (ou répond une erreur 5XX), alors il est
   possible de retourner l'erreur du serveur comme réponse (ou un
   **504** Gateway Timeout). Il est également possible de considérer que
   la réponse en cache est toujours valide afin de palier à une
   défaillance du réseau.

Les directives de stratégie de cache
************************************

Le serveur peut fournir des directives grâce à l'en-tête de réponse
``Cache-Control``. Si le serveur souhaite fournir plusieurs directives,
il lui suffit de les séparer par une virgule. Ces directives doivent
être prises en charge par tous les caches traitant cette réponse. Parmi
les directives possibles on retiendra :

`no-store <https://tools.ietf.org/html/rfc7234#section-5.2.2.3>`__
    La directive
    `no-store <https://tools.ietf.org/html/rfc7234#section-5.2.2.3>`__
    indique qu'aucun cache ne peut stocker la réponse à cette requête.
    Elle est utilisée pour désactiver le support du cache pour cette
    réponse.

    Attention, les directives ne sont pas fiables. Même si elles sont
    émises par un serveur, leur application dépend de l'implémentation
    des agents utilisateurs et des intermédiaires. Ainsi, la directive
    `no-store <https://tools.ietf.org/html/rfc7234#section-5.2.2.3>`__
    ne suffit pas à garantir la confidentialité d'une réponse.

`no-cache <https://tools.ietf.org/html/rfc7234#section-5.2.2.2>`__
    La directive
    `no-cache <https://tools.ietf.org/html/rfc7234#section-5.2.2.2>`__
    indique que le gestionnaire de cache ne pourra pas utiliser la
    réponse en cache sans l'avoir préalablement revalidée auprès du
    serveur. Cette directive n'empêche pas de stocker la réponse dans le
    cache mais impose que cette réponse ne soit jamais considérée comme
    "fraîche".
`must-revalidate <https://tools.ietf.org/html/rfc7234#section-5.2.2.1>`__
    La directive
    `must-revalidate <https://tools.ietf.org/html/rfc7234#section-5.2.2.1>`__
    indique que lorsque le gestionnaire de cache devra revalider cette
    réponse, il ne devra jamais utiliser la réponse en cache si jamais
    la revalidation échoue. Autrement dit, la revalidation doit réussir
    pour que la réponse en cache puisse être à nouveau utilisée.

La requête

.. code-block:: http

    GET /web+service HTTP/1.1
    Host: www.dictionary.info

La réponse du serveur avec l'en-tête Cache-Control

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Date: Mon, 26 Mar 2018 15:00:00 GMT
    Last-Modified: Sat, 24 Mar 2018 08:32:00 GMT
    Cache-control: no-cache, must-revalidate
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service 
    always on as in the concept of utility computing.

Dans l'exemple ci-dessus, le serveur notifie à un gestionnaire de cache
qu'il ne peut pas utiliser cette réponse à nouveau sans avoir émis une
requête de validation (signification de
`no-cache <https://tools.ietf.org/html/rfc7234#section-5.2.2.2>`__).
Si cette requête de validation échoue, alors il doit impérativement
retourner une erreur (signification de
`must-revalidate <https://tools.ietf.org/html/rfc7234#section-5.2.2.1>`__).

Le client peut également utiliser l'en-tête ``Cache-Control`` afin de
spécifier des directives sur la façon dont un cache peut-être utilisé
dans `le traitement de la
requête <https://tools.ietf.org/html/rfc7234#section-5.2.1>`__.

L'invalidation de cache
***********************

Une clé de cache est invalidée si une requête est émise pour une URI en
cache avec une méthode HTTP qui peut modifier l'état du serveur :
c'est-à-dire les méthodes non sûres ``POST``, ``PUT``, ``DELETE`` et
``PATCH``. Le cache ne sera invalidé que si la réponse est un succès
(code statut 2XX ou 3XX).

La difficulté de la mise en place d'un cache HTTP provient souvent du
fait qu'il est possible d'atteindre un serveur d'origine sans passer
nécessairement par le même gestionnaire de cache. Ainsi, si une réponse
est mise en cache et qu'une requête ``PUT`` est émise vers la même
ressource sans passer par le gestionnaire de cache, alors la réponse en
cache devient invalide. Cependant, le gestionnaire de cache ne pourra
détecter cette modification qu'une fois la date de fraîcheur dépassée
pour la réponse. Il peut donc y avoir un temps de latence entre le
moment où une ressource est modifiée et le moment où le gestionnaire de
cache prend en compte cette modification.

Enrichissement des en-têtes par les intermédiaires
**************************************************

Les intermédiaires peuvent signaler leur présence en ajoutant des
en-têtes dans la requête et dans la réponse. Dans le cadre de la gestion
du cache, nous retiendrons plus particulièrement deux en-têtes :

`Via <https://tools.ietf.org/html/rfc7230#section-5.7.1>`__
    L'en-tête
    `Via <https://tools.ietf.org/html/rfc7230#section-5.7.1>`__ sert
    simplement à un intermédiaire à signaler sa présence en indiquant
    son nom et sa version. Cet en-tête n'est pas spécifique à la gestion
    de cache, mais il est utile de le connaître pour détecter la
    présence d'intermédiaire dans un échange client/serveur. Dans
    l'exemple ci-dessous, on supposera qu'il existe un proxy Squid
    utilisé comme intermédiaire.

    La requête émise par le client

    .. code-block:: http

        GET /web+service HTTP/1.1
        Host: www.dictionary.info

    La requête vue par le serveur

    .. code-block:: http

        GET /web+service HTTP/1.1
        Host: www.dictionary.info
        Via: 1.1 squid

    La réponse du serveur

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-type: text/plain; charset=utf-8
        Content-language: en
        Content-length: 226

        A Web Service is a method of communication between two electronic devices over a network.
        It is a software function provided at a network address over the web with the service 
        always on as in the concept of utility computing.

    La réponse du serveur vue par le client

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-type: text/plain; charset=utf-8
        Content-language: en
        Content-length: 226
        Via: 1.1 squid

        A Web Service is a method of communication between two electronic devices over a network.
        It is a software function provided at a network address over the web with the service 
        always on as in the concept of utility computing.

`Age <https://tools.ietf.org/html/rfc7234#section-5.1>`__
    L'en-tête
    `Age <https://tools.ietf.org/html/rfc7234#section-5.1>`__ permet
    à un intermédiaire de signaler qu'il a retourné une réponse en cache
    sans s'adresser au serveur d'origine. L'intermédiaire indique
    explicitement l'âge en secondes de la réponse depuis la dernière
    validation par le serveur d'origine.

    La requête émise par le client

    .. code-block:: http

        GET /web+service HTTP/1.1
        Host: www.dictionary.info

    La réponse retournée par le cache d'un intermédiaire

    .. code-block:: http

        HTTP/1.1 200 OK
        Content-type: text/plain; charset=utf-8
        Content-language: en
        Content-length: 226
        Age: 22
        Via: 1.1 squid

        A Web Service is a method of communication between two electronic devices over a network.
        It is a software function provided at a network address over the web with the service 
        always on as in the concept of utility computing.

    Dans l'exemple ci-dessus, le proxy Squid signale qu'il a directement
    retourné la réponse sans interroger le serveur d'origine. Le proxy
    estime que la réponse retournée a été validée par le serveur
    d'origine il y a 22 secondes.

