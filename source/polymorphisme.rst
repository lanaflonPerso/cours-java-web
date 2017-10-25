Le polymorphisme
################

Le polymorphisme est un mécanisme important dans l'héritage dans la programmation
objet. Il permet de modifier le comportement d'une classe fille par rapport
à sa classe mère. Le polymorphisme permet d'utiliser l'héritage comme un mécanisme
d'extension en adaptant le comportement des objets.

Principe du polymorphisme
*************************

Prenons l'exemple de la classe *Animal*. Cette classe offre une méthode
*crier*. Pour simplifier notre exemple, la méthode se contente d'écrire
le cri de l'animal sur la sortie standard.

::

  package ROOT_PKG.animal;

  public class Animal {
    
    public void crier() {
      System.out.println("un cri d'animal");
    }

  }

Nous disposons également des classes *Chat* et *Chien* qui héritent de la classe
*Animal*.

::

  package ROOT_PKG.animal;

  public class Chat extends Animal {

  }

::

  package ROOT_PKG.animal;

  public class Chien extends Animal {

  }


Ces deux classes peuvent être considérées comme un spécialisation de la classe
*Animal*. À ce titre, elles peuvent **surcharger** (*override*) la méthode *crier*.

::

  package ROOT_PKG.animal;

  public class Chat extends Animal {
    
    public void crier() {
      System.out.println("Miaou !");
    }

  }

::

  package ROOT_PKG.animal;

  public class Chien extends Animal {
    
    public void crier() {
      System.out.println("Whouaf whouaf !");
    }

  }


Chaque classe fille change le comportement de la méthode *crier*. L'intérêt du 
polymorphisme vient du fait que maintenant, les instances des classes filles
appelleront toujours la méthode *crier* surchargée par leur classe.

::

  Animal animal = new Animal();
  animal.crier(); // affiche "un cri d'animal"

  Chat chat = new Chat();
  chat.crier();   // affiche "Miaou !"

  Chien chien = new Chien();
  chien.crier();  // affiche "Whouaf whouaf !"
  
  animal = chat;
  animal.crier(); // affiche "Miaou !"
  
  animal = chien;
  animal.crier(); // affiche "Whouaf whouaf !"


L'exemple de code ci-dessus montre bien que le type de le comportement de la
méthode *crier* varie selon le type réel de l'objet que l'on utilise.

Une exception : les méthodes privées
************************************

Les méthodes de portée **private** ne supportent pas le polymorphisme. En effet,
une méthode de portée **private** n'est accessible uniquement que par la classe
qui la déclare. Donc si une classe mère et une classe fille définissent une méthode
**private** avec la même signature, il s'agit simplement pour le compilateur de 
deux méthodes différentes.

.. _surcharge_et_signature:

Surcharge et signature de méthode
*********************************

Le principe du polymorphisme repose en Java sur la surcharge de méthodes. Pour
que la surcharge fonctionne, il faut que la méthode qui surcharge possède
une signature *correspondante* à celle de la méthode surchargée.

Le cas le plus simple est celui de l'exemple précédent. Les méthodes ont
exactement la même signature : même portée, même type de retour, même nom
et mêmes paramètres.

Cependant, la méthode qui surcharge peut avoir une signature légèrement différente.

Une méthode qui surcharge peut avoir une portée différente si et seulement
si celle-ci est plus permissive que celle de la méthode surchargée. Il est donc
possible d'augmenter la portée de la méthode mais jamais de la réduire :

* Une méthode de portée package peut être surchargée avec la portée package
  mais aussi **protected** ou **public**.
* Une méthode de portée **protected** peut être surchargée avec la portée
  **protected** ou **public**.
* Une méthode de portée **public** ne peut être surchargée qu'avec la portée
  **public**

Le changement de portée dans la surcharge sert la plupart du temps à placer
une implémentation dans la classe parente mais à laisser les classes filles
qui le désirent offrir publiquement l'accès à cette méthode.

Au :ref:`chapitre précédent <portee_protected>`, nous avions introduit les 
classes *Vehicule*, *Voiture* et *Moto*. En partant du principe que seules les 
instances de *Voiture* pouvent offrir la méthode *reculer*, nous avons ajouté 
cette méthode dans la classe *Voiture*. Pour cela, nous avions dû modifier
l'implémentation de la classe *Vehicule* en utilisant une portée **protected**
pour l'attribut *vitesse*. Nous avions alors vu que cela n'était pas totalement
conforme au `principe du ouvert/fermé`_.

::

  package ROOT_PKG.conduite;
  
  public class Vehicule {

    private final String marque;
    protected float vitesse;
    
    public Vehicule(String marque) {
      this.marque = marque;
    }
    
    public void accelerer(float deltaVitesse) {
      this.vitesse += deltaVitesse;
    }

    public void decelerer(float deltaVitesse) {
      this.vitesse = Math.max(this.vitesse - deltaVitesse, 0f);
    }

    // ...
    
  }

::

  package ROOT_PKG.conduite;
  
  public class Voiture extends Vehicule {
  
    public Voiture(String marque) {
      super(marque);
    }
    
    public void reculer(float vitesse) {
      this.vitesse = -vitesse;
    }

    // ...
    
  }


Nous pouvons maintenant revoir notre implémentation. En fait, c'est la méthode
*reculer* qui doit être déclarée dans la classe *Véhicule* avec une portée
**protected**. La classe *Voiture* peut se limiter à surcharger cette méthode
en la rendant **public**.

::

  package ROOT_PKG.conduite;
  
  public class Vehicule {

    private final String marque;
    private float vitesse;
    
    public Vehicule(String marque) {
      this.marque = marque;
    }
    
    public void accelerer(float deltaVitesse) {
      this.vitesse += deltaVitesse;
    }

    public void decelerer(float deltaVitesse) {
      this.vitesse = Math.max(this.vitesse - deltaVitesse, 0f);
    }

    protected void reculer(float vitesse) {
      this.vitesse = -vitesse;
    }

    // ...
    
  }

::

  package ROOT_PKG.conduite;
  
  public class Voiture extends Vehicule {
  
    public Voiture(String marque) {
      super(marque);
    }
    
    public void reculer(float vitesse) {
      super.reculer(vitesse);
    }

    // ...
    
  }


Dans l'exemple ci-dessus, le mot-clé **super** permet d'appeler l'implémentation
de la méthode fournie par la classe *Vehicule*. Ainsi l'attribut *vitesse* peut
rester de portée **private** et les classes filles de *Vehicule* peuvent ou non
donner publiquement l'accès à la méthode *reculer*.

Un méthode qui surcharge peut avoir un type de retour différent de la méthode
surchargée à condition qu'il s'agisse d'une classe qui hérite du type de retour
surchargé.


.. note::

  Exemple de surchage avec changement de type de retour


Le mot-clé super
****************

Le surcharge de méthode masque la méthode de la classe parente. Cependant, nous 
avons vu précédemment avec l'exemple de la méthode *reculer* que l'implémentation
d'une classe fille a la possibilité d'appeler une méthode de la classe parente
en utilisant le mot-clé **super**. L'appel à l'implémentation parente est très
utile lorsque l'on veut par exemple effectuer une action avant ou après sans
avoir besoin de dupliquer le code d'origine.

::

  package ROOT_PKG.conduite;
  
  public class Voiture extends Vehicule {
  
    public Voiture(String marque) {
      super(marque);
    }
    
    public void accelerer(float deltaVitesse) {
      // faire quelque chose avant

      super.accelerer(deltaVitesse);

      // faire quelque chose après
    }

    // ...
    
  }


Il existe tout de même une limitation : si une méthode a été surchargée plusieurs
fois dans l'arborescence d'héritage, le mot-clé **super** ne permet d'appeler
que l'implémentation de la classe parente. Si la classe *Voiture* a surchargé
la méthode *accelerer* et que l'on crée la classe *VoitureDeCourse* héritant
de la classe *Voiture*.

::

  package ROOT_PKG.conduite;
  
  public class VoitureDeCourse extends Voiture {
  
    public Voiture(String marque) {
      super(marque);
    }
    
    public void accelerer(float deltaVitesse) {
      // faire quelque chose avant

      super.accelerer(deltaVitesse);

      // faire quelque chose après
    }

    // ...
    
  }


La surcharge de la méthode *accelerer* peut appeler l'implémentation de *Voiture*
mais il est impossible d'appeler directement l'implémentation d'origine de la classe
*Vehicule* depuis la classe *VoitureDeCourse*.

L'annotation @Override
**********************

Les annotations sont des types spéciaux en Java qui commence par **@**. Les
annotations servent à ajouter une information sur une classe, un attribut,
une méthode, un paramètre ou une variable. Une annotation apporte une information
au moment de la compilation, du chargement de la classe dans la JVM ou lors
de l'exécution du code. Le langage Java proprement dit utilise relativement peu les annotations.
On trouve cependant l'annotation `@Override`_ qui est très utile pour le polymorphisme.
Cette annotation s'ajoute au début de la signature d'une méthode pour préciser
que cette méthode est une surcharge d'une méthode héritée. Cela permet au
compilateur de vérifier que la signature de la méthode correspond bien à une
méthode d'une classe parente. Dans le cas contraire, la compilation échoue.

::

  package ROOT_PKG.conduite;
  
  public class Voiture extends Vehicule {
  
    public Voiture(String marque) {
      super(marque);
    }
    
    @Override
    public void reculer(float vitesse) {
      super.reculer(vitesse);
    }

    // ...
    
  }

Les méthodes de classe
**********************

Les méthodes de classe (déclarées avec le mot-clé **static**) ne sont pas
assujetties à la surcharge. Si une classe fille déclare une méthode **static**
avec la même signature que dans la classe parente, ces méthodes seront simplement
vues par le compilateur comme deux méthodes distinctes.

::

  package ROOT_PKG;

  public class Parent {
    
     public static void methodeDeClasse() {
       System.out.println("appel à la méthode de la classe Parent");
     }

  }

::

  package ROOT_PKG;

  public class Enfant extends Parent {
    
     public static void methodeDeClasse() {
       System.out.println("appel à la méthode de la classe Enfant");
     }

  }


Dans le code ci-dessus, la classe *Enfant* hérite de la classe *Parent* et toutes
deux implémentent une méthode **static** appelée *methodeDeClasse*. Le code suivant
peut être source d'incompréhension :

::

  Parent a = new Enfant();
  a.methodeDeClasse();

  Enfant b = new Enfant();
  b.methodeDeClasse();


Le résultat de l'exécution de ce code est :

.. code-block:: text

  appel à la méthode de la classe Parent
  appel à la méthode de la classe Enfant

Comme les méthodes sont **static**, la surcharge ne s'applique pas et la méthode
appelée dépend du type de la variable et non du type de l'objet référencé par
la variable. Cet exemple illustre pourquoi il est très fortement conseillé
d'appeler les méthodes **static** à partir du nom de la classe et non pas d'une
variable afin d'éviter toute ambiguïté.

::

  Parent.methodeDeClasse();
  Enfant.methodeDeClasse();
 

Méthode finale
**************

Une méthode peut avoir le mot-clé **final** dans sa signature. Cela signifie
que cette méthode ne peut plus être surchargée par les classes qui en hériteront.
Tenter de surcharger une méthode déclarée **final** conduit à une erreur de
compilation. L'utilisation du mot-clé **final** pour une méthode est réservée
à des cas très spécifiques (et très rares). Par exemple si on souhaite garantir
qu'une méthode aura toujours le même comportement même dans les classes qui
en héritent.

.. note::

  Même si les méthodes **static** n'autorisent pas la surcharge, elles peuvent
  être déclarées **final**. Dans ce cas, il n'est pas possible d'ajouter une 
  méthode de classe qui a la même signature dans les classes qui en héritent.


Constructeur et polymorphisme
*****************************

Les constructeurs sont des méthodes particulières qu'il n'est pas possible
de surcharger. Les constructeurs créent une séquence d'appel qui garantit
qu'ils seront exécutés en commençant par la classe la plus haute dans la hiérarchie
d'héritage. Puisque toutes les classes Java héritent de la classe Object_, cela
signifie que le constructeur de Object_ est toujours appelé en premier.

Cependant un constructeur peut appeler une méthode et dans ce cas le polymorphisme
peut s'appliquer. Comme les constructeurs sont appelés dans l'ordre
de la hiérarchie d'héritage, cela signifie qu'un constructeur invoque
une méthode surchargée avant que la classe fille qui l'implémente n'ait pu être
initialisée.

Par exemple, si nous disposons d'un classe *VehiculeMotorise* qui surcharge la 
méthode   *accelerer* pour prendre en compte la consommation d'essence :

::

  package ROOT_PKG.conduite;
  
  public class VehiculeMotorise {

    private Moteur moteur;
    
    public VehiculeMotorise(String marque) {
      super(marque);
      this.moteur = new Moteur();
    }
    
    @Override
    public void accelerer(float deltaVitesse) {
      moteur.consommer(deltaVitesse);
      super.accelerer(deltaVitesse);
    }

    // ...
    
  }


Si maintenant nous faisons évoluer la classe *Vehicule* pour créer une instance
avec une vitesse minimale :

::

  package ROOT_PKG.conduite;
  
  public class Vehicule {

    private final String marque;
    protected float vitesse;
    
    public Vehicule(String marque) {
      this.marque = marque;
    }
    
    public Vehicule(String marque, float vitesse) {
      this.marque = marque;
      this.accelerer(vitesse);
    }

    public void accelerer(float deltaVitesse) {
      this.vitesse += deltaVitesse;
    }

    // ...
    
  }

Que va-t-il se passer à l'exécution de ce code :

::

  VehiculeMotorise vehiculeMotorise = new VehiculeMotorise("DeLorean");

Le constructeur de *VehiculeMotorise* commence par appeler le constructeur
de *Vehicule*. Ce dernier appelle implicitement le constructeur de Object_ (qui
ne fait rien) puis il initialise l'attribut *marque* et il appelle la méthode
*accelerer*. Comme cette dernière est surchargée, c'est en fait l'implémentation
fournie par *VehiculeMotorise* qui est appelée. Cette implémentation commence par appeler
une méthode sur l'attribut *moteur* qui n'a pas encore été initialisé. Donc sa
valeur est nulle et donc la création d'une instance de *VehiculeMotorise*
échoue systématiquement avec une erreur du type NullPointerException_.

On voit par cet exemple que l'appel de méthode dans un constructeur peut amener
à des situations complexes. Il est fortement recommandé d'appeler dans un constructeur
des méthodes dont le comportement ne peut pas être modifié par surcharge : soit 
des méthodes privées soit des méthodes déclarées **final**.

.. todo::

  * open/close principle
  * méthode static
  * name shadowing pour les attributs (attention certainement un bug)

.. _@Override: https://docs.oracle.com/javase/8/docs/api/java/lang/Override.html
.. _principe du ouvert/fermé: https://fr.wikipedia.org/wiki/Principe_ouvert/ferm%C3%A9
.. _Object: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html
.. _NullPointerException: https://docs.oracle.com/javase/8/docs/api/java/lang/NullPointerException.html
