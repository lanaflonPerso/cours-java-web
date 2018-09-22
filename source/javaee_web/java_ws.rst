Les services Web avec Java
##########################

.. note::

  Pour ce cours, vous aurez besoin de l'outil SoapUI. **Vous devez le
  télécharger** à l'adresse
  https://www.soapui.org/downloads/soapui/source-forge.html

La quête de l'interopérabilité
******************************

Une problématique courante dans la mise en place de systèmes
d'information et de savoir comment échanger des informations entre
plusieurs processus. Cette problématique est souvent résumée par la
notion
`d'interopérabilité <https://fr.wikipedia.org/wiki/Interop%C3%A9rabilit%C3%A9>`__.
D'un point de vue technique, l'interopérabilité est rendue plus complexe
par un ou plusieurs facteurs :

-  les programmes sont écrits dans des langages différents
-  les processus s'exécutent sur des machines différentes
-  les machines appartiennent à des réseaux différents

Avant l'an 2000, on trouve des solutions telles que Sun RPC, CORBA,
DCOM, RMI. À partir des années 2000, le succès des réseaux IP, de HTTP
et de XML apporte une nouvelle perspective : définir un protocole
d'échange de messages XML *via* HTTP entre deux processus.

Ce protocole originellement défini par Microsoft puis maintenu par le W3
s'appelle SOAP_. Depuis SOAP_ a été enrichi de nombreuses
spécifications et l'ensemble de ces technologies sont désignées sous le
terme **WS-\***.

WS-\* est un ensemble de technologies, il ne s'agit ni d'un modèle de
conception ni d'un modèle d'architecture.

SOAP : structure des messages
*****************************

SOAP_ est une recommandation pour
l'échange de messages au format XML entre un expéditeur (*SOAP sender*) et
un destinataire (*SOAP receiver*). La structure des messages SOAP est
identique qu'elle provienne de l'expéditeur (requête) ou du destinataire
(réponse). Un message est constitué par une enveloppe (*SOAP
envelope*) qui peut contenir un en-tête (*SOAP header*) et ensuite
une charge utile (*SOAP body*).

Pour une utilisation avec le protocole HTTP, le message doit être envoyé
avec la méthode POST à l'URL du service (appelée aussi **endpoint**)

.. code-block:: xml
    :caption: Exemple de message SOAP

    <soapenv:Envelope
       xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
       xmlns:m="http://www.mymeteo.com/meteo">
       <soapenv:Header>
       </soapenv:Header>
       <soapenv:Body>
          <m:releve>
             <m:temperature>
                <m:valeur>6.0</m:valeur>
                <m:unite>celsius</m:unite>
             </m:temperature>
             <m:lieu>
                <m:ville>Bordeaux</m:ville>
             </m:lieu>
          </m:releve>
       </soapenv:Body>
    </soapenv:Envelope>

Dans l'exemple ci-dessus le message contient de toute évidence un relevé
météorologique pour la ville de bordeaux. Ce message peut aussi bien
être une requête d'un expéditeur qu'une réponse d'un destinataire (la
structure des messages est la même).

.. note::

  Du fait de son utilisation exclusive du XML pour la composition des
  messages, une bonne compréhension de SOAP_ nécessite une connaissance
  approfondie de XML (*Cf.* :ref:`le complément au cours sur
  XML <annexe_xml>`).

Un message SOAP_ est défini pour le namespace XML
http://schemas.xmlsoap.org/soap/envelope/

.. code-block:: xml
    :caption: Structure d'un message SOAP

    <!-- l'enveloppe du message -->
    <soapenv:Envelope
       xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">

      <!-- l'en-tête du message -->
      <soapenv:Header>
        <!-- les éventuelles méta-informations -->
      </soapenv:Header>

      <!-- le corps de la requête -->
      <soapenv:Body>
        <!-- le message (payload) -->
      </soapenv:Body>

    </soapenv:Envelope>

SOAP_ définit un format pour un type de réponse particulière : une *SOAP
fault*. Une *SOAP fault* signale un problème lors du traitement du
service.

.. code-block:: xml
    :caption: Une réponse contenant une SOAP fault

    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
       <soap:Body>
          <soap:Fault>
             <faultcode>soap:Server</faultcode>
             <faultstring>Internal server error</faultstring>
          </soap:Fault>
       </soap:Body>
    </soap:Envelope>

Pour l'élément ``faultcode``, on peut utiliser les valeurs :

-  {http://schemas.xmlsoap.org/soap/envelope/}:Server pour signaler que
   l'origine de l'incident provient du traitement du serveur
-  {http://schemas.xmlsoap.org/soap/envelope/}:Client pour signaler que
   l'origine de l'incident provient de la requête du client

Web Service Description Language (WSDL)
***************************************

La condition pour utiliser un service Web SOAP_ est de connaître les
opérations disponibles et le format des messages autorisés en entrée
et/ou en sortie de ses opérations. **WSDL** (*Web Service Description
Language*) est un langage XML permettant la description complète d'un
service Web. Ainsi un fichier WSDL est analysable par programme et on
trouve des outils dans différents langages de programmation pour générer
du code (les *stubs*) facilitant le développement des programmes (client
ou serveur).

.. note:: 
    
    La plupart des *stacks* SOAP_ donne accès au WSDL en ligne (en le
    générant dynamiquement si nécessaire).

    Par exemple, pour les serveurs d'application Java EE, le WSDL est
    disponible à la même URL que le service en ajoutant **wsdl** comme
    paramètre.

    .. code-block:: text
        :caption: Exemple d'URL pour accéder au WSDL

        http://localhost:8080/MeteoService?wsdl

.. code-block:: xml
    :caption: Exemple de WSDL

    <?xml version='1.0' encoding='UTF-8'?>
    <definitions
      xmlns="http://schemas.xmlsoap.org/wsdl/"
      xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
      xmlns:wsam="http://www.w3.org/2007/05/addressing/metadata"
      xmlns:tns="http://www.mymeteo.com/webservices/meteo"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:ns1="http://www.mymeteo.com/meteo"
      targetNamespace="http://www.mymeteo.com/webservices/meteo"
      name="MeteoService"
    >

      <!-- Les types de données au format XML schema -->
      <types>
        <xs:schema version="1.0" targetNamespace="http://www.mymeteo.com/meteo"
                   elementFormDefault="qualified">
          <xs:complexType name="temperature">
            <xs:sequence>
              <xs:element name="valeur" type="xs:double"/>
              <xs:element name="unite" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>

          <xs:complexType name="lieu">
            <xs:sequence>
              <xs:element name="ville" type="xs:string"/>
            </xs:sequence>
          </xs:complexType>

          <xs:complexType name="releve">
            <xs:sequence>
              <xs:element name="temperature" type="ns1:temperature"/>
              <xs:element name="lieu" type="ns1:lieu"/>
            </xs:sequence>
          </xs:complexType>

          <xs:element name="lieu" type="ns1:lieu"/>
          <xs:element name="releve" type="ns1:releve"/>
        </xs:schema>
      </types>

      <!--
        La description de tous les messages possibles.
        Un message est défini par un ensemble de parties (une partie pour le payload
        et une partie par en-tête)
      -->
      <message name="releveMeteo">
        <part name="partLieu" element="ns1:lieu"/>
      </message>

      <message name="releveMeteoResponse">
        <part name="partReleve" element="ns1:releve"/>
      </message>

      <!--
        Description des interfaces (indépendantes de SOAP)
        Une interface est composée d'un ensemble d'opérations.
        Chaque opération est définie par les messages en entrée et en sortie.
      -->
      <portType name="MeteoService">
        <operation name="releveMeteo">
          <input
            wsam:Action="http://www.mymeteo.com/webservices/meteo/MeteoService/releveMeteoRequest"
            message="tns:releveMeteo"/>
          <output
            wsam:Action="http://www.mymeteo.com/webservices/meteo/MeteoService/releveMeteoResponse"
            message="tns:releveMeteoResponse"/>
        </operation>
      </portType>

      <!-- Liaison des interfaces avec le protocole SOAP -->
      <binding name="MeteoServicePortBinding" type="tns:MeteoService">
        <soap:binding transport="http://schemas.xmlsoap.org/soap/http" style="document"/>
        <operation name="releveMeteo">
          <soap:operation soapAction=""/>
          <input>
            <soap:body use="literal"/>
          </input>
          <output>
            <soap:body use="literal"/>
          </output>
        </operation>
      </binding>

      <!--
        Localisation du service
        Dans le cas d'un binding SOAP avec un transport HTTP, on trouve ici l'URL du service.
      -->
      <service name="MeteoService">
        <port name="MeteoServicePort" binding="tns:MeteoServicePortBinding">
          <soap:address location="http://www.mymeteo.com/ws/meteo"/>
        </port>
      </service>
    </definitions>

Développer un service Web SOAP
******************************

On distingue deux approches pour développer un service Web WS-\* :

*Contract first*
    On définit le contrat du service en spécifiant le WSDL et on utilise
    des outils pour générer le code des *stubs*.

*Contract last*
    On développe le service et on utilise des outils pour générer le
    WSDL.

Exercice
********

.. admonition:: Accéder à un service Web
    :class: hint

    Testez le service Web SOAP disponible à cette adresse :
    http://ws-meteo.herokuapp.com/

    Pour tester ce service Web, vous pouvez utiliser le client
    `SoapUI <https://www.soapui.org/downloads/soapui/source-forge.html>`__.

.. _jaxws_gentools:

Les outils Java de génération
*****************************

*Java → WSDL (Contract last)*
    L'utilitaire
    `wsgen <http://docs.oracle.com/javase/7/docs/technotes/tools/share/wsgen.html>`__
    livré avec le JDK peut générer un fichier WSDL à partir d'une classe
    compilée.
    On peut demander à un serveur Java EE de générer le WSDL après le
    déploiement du service en passant ``wsdl`` comme paramètre de l'URL du
    service.
*WSDL → Java (Contract first)*
    L'utilitaire
    `wsimport <http://docs.oracle.com/javase/7/docs/technotes/tools/share/wsimport.html>`__
    livré avec le JDK peut générer toutes les classes Java nécessaires à
    l'implémentation d'un client ou d'un service à partir d'un fichier
    WSDL.

    .. code-block:: shell
        :caption: Générer les classes compilées

        wsimport http://localhost:8080/hello-service/webservices/HelloService?wsdl

    .. code-block:: shell
        :caption: Générer uniquement les sources

        wsimport -Xnocompile http://localhost:8080/hello-service/webservices/HelloService?wsdl

Consommer un service Web avec JAX-WS
************************************

Une application cliente d'un service Web SOAP peut utiliser un *stub*.
Un *stub* est une classe générée qui masque la complexité des échanges de
messages avec le serveur.

Il est possible de créer un client à partir du code généré par
**wsimport**.

.. code-block:: java
    :caption: Exemple d'accès à la SEI pour un client

    // L'URL du WSDL (peut-être un fichier sur disque ou un lien HTTP)
    java.net.URL wsdlDocumentLocation = new java.net.URL("file:HelloService.wsdl");

    // Le qualified name du service spécifié par les attributs
    // targetNamespace et name de la balise racine dans le WSDL
    javax.xml.namespace.QName serviceName =
                 new javax.xml.namespace.QName("http://spoonless.github.io/ws/hello","HelloService");

    // Creation d'une stub vers le service Web
    javax.xml.ws.Service service = javax.xml.ws.Service.create(wsdlDocumentLocation, serviceName);

    // La SEI offrant les méthodes du service Web sous la forme d'un interface Java
    // L'interface est celle générée par wsimport
    HelloService helloService = service.getPort(HelloService.class);

    // Exemple d'appel du service
    System.out.println(helloService.sayHello("world"));

Le code précédent pose un problème : le client utilise l'URL du service
spécifiée dans la section *wsdl:service* du WSDL. Il est souvent utile
de pouvoir changer dynamiquement l'URL du *endpoint*.

.. code-block:: java
    :caption: Modification de l'URL du endpoint du service

    // ...

    // La SEI offrant les méthodes du service Web sous la forme d'un interface Java
    // L'interface est celle générée par wsimport
    HelloService helloService = service.getPort(HelloService.class);

    // Un service implémente l'interface javax.xml.ws.BindingProvider
    javax.xml.ws.BindingProvider bp = (javax.xml.ws.BindingProvider) helloService;

    // ENDPOINT_ADDRESS_PROPERTY est une propriété donnant l'URL du endpoint
    bp.getRequestContext().put(javax.xml.ws.BindingProvider.ENDPOINT_ADDRESS_PROPERTY,
                               "http://monendpoint.com/monservice");

    // Exemple d'appel du service
    System.out.println(helloService.sayHello("world"));

Exercice
********
.. admonition:: Écrire un programme client d'un service Web
    :class: hint

    Écrivez une client pour le service Web SOAP disponible à cette adresse :
    http://ws-meteo.herokuapp.com/.

    Par exemple, vous pouvez écrire un programme qui accepte le nom d'une
    ville en paramètre et qui affiche la température obtenue pour cette
    ville après un appel au service Web.

    En Java, pensez à utiliser :ref:`wsimport <jaxws_gentools>` pour
    générer le *stub* client.

.. _jaws_sei:

Implémenter des services Web avec JAX-WS
****************************************

Depuis Java 6, l'environnement d'exécution Java inclut JAX-WS qui est
l'API permettant d'implémenter des services Web et JAXB (Java API for
XML Binding) permettant d'associer une classe Java à une représentation
XML.

L'implémentation d'un service Web passe par l'écriture et
l'implémentation d'une **SEI** (Service Endpoint Implementation). Cette
interface et son implémentation peuvent être fournies par le développeur
ou peuvent être générées à partir d'un ficher WSDL (*Cf.* ci-dessous).

.. code-block:: java
    :caption: Une SEI avec JAX-WS SOAP

  {% if not jupyter %}
  package ROOT_PKG;
{% endif %}

    import javax.jws.WebMethod;
    import javax.jws.WebParam;
    import javax.jws.WebResult;
    import javax.jws.WebService;
    import javax.jws.soap.SOAPBinding;

    @WebService(targetNamespace="http://spoonless.github.io/ws/hello")
    @SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
    public interface HelloService {

      @WebMethod
      @WebResult(name = "helloMessage", targetNamespace = "http://spoonless.github.io/ws/hello")
      public String sayHello(
          @WebParam(name = "who", targetNamespace="http://spoonless.github.io/ws/hello") String name);

    }

.. code-block:: java
    :caption: La classe d'implémentation de la SEI

  {% if not jupyter %}
  package ROOT_PKG;
{% endif %}

    import javax.jws.WebService;

    @WebService(endpointInterface="ROOT_PKG.HelloService",
        targetNamespace="http://spoonless.github.io/ws/hello", serviceName="HelloService")
    public class HelloServiceImpl implements HelloService {

      @Override
      public String sayHello(String name) {
        return "Hello " + name;
      }

    }

.. note::

    Il est également possible de définir une SEI directement avec une classe
    Java sans passer par une interface :

    ::

      {% if not jupyter %}
  package ROOT_PKG;
{% endif %}

        import javax.jws.WebMethod;
        import javax.jws.WebParam;
        import javax.jws.WebResult;
        import javax.jws.WebService;
        import javax.jws.soap.SOAPBinding;

        @WebService(targetNamespace="http://spoonless.github.io/ws/hello", serviceName="HelloService")
        @SOAPBinding(parameterStyle = SOAPBinding.ParameterStyle.BARE)
        public class HelloService {
          @WebMethod
          @WebResult(name = "helloMessage", targetNamespace = "http://spoonless.github.io/ws/hello")
          public String sayHello(
              @WebParam(name = "who", targetNamespace="http://spoonless.github.io/ws/hello") String name) {
            return "Hello " + name;
          }
        }

Cette **SEI** permet de gérer un échange de messages comme celui-ci :

.. code-block:: xml
    :caption: Message de l'expéditeur

    <soapenv:Envelope
      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:hel="http://spoonless.github.io/ws/hello">
       <soapenv:Header/>
       <soapenv:Body>
          <hel:who>world</hel:who>
       </soapenv:Body>
    </soapenv:Envelope>

.. code-block:: xml
    :caption: Message du destinataire

    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
       <soapenv:Body>
          <helloMessage xmlns="http://spoonless.github.io/ws/hello">Hello world</helloMessage>
       </soapenv:Body>
    </soapenv:Envelope>

Nous allons maintenant décrire les annotations Java utilisées pour
transformer la classe ``HelloService`` en service Web :

`@WebService <https://docs.oracle.com/javase/8/docs/api/javax/jws/WebService.html>`__
    Désigne une classe comme étant une SEI ou une implémentation d'une
    SEI. Elle possède entre-autres les attributs suivants :

    serviceName
        Le nom du service tel qu'exposé dans le WSDL
    targetNamespace
        Le namespace XML du service tel qu'exposé dans le WSDL
    endpointInterface
        Désigne l'interface Java correspondante au SEI. À spécifier sur
        la classe d'implémentation du SEI.

`@SOAPBinding <https://docs.oracle.com/javase/8/docs/api/javax/jws/soap/SOAPBinding.html>`__
    Indique le support SOAP pour le service. Les informations données
    par les attributs de cette annotation correspondent pour la plupart
    à celles que l'on trouve dans la section ``binding`` du WSDL. Cette
    annotation possède entre-autres les attributs suivants :

    style
        Définit s'il s'agit d'un service RPC ou Document.
    parameterStyle
        Détermine si un paramètre de la méthode représente la charge
        utile du message SOAP (le body) ou si ce paramètre doit être
        encapsulé (*wrapped*) dans un élément racine XML nommé d'après le
        nom de l'opération SOAP.

`@WebMethod <https://docs.oracle.com/javase/8/docs/api/javax/jws/WebMethod.html>`__
    Indique si la méthode correspond à une opération du service Web

`@WebParam <https://docs.oracle.com/javase/8/docs/api/javax/jws/WebParam.html>`__
    Cette annotation permet d'associer le paramètre de la méthode sur
    laquelle elle porte à une partie d'un message (l'élément ``part`` de
    ``message`` dans le WSDL). Elle possède les attributs suivants :

    name
        le nom de l'élément XML
    targetNamespace
        l'espace de nom de l'élément XML
    header
        un booléen indiquant si l'élément XML correspond à un en-tête ou
        s'il s'agit du corps du message.
    mode
        Il s'agit d'une énumération pouvant prendre les valeurs IN, OUT
        ou INOUT. Pour les valeurs OUT et INOUT, le type du paramètre
        est obligatoirement de type
        `javax.xml.ws.Holder<T> <https://docs.oracle.com/javase/8/docs/api/javax/xml/ws/Holder.html>`__.
        IN signifie que l'élément est extrait du message de l'expéditeur
        tandis que OUT indique que l'élément fait partie de la réponse.

    ::

        public String sayHello(
             @WebParam String name,
             @WebParam(header=true) UserCredentials userCredentials,
             @WebParam(header=true, mode=Mode.OUT) Holder<ServerInfo> serverInfo);

`@WebResult <https://docs.oracle.com/javase/8/docs/api/javax/jws/WebResult.html>`__
    Cette annotation a la même sémantique que l'annotation ``@WebParam``
    sauf qu'elle est ajoutée à la méthode et qu'elle porte sur la valeur
    de retour de la méthode. Elle possède les attributs suivants :

    name
        le nom de l'élément XML
    targetNamespace
        l'espace de nom de l'élément XML
    header
        un booléan indiquant si l'élément XML correspond à un en-tête ou
        s'il s'agit du corps du message.

Avec JAX-WS, les exceptions lancées par une méthode d'une SEI sont
automatiquement transformées en SOAP fault.

Déployer un service Web dans un serveur d'application Java EE
*************************************************************

Pour déployer un service Web développé avec JAX-WS, soit vous disposez
d'un serveur d'application Java EE (comme Wildfly, Glassfish ou TomEE), soit vous
ne disposez que d'un conteneur de Servlet (comme Tomcat ou Jetty).

Pour un déploiement dans un serveur d'application Java EE, il suffit
d'embarquer votre implémentation dans une application Web Java et de
déployer cette application. Le serveur d'application s'occupe du
reste...

Pour un déploiement dans un conteneur de Servlet, il faut incorporer une
implémentation de JAX-WS dans votre application Web et se conformer à sa
documentation car JAX-WS ne définit pas de standard de configuration et
de déploiement.

Il existe plusieurs implémentations de JAX-WS :
`Metro <https://metro.java.net/>`__,
`CXF <https://cxf.apache.org/>`__... Pour un déploiement en utilisant
l'implémentation Metro sous Tomcat, vous pouvez suivre `ce
tutoriel <http://www.mkyong.com/webservices/jax-ws/deploy-jax-ws-web-services-on-tomcat/>`__.

Excercice
*********

.. admonition:: Écrire un service Web
   :class: hint

    Reprenez l'implémentation de la SEI donnée en exemple :ref:`plus haut <jaws_sei>` 
    et créez une application Web Java EE incorporant ce
    service. Déployez ensuite cette application dans un serveur
    d'application . Vérifiez
    que le service fonctionne en utilisant par exemple
    `SoapUI <https://sourceforge.net/projects/soapui/>`__.

    Vous pouvez ensuite écrire un programme Java client de votre service.

Pour aller plus loin
********************

SOAP
    https://www.w3schools.com/xml/xml_soap.asp
WSDL
    https://www.w3schools.com/xml/xml_wsdl.asp
Tutoriels JAX-WS
    http://www.mkyong.com/tutorials/jax-ws-tutorials/

.. _SOAP: http://www.w3.org/TR/soap/

