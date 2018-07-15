
Les API Web avec Spring MVC
###########################

Une API Web suit les mêmes règles qu'un site Web traditionnel. La différence est
avant tout une différence d'usage. Une API Web fonctionne selon un échange
de requêtes/réponses HTTP mais elle n'est pas utilisée pour fournir un contenu
directement affichable à un individu. La différence porte donc le plus souvent
sur le format des représentations échangées entre le client et le serveur : pour
un site Web, le serveur fournira principalement des pages HTML alors que pour une API Web,
il s'agira d'utiliser des formats de représentation permettant de traiter directement les données
par le dispositif client. Pour ce dernier cas, on privilégie généralement les 
formats JSON et XML, plus simples à analyser par des programmes.

Une API Web peut ainsi être utilisée dans des contextes très divers :

* pour un échange M2M (*Machine to Machine*) dans lequel deux systèmes d'information
  s'échangent des données. 
* plus récemment pour l'Internet des Objets (IoT) afin de permettre à différents 
  dispositifs de communiquer entre eux.
* pour un site Web riche. Le client Web est capable de générer des requêtes HTTP
  asynchrones (*ajax*) pour récupérer des données sur le serveur et mettre à jour
  une partie du contenu de la page.
* pour des applications mobiles (Android / iOS) afin de récupérer des données applicatives
  sur Internet.

L'annotation @RestController
****************************

Une classe annotée avec `@RestController`_ indique qu'il s'agit d'un contrôleur
spécialisé pour le développement d'API Web. `@RestController`_ est simplement
une annotation qui regroupe `@Controller`_ et `@ResponseBody`_. Il s'agit donc
d'un contrôleur dont les méthodes retournent par défaut les données à renvoyer 
au client plutôt qu'un identifiant de vue.

.. note::

    Le qualificatif de REST pour ce contrôleur est malheureusement le résultat
    d'une confusion (courante) des développeurs qui mélangent REST avec API Web
    (et API Web avec JSON).

    REST est l'ensemble des contraintes sur lesquelles sont basés le Web et 
    le protocole HTTP. Donc **tous** les contrôleurs développés avec Spring MVC
    doivent se conformer au modèle REST.
    
    Il aurait été plus juste d'avoir une annotation nommée *@WebApiController*
    pour ce cas particulier de type de contrôleurs. 

Support du format JSON
**********************

Afin de produire directement une représentation JSON d'un objet Java, il est possible
d'utiliser la bibliothèque Jackson. Pour cela, il suffit d'ajouter la dépendance
suivante dans le fichier :file:`pom.xml`.

.. code-block:: xml
    :caption: Dépendance à la bibliothèque Jackson

    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.9.4</version>
    </dependency>

Un contrôleur pour une API Web
******************************

À titre d'exemple, imaginons que nous disposions d'une classe *Item* pour
représenter des données de notre modèle :

.. code-block:: java
    :caption: La classe Item
    
    package ROOT_PKG;

    public class Item {
	
        private String name;

        private String code;

        private int quantity;

        // Getters/setters omis

    }

Nous pouvons très facilement déclarer un contrôleur pour obtenir une représentation
JSON d'une instance de la classe *Item* :

.. code-block:: java
    :caption: Un contrôleur pour une API Web

    package ROOT_PKG;

    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @RequestMapping("/api")
    public class ItemController {
	
        @GetMapping(path="/item", produces= "application/json")
        public Item getItem() {
            Item item = new Item();
            item.setCode("XV-32");
            item.setName("Weird stuff");
            item.setQuantity(10);
            return item;
        }

    }

Une classes annotée avec `@RestController`_ fonctionne de la même façon qu'une
classe annotée avec `@Controller`_. Notez cependant que l'attribut ``produces``
de l'annotation `@GetMapping`_ a été positionné à ``"application/json"``.
Cela signifie que Spring MVC va convertir l'instance de la classe *Item* retournée
par la méthode en une représentation JSON avant de l'envoyer au client.

.. note::

    La sérialisation JSON sera réalisée par la bibliothèque Jackson.
    
Si nous déployons sur notre serveur local notre application dans le contexte ``myapp``, nous
pouvons utiliser le programme cURL_ pour interroger notre API :

.. code-block:: shell

    curl http://localhost:8080/myapp/api/item
    
    {"name":"Weird stuff","code":"XV-32","quantity":10}

La négociation de contenu
*************************

HTTP permet la négociation de contenu proactive. Cela signifie qu'un client peut
envoyer ses préférences au serveur. Ce dernier doit répondre au mieux en fonction
des préférences reçues et de ses capacités. Une négociation possible porte sur
le format de représentation. Cela peut s'avérer utile pour une API Web destinée
à des clients très divers. Par exemple, certains clients peuvent privilégier le
XML et d'autres le JSON.

La négociation proactive pour le type de représentation est réalisée par le client
qui envoie dans sa requête un en-tête ``Accept`` donnant la liste des types MIME
qu'il préfère. Avec Spring MVC, cette négociation est automatiquement gérée
par le contrôleur.

Si on désire créer une API Web capable de produire des réponses au format JSON et XML,
il est possible d'ajouter la dépendance suivante dans le fichier :file:`pom.xml` :

.. code-block:: xml

    <dependency>
        <groupId>com.fasterxml.jackson.dataformat</groupId>
        <artifactId>jackson-dataformat-xml</artifactId>
        <version>2.9.4</version>
    </dependency>

Il s'agit d'une extension de Jackson pour supporter la génération de document
XML à partir d'un objet Java.

.. note::

    Il existe également une bibliothèque incluse dans Java pour lier une représentation
    XML et un objet Java : JAXB (Java API for XML Binding).

Nous pouvons maintenant faire évoluer notre contrôleur pour indiquer qu'il
peut produire du JSON ou du XML en déclarant un tableau de types MIME dans l'attribut
``produces`` :

.. code-block:: java
    :caption: Un contrôleur pour une API Web

    package ROOT_PKG;

    import org.springframework.web.bind.annotation.GetMapping;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @RequestMapping("/api")
    public class ItemController {
	
        @GetMapping(path="/item", produces= {"application/json", "application/xml"})
        public Item getItem() {
            Item item = new Item();
            item.setCode("XV-32");
            item.setName("Weird stuff");
            item.setQuantity(10);
            return item;
        }

    }

Par défaut, ce contrôleur produit toujours du JSON (car le type MIME JSON est placé
en premier dans la liste) mais un client peut indiquer
qu'il préfère une représentation XML grâce à l'en-tête ``Accept`` :

.. code-block:: shell

    curl -H "Accept: application/xml" http://localhost:8080/myapp/api/item
    
    <Item><name>Weird stuff</name><code>XV-32</code><quantity>10</quantity></Item>
    
L'envoi de données
******************

Les API Web sont souvent utilisées pour effectuer des opérations modifiant
l'état du serveur (création, modification, suppression). Pour ces cas, il est toujours
possible d'envoyer au serveur des paramètres d'URI et/ou des données comme
un formulaire HTML. Cependant, comme les formats JSON et XML sont
souvent utilisés comme représentation dans les réponses du serveur, il paraît
cohérent de permettre à un client d'envoyer des données au serveur dans un de ces
formats.

Pour autoriser cela, il suffit d'utiliser l'attribut ``consumes`` pour les annotations
de type `@RequestMapping`_ conjointement avec l'annotation `@RequestBody`_.

.. code-block:: java
    :caption: Un contrôleur acceptant des requêtes au format JSON

    package ROOT_PKG;

    import org.springframework.http.HttpStatus;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.ResponseStatus;
    import org.springframework.web.bind.annotation.RestController;

    @RestController
    @RequestMapping("/api")
    public class ItemController {
	
        @PostMapping(path="/items", consumes="application/json")
        @ResponseStatus(code=HttpStatus.CREATED)
        public void createItem(@RequestBody Item item) {
            // ...
        }

    }

Dans l'exemple ci-dessus, le contrôleur accepte une requête ``POST`` pour le chemin
:file:`/api/items` contenant des données au format JSON. Le paramètre ``item``
dispose de l'annotation `@RequestBody`_. Donc Spring MVC va considérer que
ce paramètre représente le corps de la requête. Il va donc tenter de convertir
le document JSON en une instance de la classe *Item*.

.. note::

    La désérialisation du documnt JSON vers l'objet Java sera réalisée par la bibliothèque Jackson.

Si nous déployons sur notre serveur local notre application dans le contexte ``myapp``, nous
pouvons utiliser le programme cURL_ pour envoyer des données à notre API :

.. code-block:: shell

    curl -H "Content-type: application/json" -d '{"name":"mon item","code":"1337","quantity":1}' http://localhost:8080/myapp/api/items
    
Comme pour le contenu d'une réponse, nous pouvons autoriser plusieurs formats de
représentation dans un contrôleur en fournissant une liste à l'attribut ``consumes`` :

::

    @PostMapping(path="/items", consumes={"application/json", "application/xml"})
    @ResponseStatus(code=HttpStatus.CREATED)
    public void createItem(@RequestBody Item item) {
        // ...
    }

La réponse
**********

Par défaut, un contrôleur pour une API Web retourne un code statut HTTP 200 si
la méthode retourne un objet ou 204 (No Content) si la méthode retourne ``void``.
Si on désire positionner un code statut particulier, il est possible d'utiliser
l'annotation `@ResponseStatus`_ avec un code particulier parmi l'énumération HttpStatus_.

.. code-block:: java
    :caption: Changement du code statut de la réponse avec une annotation

    @PostMapping(path="/items", consumes={"application/json", "application/xml"})
    @ResponseStatus(code=HttpStatus.CREATED)
    public void createItem(@RequestBody Item item) {
        // ...
    }

Si on désire contrôler plus finement le contenu de la réponse, il est possible
de retourner un objet de type `ResponseEntity<T>`_.

::

    package ROOT_PKG;

    import java.net.URI;

    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.PostMapping;
    import org.springframework.web.bind.annotation.RequestBody;
    import org.springframework.web.bind.annotation.RequestMapping;
    import org.springframework.web.bind.annotation.RestController;
    import org.springframework.web.util.UriComponentsBuilder;

    @RestController
    @RequestMapping("/api")
    public class ItemController {
	
        @PostMapping(path="/items", consumes="application/json", produces="application/json")
        public ResponseEntity<Item> createItem(@RequestBody Item item, 
                                               UriComponentsBuilder uriBuilder) {
            
            // ...
            
            URI uri = uriBuilder.path("/api/items/{code}").buildAndExpand(item.getCode()).toUri();
            return ResponseEntity.created(uri).body(item);
        }

    }

Un objet `ResponseEntity<T>`_ peut être créé à partir de méthodes statiques
correspondant aux cas d'utilisation les plus courants en HTTP. Dans l'exemple
ci-dessus, la méthode `ResponseEntity<T>.created`_ permet de créer une réponse
avec code statut 201 (*Created*) et un en-tête ``Location`` contenant le lien vers
la ressource créée sur le serveur. Ainsi la méthode `ResponseEntity<T>.created`_
attend en paramètre l'URI de la ressource. Dans l'exemple ci-dessus, on accède
à une instance de UriComponentsBuilder_ qui est fournie par Spring MVC afin
de nous aider à construire une URI pour une ressource du serveur.
    
Si nous déployons sur notre serveur local notre application dans le contexte ``myapp``, nous
pouvons utiliser le programme cURL_ pour envoyer des données à notre API :

.. code-block:: shell

    curl -i -H "Content-type: application/json" -d '{"name":"mon item","code":"1337","quantity":1}' http://localhost:8080/myapp/api/items
    
    HTTP/1.1 201 
    Location: http://localhost:8080/myapp/api/items/1337
    Content-Type: application/json;charset=UTF-8
    Transfer-Encoding: chunked
    Date: Tue, 06 Mar 2018 10:00:00 GMT

    {"name":"mon item","code":"1337","quantity":1}
    

RestControllerAdvice
********************

Comme pour les contrôleurs de base, il est possible d'ajouter dans un contrôleur
pour une API Web des méthodes pour gérer les exceptions (annotées avec `@ExceptionHandler`_),
des méthodes de *binder* (annotées avec `@InitBinder`_) et des méthodes de modèle
(annotées avec `@ModelAttribute`_).

Afin de réutiliser ces méthodes à travers plusieurs contrôleurs, il est aussi possible
de les regrouper dans une classe annotée avec `@RestControllerAdvice`_. Comme
pour l'annotation `@RestController`_, `@RestControllerAdvice`_ est une annotation
composée de `@ControllerAdvice`_ et de `@ResponseBody`_. Concrètement, elle
change l'interprétation par défaut des méthodes de gestion des exceptions, en
considérant que la valeur de retour correspond à la réponse à sérialiser
directement dans la représentation de la réponse (le plus souvent pour
créer un document XML ou JSON).

Les annotations Jackson
***********************

Si vous utilisez la bibliothèque Jackson pour convertir les objets Java en XML ou JSON,
vous pouvez utiliser des annotations dans la déclaration des objets afin de modifier
le comportement par défaut de la sérialisation/désérialisation.

.. tip::

    Pour tester la conversion d'un objet Java en JSON *via* Jackson vous pouvez
    écrire un programme (ou un test) en utilisant une instance de la classe ObjectMapper_
    fournie par Jackson :
    
    .. code-block:: java
        :caption: Un programme qui produit un document JSON sur la sortie standard
        
        package ROOT_PKG;

        import com.fasterxml.jackson.databind.ObjectMapper;

        public class JacksonSerialisation {

            public static void main(String[] args) throws Exception {
                Object obj = new Item();

                ObjectMapper objectMapper = new ObjectMapper();
                System.out.println(objectMapper.writeValueAsString(obj));
            }
	
        }
        
    Pour tester la conversion d'un objet Java en XML *via* Jackson, il faut
    utiliser la classe XmlMapper_ fournie par Jackson :
    
    .. code-block:: java
        :caption: Un programme qui produit un document XML sur la sortie standard
        
        package ROOT_PKG;

        import com.fasterxml.jackson.dataformat.xml.XmlMapper;

        public class JacksonSerialisation {

            public static void main(String[] args) throws Exception {
                Object obj = new Item();

                XmlMapper xmlMapper = new XmlMapper();
                System.out.println(xmlMapper.writeValueAsString(obj));
            }
	
        }


Parmi les annotations utiles, on peut citer :

`@JsonProperty`_
    Cette annotation ajoutée à un attribut permet de spécifier le nom de la propriété dans le document JSON 
    ou le nom de l'élément dans un document XML.
`@JsonIgnore`_
    Cette annotation ajoutée à un attribut permet d'exclure cet attribut de la sérialisation/désérialisation.
`@JsonRootName`_
    Cette annotation ajoutée sur une classe permet de spécifier le nom de l'élément s'il doit
    apparaître à la racine du document. Cette annotation est surtout utile pour la génération de document
    XML afin de changer le nom de l'élément racine.
`@JsonPropertyOrder`_
    Cette annotation ajoutée à une classe permet de fixer l'ordre des éléments dans le document.
`@JsonView`_
    Cette annotation ajoutée à un attribut permet de définir un ou des vues JSON pour lesquelles
    cet attribut doit apparaître (Cf exemple ci-dessous).

.. note::

    Pour la liste complète des annotations disponibles avec Jackson, vous pouvez
    vous reporter à la `documentation officielle <https://github.com/FasterXML/jackson-annotations/wiki/Jackson-Annotations>`__.

Reprenons notre classe *Item* en ajoutant des annotations Jackson :
    
::

    package ROOT_PKG;

    import com.fasterxml.jackson.annotation.JsonProperty;
    import com.fasterxml.jackson.annotation.JsonPropertyOrder;
    import com.fasterxml.jackson.annotation.JsonRootName;

    @JsonRootName("item")
    @JsonPropertyOrder({"nom", "code", "quantite"})
    public class Item {

        @JsonProperty("nom")
        private String name;

        private String code;

        @JsonProperty("quantite")
        private int quantity;

        // Getters/setters omis

    }
    
La sérialisation avec Jackson d'un objet de la classe *Item* donnera les documents
suivants :

.. code-block:: json
    :caption: sérialisation en JSON
    
    {"nom":"Weird stuff","code":"XV-35","quantite":1}

.. code-block:: xml
    :caption: sérialisation en XML
    
    <item><nom>Weird stuff</nom><code>XV-35</code><quantite>1</quantite></item>

Les vues JSON
=============

L'utilisation de vues JSON permet de ne convertir qu'une partie de l'objet. Pour
cela, nous créons des interfaces qui servent à désigner des vues. Pour notre exemple,
nous allons créer les interfaces *ItemViewWithoutQuantity* et *ItemViewWithQuantity* :

.. code-block:: java
    :caption: les interfaces représentant les vues JSON
    
    package ROOT_PKG;

    public interface ItemViewWithoutQuantity {

    }

    package ROOT_PKG;

    public interface ItemViewWithQuantity extends ItemViewWithoutQuantity {

    }

Notez que *ItemViewWitQuantity* hérite de *ItemViewWithoutQuantity* car dans notre
exemple nous voulons simplement exclure dans certains cas l'attribut quantity
de la sérialisation. Nous pouvons revoir la définition de la classe *Item* en
ajoutant des annotations `@JsonView`_ pour attribuer une vue à chaque attribut :

.. code-block:: java
    :caption: déclaration des vues JSON

    package ROOT_PKG;

    import com.fasterxml.jackson.annotation.JsonProperty;
    import com.fasterxml.jackson.annotation.JsonPropertyOrder;
    import com.fasterxml.jackson.annotation.JsonRootName;
    import com.fasterxml.jackson.annotation.JsonView;

    @JsonRootName("item")
    @JsonPropertyOrder({"nom", "code", "quantite"})
    public class Item {

        @JsonProperty("nom")
        @JsonView(ItemViewWithoutQuantity.class)
        private String name;

        @JsonView(ItemViewWithoutQuantity.class)
        private String code;

        @JsonProperty("quantite")
        @JsonView(ItemViewWithQuantity.class)
        private int quantity;

        // Getters/setters omis

    }

Il faut maintenant faire évoluer le programme de sérialisation pour indiquer
à l'instance de ObjectMapper_ quelle vue nous souhaitons utiliser :

.. code-block:: java
    :caption: programme de sérialisation JSON en précisant une vue

    package ROOT_PKG;

    import com.fasterxml.jackson.databind.ObjectMapper;

    public class JacksonSerialisation {

        public static void main(String[] args) throws Exception {
            Item obj = new Item();
            obj.setCode("XV-35");
            obj.setName("Weird stuff");
            obj.setQuantity(1);

            ObjectMapper objectMapper = new ObjectMapper();
            System.out.println(objectMapper.writerWithView(ItemViewWithoutQuantity.class)
                                           .writeValueAsString(obj));
        }

    }
    
La sortie du programme sera :

.. code-block:: json
    :caption: sérialisation en JSON
    
    {"nom":"Weird stuff","code":"XV-35"}

L'attribut ``quantite`` n'est pas présent dans le document JSON car le programme
limite la sérialisation à la vue *ItemViewWithoutQuantity*.

.. note::

    Les vues JSON son facilement utilisables dans un contrôleur Spring car on peut
    préciser la vue grâce à l'annotation `@JsonView`_ sur la valeur de retour
    d'une méthode :
    
    ::

        package ROOT_PKG;

        import java.net.URI;

        import org.springframework.http.ResponseEntity;
        import org.springframework.web.bind.annotation.PostMapping;
        import org.springframework.web.bind.annotation.RequestBody;
        import org.springframework.web.bind.annotation.RequestMapping;
        import org.springframework.web.bind.annotation.RestController;
        import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
        import org.springframework.web.util.UriComponentsBuilder;

        import com.fasterxml.jackson.annotation.JsonView;

        @RestController
        @RequestMapping("/api")
        public class ItemController extends ResponseEntityExceptionHandler{
	
            @PostMapping(path="/items", consumes="application/json", produces="application/json")
            @JsonView(ItemViewWithoutQuantity.class)
            public ResponseEntity<Item> createItem(@RequestBody Item item, UriComponentsBuilder uriBuilder) {
                System.out.println(item.getCode());
                URI uri = uriBuilder.path("/api/item/{code}").buildAndExpand(item.getCode()).toUri();
                return ResponseEntity.created(uri).body(item);
            }

        }


Implémentation d'un client
**************************

Spring MVC fournit la classe RestTemplate_ permettant d'effectuer des requêtes HTTP.
Cette classe permet de convertir les objets Java au format JSON ou XML
pour une requête (et inversement de transformer un réponse du serveur au format
JSON ou XML en instance d'un objet Java).

En reprenant notre exemple précédent pour la création d'un *Item*, on peut écrire
l'application client suivante :

.. code-block:: java
    :caption: un exemple d'application cliente avec RestTemplate

    package ROOT_PKG;

    import java.net.URI;

    import org.springframework.http.HttpEntity;
    import org.springframework.http.HttpHeaders;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.client.RestTemplate;

    public class WebApiClient {

        public static void main(String[] args) throws Exception {
            RestTemplate client = new RestTemplate();
            URI uri = new URI("http://localhost:8080/myapp/api/items");

            HttpHeaders requestHeaders = new HttpHeaders();
            requestHeaders.set("Content-type", "application/json");

            Item item = new Item();
            item.setCode("1337");
            item.setName("weird stuff");
            item.setQuantity(1);

            HttpEntity<Item> entity = new HttpEntity<Item>(item, requestHeaders);
            ResponseEntity<Item> responseEntity = client.postForEntity(uri, entity, Item.class);

            System.out.println(responseEntity.getHeaders().getLocation());
            Item itemResultat = responseEntity.getBody();
            System.out.println(itemResultat.getCode());
        }
	
    }

.. note::

    Spring 5 a introduit un nouvelle classe pour implémenter un client HTTP : WebClient_
    

Exercice
********

.. admonition:: Écrire des tests unitaires pour un contrôleur
    :class: hint

    Spring MVC fournit diverses manières de tester ses contrôleurs. La façon
    la plus rapide à mettre en place et à exécuter consiste à utiliser une
    instance de MockMvc_ pour simuler un environnement Web.
    
    Afin de tester un contrôleur, il faut disposer des artefacts **spring-test**
    et **junit** comme dépendances de test dans le fichier :file:`pom.xml` :
    
    .. code-block:: xml
        :caption: Dépendances de test pour spring-test et junit
        
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>5.0.7.RELEASE</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.12</version>
            <scope>test</scope>
        </dependency>

    On peut ensuite créer une classe de test avec une méthode d'initialisation
    qui crée une instance de MockMvc_ pour le contrôleur que l'on souhaite tester :
    
    .. code-block:: java
        :caption: Exemple d'une classe de test d'un contrôleur        

        package ROOT_PKG;

        import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
        import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
        import static org.springframework.test.web.servlet.setup.MockMvcBuilders.*;

        import org.junit.Before;
        import org.junit.Test;
        import org.springframework.http.MediaType;
        import org.springframework.test.web.servlet.MockMvc;

        public class ItemControllerTest {

            private MockMvc mockMvc;

            @Before
            public void setup() {
                this.mockMvc = standaloneSetup(new ItemController()).build();
            }

            @Test
            public void testName() throws Exception {
                mockMvc.perform(post("/api/items").contentType(MediaType.APPLICATION_JSON)
                               .content("{\"name\":\"mon item\",\"code\":\"666\",\"quantity\":1}")).
                        andExpect(status().isCreated()).
                        andExpect(header().string("Location", "http://localhost/api/item/666"));
            }

        }
        
    Écrivez des tests pour vos contrôleurs.

.. _@Controller: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/stereotype/Controller.html
.. _@RequestMapping: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestMapping.html
.. _@GetMapping: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/GetMapping.html
.. _@ModelAttribute: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ModelAttribute.html
.. _@InitBinder: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/InitBinder.html
.. _@ResponseBody: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ResponseBody.html
.. _@ExceptionHandler: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ExceptionHandler.html
.. _@ResponseStatus: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ResponseStatus.html
.. _@ControllerAdvice: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/ControllerAdvice.html
.. _@RestController: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html
.. _@RequestBody: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RequestBody.html
.. _HttpStatus: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/HttpStatus.html
.. _ResponseEntity<T>: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.html
.. _ResponseEntity<T>.created: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/http/ResponseEntity.html#created-java.net.URI-
.. _UriComponentsBuilder: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/util/UriComponentsBuilder.html
.. _@RestControllerAdvice: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestControllerAdvice.html
.. _ObjectMapper: https://fasterxml.github.io/jackson-databind/javadoc/2.9/com/fasterxml/jackson/databind/ObjectMapper.html
.. _XmlMapper: https://fasterxml.github.io/jackson-dataformat-xml/javadoc/2.9/com/fasterxml/jackson/dataformat/xml/XmlMapper.html
.. _@JsonProperty: https://fasterxml.github.io/jackson-annotations/javadoc/2.9/com/fasterxml/jackson/annotation/JsonProperty.html
.. _@JsonIgnore: https://fasterxml.github.io/jackson-annotations/javadoc/2.9/com/fasterxml/jackson/annotation/JsonIgnore.html
.. _@JsonRootName: https://fasterxml.github.io/jackson-annotations/javadoc/2.9/com/fasterxml/jackson/annotation/JsonRootName.html
.. _@JsonPropertyOrder: https://fasterxml.github.io/jackson-annotations/javadoc/2.9/com/fasterxml/jackson/annotation/JsonPropertyOrder.html
.. _@JsonView: https://fasterxml.github.io/jackson-annotations/javadoc/2.9/com/fasterxml/jackson/annotation/JsonView.html
.. _RestTemplate: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html
.. _MockMvc: https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/test/web/servlet/MockMvc.html
.. _curl: https://curl.haxx.se/
.. _WebClient: https://docs.spring.io/spring/docs/current/spring-framework-reference/web-reactive.html#webflux-client
