Le contexte d'application
#########################

Nous avons vu au :ref:`chapitre précédent <spring_ioc>` que le Spring framework
fournit un conteneur IoC. Ce conteneur permet de définir ce que l'on appelle
un contexte d'application (ApplicationContext_). Un contexte d'application contient
la définition des objets que le conteneur doit créer ainsi que leurs
interdépendances.

ApplicationContext_ est une interface dans le Spring Framework car il existe
plusieurs implémentations et donc plusieurs façons de définir un contexte d'application.
Pour la plus grande partie de ce chapitre, nous nous limiterons à utiliser la classe
concrète GenericXmlApplicationContext_ qui permet de créer un contexte d'application à
partir d'un fichier XML. Nous verrons en fin de chapitre qu'un contexte d'application
peut être créé intégralement en Java.

.. note::

  Pour compiler et exécuter les exemples de ce chapitre, vous allez avoir besoin
  d'un projet Java contenant certaines dépendances au Spring Framework. Le plus
  simple est d'utiliser un projet Maven et d'ajouter la dépendance suivante
  dans le fichier :file:`pom.xml` :

  .. code-block:: xml

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

Définition d'un contexte d'application en XML
*********************************************

Le Spring Framework définit un format XML qui permet de déclarer un ensemble
de *beans*, c'est-à-dire un ensemble d'objets à créer pour l'application :

.. code-block:: xml
  :caption: Contenu minimal d'un fichier XML de contexte d'application

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

  </beans>

Nous pouvons ensuite créer la classe principale de notre application qui va
charger le fichier XML de contexte grâce à la classe GenericXmlApplicationContext_ :

.. code-block:: java
  :caption: La classe principale de l'application

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) {
      GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");
      appCtx.close();
    }

  }

Notez que le constructeur de la classe ``GenericXmlApplicationContext`` attend
en paramètre la localisation du fichier XML. Dans notre exemple, la chaîne
de caractères :code:`"file:application-context.xml"` indique que le fichier
se trouve sur le système de fichiers dans le répertoire de travail et qu'il s'appelle
``application-context.xml``.

.. note::

  Le préfixe *Generic* dans ``GenericXmlApplicationContext`` est là pour indiquer
  que cette classe peut charger un fichier XML à partir de n'importe quel type
  de ressource supporté par le Spring Framework. Dans l'emplacement, le préfixe
  ``file:`` indique que le fichier se trouve sur le système de fichier. On peut également
  utiliser le préfixe ``classpath:`` pour indiquer que le fichier se trouve dans le *classpath*.
  Le fichier peut même se trouver sur le réseau en utilisant le préfixe ``http:``.
  
  .. hint::
  
    Pour un fichier dans le *classpath*, pour un projet Maven, vous 
    devez placer ce fichier dans le dossier :file:`src/main/resources` de votre projet. 
  

  Avant sa version 3, le Spring Framework ne fournissait pas la classe
  GenericXmlApplicationContext_. Il était néanmoins possible d'utiliser les classes
  FileSystemXmlApplicationContext_ et ClassPathXmlApplicationContext_ qui permettent
  de charger un fichier XML de contexte respectivement depuis le système de fichiers
  et depuis le *classpath*.

Un objet de type GenericXmlApplicationContext_ doit être fermé lorsqu'il n'est
plus nécessaire en appelant sa méthode ``close``. Notez que cette classe
implémente également l'interface AutoCloseable_, ce qui permet de déclarer
une instance de GenericXmlApplicationContext_ avec la syntaxe *try-with-resources*.

.. code-block:: java
  :caption: Utilisation de la syntaxe try-with-resources

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        // ...
      }
    }

  }

Définition de beans dans le contexte
************************************

Un contexte d'application décrit l'ensemble des objets (les *beans*) à créer
pour l'application.

Nous pouvons, par exemple, définir un objet de type Date_ de la façon suivante :

.. code-block:: xml
  :caption: Définition d'un bean de type Date

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="now" class="java.util.Date">
    </bean>

  </beans>

On utilise l'élément ``<bean />`` pour déclarer un objet en donnant son nom avec
l'attribut ``name`` (optionnel) et le nom complet de la classe dans l'attribut
``class``. Le conteneur IoC utilise ces informations pour créer une instance de Date_
en appelant son constructeur sans paramètre.

Nous pouvons ensuite récupérer le *bean* grâce aux méthodes ``getBean`` fournies
par l'objet ApplicationContext_ :

.. code-block:: java
  :caption: La classe principale de l'application

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.Date;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        // récupération de l'objet défini dans le contexte d'application
        Date now = appCtx.getBean("now", Date.class);

        System.out.println(now);
      }
    }
  }

.. note::

  Il est possible d'utiliser la méthode ``getBean`` qui prend uniquement comme paramètre le type
  de l'objet. Par exemple :

  ::

    Date now = appCtx.getBean(Date.class);

  Attention cependant, il ne doit pas exister dans le contexte d'application
  plusieurs *beans* ayant le même type ou sinon l'appel à cette méthode échoue
  avec un exception du type NoUniqueBeanDefinitionException_.

Notion de portée (scope)
************************

Les *beans* déclarés dans un contexte d'application ont une portée (*scope*).
Par défaut, Spring définit deux portées :

*singleton*
  Cette portée évoque le modèle de conception singleton_. Cela signifie qu'une seule
  instance de ce *bean* existe dans le conteneur IoC. Autrement dit, si un programme
  appelle une méthode ``getBean`` pour récupérer ce *bean*, chaque appel retourne
  le **même** objet.

*prototype*
  Cette portée est l'inverse de la portée singleton. À chaque fois qu'un programme
  appelle une méthode ``getBean`` pour récupérer ce *bean*, chaque appel retourne
  une **nouvelle instance** du *bean*.

Le type de la portée peut être indiquée grâce à l'attribut ``scope`` dans le fichier
XML de contexte. La portée par défaut dans le Spring Framework est **singleton**.

Pour illustrer le comportement des portées, nous pouvons rependre l'exemple des
*beans* de type Date_ :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="unique" class="java.util.Date" scope="singleton">
    </bean>

    <bean name="now" class="java.util.Date" scope="prototype">
    </bean>

  </beans>

Le contexte d'application contient deux *beans* de type Date_ : "unique" qui est
un singleton et "now" qui est de portée prototype.

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception{
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        for (int i = 0; i < 10; ++i) {
          // On attent 1s
          Thread.sleep(1000);
          System.out.println("Date unique " + appCtx.getBean("unique"));
          System.out.println("Maintenant " + appCtx.getBean("now"));
        }
      }
    }
  }

Le code ci-dessus effectue 10 itérations en attendant à chaque fois une seconde.
En exécutant ce code, vous constaterez que le *bean* "unique" a toujours la même valeur
car il s'agit toujours du même objet. Par contre, chaque appel à ``appCtx.getBean("now")``
crée un nouvel objet. En conséquence, la valeur de la date évolue dans le temps.

.. note::

  Il existe d'autres portées définies par le Spring Framework : *request*,
  *session*, *application* mais qui n'ont de sens que lorsque l'application s'exécute
  dans un contexte particulier (quand il s'agit d'une application Web notamment).

Les différentes façons de créer des objets
******************************************

Un des points forts du Spring Framework est qu'il est non intrusif. C'est-à-dire
que son fonctionnement interne n'a pas d'impact sur la façon dont vous allez
concevoir vos classes. Ainsi, le Spring Framework est capable de construire
tout type d'objet. Si vous n'utilisez pas de conteneur IoC pour construire vos
objets, vous remarquerez qu'il existe trois façons différentes de construire un objet 
en Java :

1) En utilisant le mot-clé ``new`` pour appeler le constructeur (avec ou sans paramètre) :

   ::

    Date date = new Date();

2) En utilisant une méthode statique. C'est notamment le cas pour
   créer une instance de la classe Calendar_ :

   ::

    Calendar calendar = Calendar.getInstance();

3) En utilisant un autre objet qui sert à fabriquer l'objet final. En Java, on suffixe
   souvent le nom de ces objets par ``Factory`` pour indiquer qu'ils agissent
   comme une fabrique. L'API standard de Java fournit par exemple la classe CertificateFactory_
   qui permet de créer des objets représentant des certificats pour la cryptographie :

   ::

    FileInputStream fis = new FileInputStream(filename);
    CertificateFactory cf = CertificateFactory.getInstance("X.509");
    Certificate c = cf.generateCertificate(fis);

   Dans l'exemple ci-dessus, l'appel à la méthode ``generateCertificate`` permet
   de créer un objet de type ``Certificate``.

Le Spring framework permet de créer des *beans* en utilisant n'importe laquelle
des méthodes ci-dessus. Prenons l'exemple de la classe ``Personne`` :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class Personne {

    private String nom;
    private String prenom;

    public Personne() {
    }

    public Personne(String prenom, String nom) {
      this.prenom = prenom;
      this.nom = nom;
    }

    public String getNom() {
      return nom;
    }

    public void setNom(String nom) {
      this.nom = nom;
    }

    public String getPrenom() {
      return prenom;
    }

    public void setPrenom(String prenom) {
      this.prenom = prenom;
    }

    @Override
    public String toString() {
      return prenom + " " + nom;
    }
  }

Pour l'exemple, nous créons également la classe ``PersonneFactory`` :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class PersonneFactory {

    public static Personne getAnonyme() {
      return new Personne();
    }

    public Personne getQuelquun() {
      return new Personne("John", "Doe");
    }
  }

Ci-dessous, un contexte d'application en XML qui crée quatre *beans* de type ``Personne`` :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <!-- Création à partir d'un constructeur sans paramètre -->
    <bean name="anonyme" class="{{ROOT_PKG}}.Personne">
    </bean>

    <!-- Création à partir d'un constructeur avec des paramètres -->
    <bean name="moi" class="{{ROOT_PKG}}.Personne">
      <constructor-arg>
        <value>David</value>
      </constructor-arg>
      <constructor-arg>
        <value>Gayerie</value>
      </constructor-arg>
    </bean>

    <!-- Création à partir d'une méthode statique d'une fabrique -->
    <bean name="autreAnonyme" class="{{ROOT_PKG}}.PersonneFactory"
          factory-method="getAnonyme">
    </bean>

    <!-- Création d'une fabrique -->
    <bean name="personneFactory" class="{{ROOT_PKG}}.PersonneFactory">
    </bean>

    <!-- Création à partir d'une méthode non statique d'une fabrique créée dans le conteneur -->
    <bean name="autrePersonne" factory-bean="personneFactory" factory-method="getQuelquun">
      <constructor-arg>
        <value>John</value>
      </constructor-arg>
      <constructor-arg>
        <value>Doe</value>
      </constructor-arg>
    </bean>
  </beans>

Et le code de test de l'application :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        System.out.println(appCtx.getBean("anonyme"));
        System.out.println(appCtx.getBean("moi"));
        System.out.println(appCtx.getBean("autreAnonyme"));
        System.out.println(appCtx.getBean("autrePersonne"));
      }
    }
  }

Injection de types simples
**************************

Dans la section précédente, nous avons créé certains *beans* de type ``Personne``
en spécifiant au conteneur IoC la valeur des paramètres du constructeur grâce à
l'élément ``<value />``. Le Spring Framework est capable de convertir automatiquement
une valeur en type primitif ou en chaîne de caractères. Il est également possible
de définir des listes dans le contexte d'application.

Prenons l'exemple de la classe ``Calculateur`` qui accepte en paramètre un tableau
d'entiers :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.stream.IntStream;

  public class Calculateur {

    private int[] nombres;

    public Calculateur(int... nombres) {
      this.nombres = nombres;
    }

    public int getTotal() {
      return IntStream.of(nombres).sum();
    }

  }

Il est possible déclarer un *bean* de type ``Calculateur`` en passant les valeurs
voulues sous la forme d'une liste :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="calculateur" class="{{ROOT_PKG}}.Calculateur">
      <constructor-arg>
        <list>
          <value>1</value>
          <value>2</value>
          <value>3</value>
        </list>
      </constructor-arg>
    </bean>

  </beans>

Et le code de l'application :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        Calculateur calculateur = appCtx.getBean("calculateur", Calculateur.class);
        System.out.println(calculateur.getTotal());
      }
    }
  }

L'exécution de ce programme affiche le résultat 6 sur la sortie standard.

.. note::

  Il existe également l'élément ``<map />`` pour définir des tableaux associatifs
  (Map_) dans le contexte d'application.

  .. code-block:: xml

    <map>
      <entry>
        <key></key>
        <value></value>
      </entry>
      <entry>
        <key></key>
        <value></value>
      </entry>
    </map>

Injection de beans
******************

Le rôle du conteneur IoC est, non seulement de créer des *beans* mais également
de les lier entre eux par injection de dépendance. Le Spring Framework supporte
l'injection par constructeur et l'injection par *setter*.

Reprenons l'exemple de la classe ``Personne`` et ajoutons dans notre modèle de
données la classe ``Societe`` :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.List;

  public class Societe {

    private String nom;
    private List<Personne> salaries;
    private Personne dirigeant;

    public String getNom() {
      return nom;
    }

    public void setNom(String nom) {
      this.nom = nom;
    }

    public List<Personne> getSalaries() {
      return salaries;
    }

    public void setSalaries(List<Personne> salaries) {
      this.salaries = salaries;
    }

    public Personne getDirigeant() {
      return dirigeant;
    }

    public void setDirigeant(Personne dirigeant) {
      this.dirigeant = dirigeant;
    }

  }

Il est possible de déclarer un *bean* de type ``Societe`` est d'injecter des *beans*
de type ``Personne`` :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="dirigeant" class="{{ROOT_PKG}}.Personne">
      <constructor-arg>
        <value>Jean</value>
      </constructor-arg>
      <constructor-arg>
        <value>Don</value>
      </constructor-arg>
    </bean>

    <bean name="societe" class="{{ROOT_PKG}}.Societe">
      <property name="nom">
        <value>Societe SA</value>
      </property>
      <property name="dirigeant">
        <ref bean="dirigeant"/>
      </property>
      <property name="salaries">
        <list>
          <ref bean="dirigeant"/>
          <bean class="{{ROOT_PKG}}.Personne">
            <constructor-arg>
              <value>Michel</value>
            </constructor-arg>
            <constructor-arg>
              <value>Don</value>
            </constructor-arg>
          </bean>
        </list>
      </property>
    </bean>
  </beans>

L'élément ``<property />`` permet de réaliser une injection en appelant la méthode
*setter* correspondante au nom de la propriété. Notez que le Spring Framework est
très permissif : il est possible d'utiliser l'élément ``<ref />`` et de donner le nom
du *bean* que l'on souhaite injecter ou bien d'utiliser directement une balise
``<bean>`` pour déclarer un nouveau *bean* anonyme (sans attribut ``name``).

.. note::

  ``value`` et ``ref`` sont aussi supportés comme attributs des éléments ``<constructor-arg />``
  et ``<property />``. Cela permet une écriture plus compacte et moins verbeuse :

  .. code-block:: xml

    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
                               http://www.springframework.org/schema/beans/spring-beans.xsd">

      <bean name="dirigeant" class="{{ROOT_PKG}}.Personne">
        <constructor-arg value="Jean"/>
        <constructor-arg value="Don"/>
      </bean>

      <bean name="societe" class="{{ROOT_PKG}}.Societe">
        <property name="nom" value="Societe SA"/>
        <property name="dirigeant" ref="dirigeant" />
        <property name="salaries">
          <list>
            <ref bean="dirigeant"/>
            <bean class="{{ROOT_PKG}}.Personne">
              <constructor-arg value="Michel"/>
              <constructor-arg value="Don"/>
            </bean>
          </list>
        </property>
      </bean>
    </beans>

Et le code de l'application :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        Societe societe = appCtx.getBean("societe", Societe.class);
        System.out.println(societe.getNom());
        System.out.println("Le dirigeant est " + societe.getDirigeant());
        System.out.println("Les salariés sont " + societe.getSalaries());
      }
    }
  }

.. note::

  Même s'il est possible de créer des objets représentant des données comme
  dans l'exemple ci-dessus, nous verrons que cela n'est pas l'usage courant
  du conteneur IoC. On utilise plutôt le conteneur pour créer des objets qui
  constituent l'architecture d'une application. On dit parfois que le Spring
  Framework est utilisé pour construire des architectures légères
  (*lightweight architectures*).

Gestion du cycle de vie des beans
*********************************

Parfois, certains objets nécessitent d'appeler une méthode pour finaliser leur
initialisation et/ou d'appeler une méthode lorsque l'objet n'est plus utilisé
(généralement pour libérer des ressources système). Il est possible d'indiquer
lors de la déclaration du *bean* une méthode à appeler juste après que toutes les
injections de dépendance ont été réalisées ainsi que la méthode à appeler au moment
de la fermeture du contexte d'application. Pour cela, on utilise respectivement
l'attribut ``init-method`` et l'attribut ``destroy-method``.

.. note ::

  Les méthodes d'initialisation et de suppression ne doivent pas avoir de
  paramètre.

Si nous disposons de la classe ci-dessous :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class ExempleBeanRessource {

    public void init() {
      System.out.println("Quelque chose est fait à l'initialisation");
    }

    public void close() {
      System.out.println("Quelque chose est fait à la fermeture");
    }
  }

Alors nous pouvons créer une instance de cette classe dans le conteneur IoC
en précisant que les méthodes ``init`` et ``close`` doivent respectivement
être appelées à l'initialisation et à la destruction du *bean*.

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="{{ROOT_PKG}}.ExempleBeanRessource"
          init-method="init" destroy-method="close"/>

  </beans>

.. note::

  Notez qu'un *bean* n'a pas nécessairement besoin d'un nom pour être créé et géré par
  le conteneur IoC.

.. _spring_autowiring:

Autowiring
**********

Le Spring Framework est capable d'injecter des dépendances automatiquement
dans un *bean* en utilisant différentes stratégies. Cette fonctionnalité est
appelée **autowiring**. Elle permet d'alléger le contenu du fichier XML du contexte
d'application en fournissant une configuration automatique.

L'autowiring est activable grâce à l'attribut ``autowire`` de l'élément ``<bean />``.
Cet attribut peut prendre les valeurs suivantes :

*no*
  La valeur par défaut. Indique que le mode autowiring est désactivé.

*byName*
  L'autowiring est activé sur les propriétés. Le Spring Framework recherche
  les methodes *setter* et utilise le nom de la propriété pour en déduire
  le *bean* à injecter. Par exemple, si un *bean* possède la méthode :

  ::

    public void setAmi(Individu i) {
      // ...
    }

  Le Spring Framework recherche et injecte un *bean* du nom de "ami" qui doit être
  du type ``Individu``.

.. _spring_autowiring_bytype:

*byType*
  L'autowiring est activé sur les propriétés. Le Spring Framework recherche
  les methodes *setter* et utilise le type de la propriété pour en déduire
  le *bean* à injecter. Par exemple, si un *bean* possède la méthode :

  ::

    public void setAmi(Individu i) {
      // ...
    }

  Le Spring Framework recherche et injecte un *bean* dont le type est ``Individu``.
  Attention, s'il existe dans le contexte d'application plusieurs *beans* de type
  ``Individu``, alors l'initialisation du contexte d'application échoue.

*constructor*
  L'autowiring est activé sur les paramètres du constructeur. Le Spring Framework
  recherche pour chaque paramètre un *bean* du même type. Attention s'il existe
  dans le contexte d'application plusieurs *beans* du même type, alors l'initialisation
  du contexte d'application échoue.

Si nous reprenons l'exemple de la classe ``Societe`` :

::

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import java.util.List;

  public class Societe {

    private String nom;
    private List<Personne> salaries;
    private Personne dirigeant;

    public String getNom() {
      return nom;
    }

    public void setNom(String nom) {
      this.nom = nom;
    }

    public List<Personne> getSalaries() {
      return salaries;
    }

    public void setSalaries(List<Personne> salaries) {
      this.salaries = salaries;
    }

    public Personne getDirigeant() {
      return dirigeant;
    }

    public void setDirigeant(Personne dirigeant) {
      this.dirigeant = dirigeant;
    }

  }

En déclarant le contexte d'application de la façon suivante :

.. code-block:: xml
  :linenos:

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd" >

    <bean name="dirigeant" class="{{ROOT_PKG}}.Personne">
      <constructor-arg value="Jean"/>
      <constructor-arg value="Don"/>
    </bean>

    <bean name="societe" class="{{ROOT_PKG}}.Societe" autowire="byName">
      <property name="nom" value="Ma société"/>
    </bean>
  </beans>

À la ligne 12, on déclare le *société* avec un mode autowire à la valeur ``byName``.
Ainsi, le Spring Framework injectera le *bean* nommé "dirigeant" dans la propriété
``dirigeant``.

En déclarant maintenant le contexte d'application comme suit :

.. code-block:: xml
  :linenos:

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd" >

    <bean name="dirigeant" class="{{ROOT_PKG}}.Personne">
      <constructor-arg value="Jean"/>
      <constructor-arg value="Don"/>
    </bean>

    <bean name="societe" class="{{ROOT_PKG}}.Societe" autowire="byType">
      <property name="nom" value="Ma société"/>
    </bean>
  </beans>

À la ligne 12, on déclare le *société* avec un mode autowire à la valeur ``byType``.
Ainsi, le Spring Framework injectera le *bean* nommé "dirigeant" dans la propriété
``dirigeant`` car il est le seul *bean* de type ``Personne`` dans le contexte. Mais il injectera
également le même *bean* dans la liste des salariés car ``salaries`` est une propriété
de type ``List<Personne>``. Le Spring Framework va fabriquer cette liste à partir
de l'ensemble des beans de type ``Personne`` (dans notre exemple, il n'y en a
qu'un déclaré dans le contexte).

Contexte d'application en Java
******************************

Jusqu'à présent, nous avons systématiquement déclaré le contexte d'application
dans un fichier XML mais le Spring Framework supporte la création d'un contexte
d'application intégralement en Java. Pour cela, on utilise les annotations
`@Configuration`_ et `@Bean`_ ainsi que la classe AnnotationConfigApplicationContext_ :

.. code-block:: java
  :caption: Exemple de contexte d'application en Java

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.context.annotation.AnnotationConfigApplicationContext;
  import org.springframework.context.annotation.Bean;
  import org.springframework.context.annotation.Configuration;

  @Configuration
  public class AppConfig {

    @Bean
    public Calculateur monCalculateur() {
      return new Calculateur(1, 2, 3);
    }

    public static void main(String[] args) {
      try(AnnotationConfigApplicationContext appCtx = new AnnotationConfigApplicationContext(AppConfig.class)) {
        Calculateur calculateur = appCtx.getBean("monCalculateur", Calculateur.class);
        System.out.println(calculateur.getTotal());
      }
    }
  }

L'annotation `@Configuration`_ permet de préciser que cette classe sert à configurer
un contexte d'application. Les méthodes annotées par `@Bean`_ retourne un *bean*
dont le nom correspond au nom de la méthode elle-même.

.. note::

  Pour plus d'information, reportez-vous à la `documentation officielle <https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-java>`_.

.. _ApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/ApplicationContext.html
.. _GenericXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/GenericXmlApplicationContext.html
.. _FileSystemXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/FileSystemXmlApplicationContext.html
.. _ClassPathXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/ClassPathXmlApplicationContext.html
.. _AutoCloseable: https://docs.oracle.com/javase/8/docs/api/java/lang/AutoCloseable.html
.. _Date: https://docs.oracle.com/javase/8/docs/api/java/util/Date.html
.. _Calendar: https://docs.oracle.com/javase/8/docs/api/java/util/Calendar.html
.. _Map: https://docs.oracle.com/javase/8/docs/api/java/util/Map.html
.. _NoUniqueBeanDefinitionException: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/NoUniqueBeanDefinitionException.html
.. _singleton: https://fr.wikipedia.org/wiki/Singleton_(patron_de_conception)
.. _CertificateFactory: https://docs.oracle.com/javase/8/docs/api/java/security/cert/CertificateFactory.html
.. _@Configuration: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/Configuration.html
.. _@Bean: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/Bean.html
.. _AnnotationConfigApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/annotation/AnnotationConfigApplicationContext.html

