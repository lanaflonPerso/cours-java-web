.. _http_liens:

HTTP : les liens
################

HTTP signifie HyperText Transfer Protocol (protocole de transfert
hypertexte). Par
`hypertexte <https://fr.wikipedia.org/wiki/Hypertexte>`__, il faut
comprendre que les documents transmis par HTTP contiennent des liens
vers d'autres documents. Non seulement les documents se référencent
entre eux, mais il est possible à un client HTTP d'accéder aux autres
documents en suivant une référence qui devient alors un hyperlien.

Ce modèle a été mis en avant par HTML pour ensuite être étendu également
à des documents non textuels (vidéo et images notamment). On parle alors
d'un système **hypermédia**.

HTTP ne se limite donc pas à permettre d'interagir avec une ressource
grâce à des méthodes, il permet également à un client de découvrir de
nouvelles ressources en exploitant les liens qui les relient.

La notion de lien était présente à l'origine dans HTTP avant d'être
supprimée de sa version 1.1. Elle a ensuite été réintroduite en 2010 par
la `RFC 5988 Web Linking <https://tools.ietf.org/html/rfc5988>`__ en se
basant sur le modèle proposé par HTML et ATOM.

La `RFC 5988 <https://tools.ietf.org/html/rfc5988>`__ introduit l'en-tête
``Link`` permettant de déclarer des relations entre des ressources Web.

L'en-tête Link
**************

L'en-tête `Link <https://tools.ietf.org/html/rfc5988#section-5>`__
permet de spécifier un **contexte**, un **type de relation**, une
**cible** et des **attributs optionnels**.

Le contexte correspond normalement à l'URI de la ressource pour laquelle
la requête a été émise. Le type de relation va être fourni par
l'attribut réservé ``rel``. La cible correspond à l'URI du lien.
Quant aux attributs optionnels, ils seront détaillés plus bas.

La requête

.. code-block:: http

    GET /web+service HTTP/1.1
    Host: www.dictionary.info

La réponse du serveur contenant un lien

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Link: <http://www.dictionary.info/web+api>; rel="related"
    Content-language: en
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service always on 
    as in the concept of utility computing.

Dans l'exemple ci-dessus, l'en-tête ``Link`` indique qu'il existe un
terme lié à celui de Web service et qui est accessible à l'URL
*http://www.dictionary.info/web+api*. On peut décomposer le lien de la
façon suivante :

-  Le contexte : http://www.dictionary.info/web+service
-  Le type de relation : related
-  La cible : http://www.dictionary.info/web+api
-  Les attributs optionnels : aucun

Dans cet exemple, ce lien pourrait s'apparenter à une section *voir
aussi*, renvoyant le lecteur vers des définitions pouvant être en
relation avec le mot courant.

On notera la syntaxe particulière de l'en-tête ``Link`` :

.. code-block:: text

    Link: <URI>; rel="type de lien"

Les types de relation
*********************

Le type de relation est donné dans un en-tête ``Link`` par l'attribut
obligatoire ``rel``. Le type de relation définit la sémantique du lien.
Il permet à un client soit d'identifier des ressources connexes qui
peuvent être utilisées pour enrichir la représentation initiale (comme
pour la balise ``link`` en HTML pour lier des feuilles de style), soit
pour permettre d'accéder à une nouvelle ressource si nécessaire.

L'interprétation du type de relation est donc primordiale pour un
client. On distingue les types de relation déclarés et les extensions.

Certains types de relation sont **déclarés** auprès du IANA. Ils
définissent des sémantiques de relation assez précises et sont
utilisables directement par n'importe quel client ou serveur.

Le registre du IANA des types de relation est disponible `en
ligne <http://www.iana.org/assignments/link-relations/link-relations.xhtml>`__.

Parmi les types de relation déclarés, on peut citer :

+--------------+--------------------------------------------------------------------------------------------------------------------+
| Relation     | Description                                                                                                        |
+==============+====================================================================================================================+
| alternate    | Refers to a substitute for this context                                                                            |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| author       | Refers to the context's author.                                                                                    |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| canonical    | Designates the preferred version of a resource (the URI and its contents).                                         |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| collection   | The target URI points to a resource which represents the collection resource for the context URI.                  |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| contents     | Refers to a table of contents.                                                                                     |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| current      | Refers to a resource containing the most recent item(s) in a collection of resources.                              |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| edit         | Refers to a resource that can be used to edit the link's context.                                                  |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| first        | An URI that refers to the furthest preceding resource in a series of resources.                                    |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| item         | The target URI points to a resource that is a member of the collection represented by the context URI.             |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| last         | An URI that refers to the furthest following resource in a series of resources.                                    |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| next         | Indicates that the link's context is a part of a series, and that the next in the series is the link target.       |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| prev         | Indicates that the link's context is a part of a series, and that the previous in the series is the link target.   |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| previous     | Refers to the previous resource in an ordered series of resources. Synonym for "prev".                             |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| related      | Identifies a related resource.                                                                                     |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| replies      | Identifies a resource that is a reply to the context of the link.                                                  |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| search       | Refers to a resource that can be used to search through the link's context and related resources.                  |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| self         | Conveys an identifier for the link's context.                                                                      |
+--------------+--------------------------------------------------------------------------------------------------------------------+
| up           | Refers to a parent document in a hierarchy of documents.                                                           |
+--------------+--------------------------------------------------------------------------------------------------------------------+

Si nous reprenons l'exemple de la requête vers
http://www.dictionary.info/web+service, le serveur pourrait fournir
beaucoup plus de liens en exploitant les relations déclarées :

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Link: <http://www.dictionary.info/web+api>; rel="related",
          <http://www.dictionary.info/soap>; rel="related",
          <http://www.dictionary.info/http>; rel="related",
          <http://www.dictionary.info/web>; rel="prev",
          <http://www.dictionary.info/wysiwig>; rel="next",
          <http://www.dictionary.info/?q=>; rel="search",
          <http://www.dictionary.info/web+service>; rel="self",
          <mailto:dd567@dictionnary.info>; rel="author"
    Content-language: en
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service always on 
    as in the concept of utility computing.

À partir d'une réponse du serveur, le client peut maintenant grâce aux
liens

-  accéder à des mots qui s'apparentent au mot courant (relation
   "related")
-  connaître l'URI du mot précédent dans le dictionnaire (relation
   "prev")
-  connaître l'URI du mot suivant dans le dictionnaire (relation "next")
-  connaître l'URI de la ressource courante (relation "self")
-  connaître l'URI à partir de laquelle on peut effectuer une recherche
   (relation "search")
-  envoyer un mail à l'auteur de cette définition (relation "author")

Il est également possible de définir sa propre sémantique de type de
relation au travers d'une **extension**. Dans ce cas, le type de lien
doit être spécifié par une URI absolue. Cette URI n'a pas nécessairement
besoin de correspondre à une quelconque ressource sur le Web. Elle agit
simplement comme un espace de nom.

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Link: <http://spoonless.github.io/web-services>; rel="http://www.dictionnary.com/course"
    Content-language: en
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service always on 
    as in the concept of utility computing.

Dans l'exemple ci-dessus, le type de relation est
*http://www.dictionnary.com/course*. Cette URI ne pointe pas
nécessairement vers une ressource, elle indique simplement un type de
relation propre au site www.dictionnary.com. Le site doit fournir une
documentation expliquant la sémantique de ce lien afin de permettre à
des éventuels clients de pouvoir exploiter ce type de relation.

Les attributs optionnels d'un lien
**********************************

La `RFC 5988 <https://tools.ietf.org/html/rfc5988>`__ définit les
attributs optionnels suivants pour un lien :

**hreflang**
    indique la langue utilisée dans la cible du lien.
**media**
    indique le type de media à utiliser pour prendre en charge la cible
    du lien
**title**
    le libellé du lien
**type**
    indique le format (content-type) de la cible du lien

.. code-block:: http

    HTTP/1.1 200 OK
    Content-type: text/plain; charset=utf-8
    Link: </web+api>; rel="related"; title="Web API",
          </soap>; rel="related"; title="SOAP",
          </http>; rel="related"; title="HTTP",
          </web>; rel="prev"; title="Web",
          </wysiwig>; rel="next"; title="WISIWIG",
          </?q=>; rel="search"; title="search for a word",
          </web+service>; rel="self"; title="Web Service",
          </web+service.pdf>; rel="alternate"; title="Web Service"; type="application/pdf",
          </web+service?locale=fr>; rel="alternate"; title="Web Service"; hreflang="fr",
          </web+service.wav>; rel="alternate"; title="Web Service"; media="audio",
          <mailto:dd567@dictionnary.info>; rel="author"; title="send a message to the author"
    Content-language: en
    Content-length: 226

    A Web Service is a method of communication between two electronic devices over a network.
    It is a software function provided at a network address over the web with the service always on 
    as in the concept of utility computing.

