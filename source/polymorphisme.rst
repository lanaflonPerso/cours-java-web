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


L'annotation @Override
**********************

Les annotations sont des types spéciaux en Java qui commence par **@**. Les
annotations servent à ajouter une information sur une classe, un attribut,
une méthode, un paramètre ou une variable. Une annotation apporte une information
au moment de la compilation, du chargement de la classe dans la JVM ou lors
de l'exécution du code. Le langage Java utilise relativement peu les annotations.
On trouve cependant l'annotation `@Override`_ qui est très utile pour le polymorphisme.
Cette annotation s'ajoute au début de la signature d'une méthode pour préciser
que cette méthode est une surcharge d'une méthode héritée. Cela permet au
compilateur de vérifier que la signature de la méthode correspond bien à une
méthode d'une classe parente. Dans le cas contraire, la compilation échoue.

.. todo::

  exemple avec @Override

.. todo::

  * appel à la méthode parente avec super
  * final sur une méthode
  * constructeur et polymorphisme
  * open/close principle
  * name shadowing pour les attributs (attention certainement un bug)

.. _@Override: https://docs.oracle.com/javase/8/docs/api/java/lang/Override.html
.. _principe du ouvert/fermé: https://fr.wikipedia.org/wiki/Principe_ouvert/ferm%C3%A9

