Le contexte d'application
#########################

Nous avons vu au :ref:`chapitre précédent <spring_ioc>` que le Spring framework
fournit un conteneur IoC. Ce conteneur permet de définir ce que l'on appelle
un contexte d'application (ApplicationContext_). Un contexte d'application contient
la définition des objets que le conteneur doit créer ainsi que leurs 
interdépendances.

ApplicationContext_ est une interface dans le Spring Framework car il existe
plusieurs implémentations et donc plusieurs façons définir un contexte d'application.
Pour la plus grande partie de ce chapitre, nous nous limiterons à utiliser la classe
concrète GenericXmlApplicationContext_ qui permet de créer un contexte d'application à
partir d'un fichier XML. Nous verrons en fin de chapitre qu'un contexte d'application
peut être créé intégralement en Java.

Définition d'un contexte d'application en XML
*********************************************

Le Spring Framework définit un format XML qui permet de définir un ensemble
de *beans*, c'est-à-dire un ensemble d'objets à créer pour l'application :

.. code-block:: xml
  :caption: Contenu minimal d'un fichier XML de application-context.xml

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

  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) {
      ApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");
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
  Pour un projet Maven, vous devez placer votre fichier dans le dossier
  :file:`src/main/resources` de votre projet. Le fichier peut même se trouver
  sur le réseau en utilisant le préfixe ``http:``.
  
  Avant sa version 3, le Spring Framework ne fournissait pas la classe 
  GenericXmlApplicationContext_. Il était néanmoins possible d'utiliser les classes
  FileSystemXmlApplicationContext_ et ClassPathXmlApplicationContext_ qui permettent
  de charger un fichier XML de contexte respectivement depuis le système de fichiers
  et depuis le *classpath*. 
  
Définition de beans dans le contexte
************************************

Un contexte d'application décrit l'ensemble des objets (les *beans*) à créer
pour l'application.

Nous pouvons par exemple définir un objet de type Date_ de la façon suivante :

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

On utilise la balise ``<bean>`` pour déclarer un objet en donnant son nom avec
l'attribut ``name`` (optionnel) et le nom complet de la classe dans l'attribut
``class``. Le conteneur IoC utilise ces informations pour créer une instance de Date_
en appelant son constructeur sans paramètre.

Nous pouvons ensuite récupérer le *bean* grâce aux méthodes ``getBean`` fournies
par l'objet ApplicationContext_ :

.. code-block:: java
  :caption: La classe principale de l'application

  package ROOT_PKG;

  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) {
      ApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");

      // récupération de l'objet défini dans le contexte d'application
      Date now = (Date) appCtx.getBean("now");
      
      System.out.println(now);

    }
  }

.. note::

  Il est possible d'utiliser la méthode ``getBean`` qui prend comme paramètre le type
  de l'objet. Par exemple :
  
  ::

    Date now = (Date) appCtx.getBean(Date.class);

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
  une instance **différente** du *bean*.

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

  package ROOT_PKG;

  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception{
      ApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");

      for (int i = 0; i < 10; ++i) {
        // On attent 1s
        Thread.sleep(1000);
        System.out.println("Date unique " + appCtx.getBean("unique"));
        System.out.println("Maintenant " + appCtx.getBean("now"));
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
objets, vous remarquerez qu'il existe trois façons différentes de construire un objet :

1) En utilisant le mot-clé ``new`` pour appeler le constructeur (avec ou sans paramètre) :

   ::
    
    Date date = new Date();

2) En utilisant une méthode statique de la classe. C'est notamment le cas pour
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

Le Spring framework permet de créer des *beans* en utilisant n'importe quelle
méthodes ci-dessus. Prenons l'exemple de la classe ``Personne`` :

::

  package ROOT_PKG;

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

  package ROOT_PKG;

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
    <bean name="anonyme" class="ROOT_PKG.Personne">
    </bean>

    <!-- Création à partir d'un constructeur avec des paramètres -->
    <bean name="moi" class="ROOT_PKG.Personne">
      <constructor-arg>
        <value>David</value>
      </constructor-arg>
      <constructor-arg>
        <value>Gayerie</value>
      </constructor-arg>
    </bean>

    <!-- Création à partir d'une méthode statique d'une fabrique -->
    <bean name="autreAnonyme" class="ROOT_PKG.PersonneFactory" 
          factory-method="getAnonyme">
    </bean>

    <!-- Création d'une fabrique -->
    <bean name="personneFactory" class="ROOT_PKG.PersonneFactory">
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

  package ROOT_PKG;

  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      ApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");

      System.out.println(appCtx.getBean("anonyme"));
      System.out.println(appCtx.getBean("moi"));
      System.out.println(appCtx.getBean("autreAnonyme"));
      System.out.println(appCtx.getBean("autrePersonne"));
    }

  }

Injection de types simples
**************************

Dans la section précédente, nous avons créé certains *beans* de type ``Personne``
en spécifiant au conteneur IoC la valeur des paramètres du constructeur grâce à
la balise ``<value>``. Le Spring Framework est capable de convertir automatiquement
une valeur en type primitif ou en chaîne de caractères. Il est également possible
de définir des listes dans le contexte d'application.

Prenons l'exemple de la classe ``Calculateur`` qui accepte en paramètre un tableau
d'entier :

::

  package ROOT_PKG;

  import java.util.stream.IntStream;

  public class Calculateur {
    
    private int[] nombres;
    
    public Calculateur(int[] nombres) {
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
    
    <bean name="calculateur" class="ROOT_PKG.Calculateur">
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

  package ROOT_PKG;

  import org.springframework.context.ApplicationContext;
  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      ApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml");

      Calculateur calculateur = (Calculateur) appCtx.getBean("calculateur");
      System.out.println(calculateur.getTotal());
    }
  }

L'exécution ce programme affiche le résultat 6 sur la sortie standard.

.. note::

  Il existe également la balise ``<map>`` pour définir des tableaux associatifs
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
  
   

.. _ApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/ApplicationContext.html
.. _GenericXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/GenericXmlApplicationContext.html
.. _FileSystemXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/FileSystemXmlApplicationContext.html
.. _ClassPathXmlApplicationContext: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/context/support/ClassPathXmlApplicationContext.html
