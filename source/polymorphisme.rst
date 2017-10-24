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
si elle-ci est plus ouverte que celle de la méthode surchargée. Il est donc
possible d'augmenter la portée de la méthode mais jamais de le réduire. Cette
possibilité se limite aux cas suivants :

* Une méthode de portée package peut être surchargée avec la portée package
  mais aussi **protected** ou **public**.
* Une méthode de portée **protected** peut être surchargée avec la portée
  **protected** ou **public**.
* Une méthode de portée **public** ne peut être surchargée qu'avec la portée
  **public**

.. todo::

  trouver un exemple de changement de portée pour la surcharge
  

L'annotation @Override
**********************

Les annotations sont des types spéciaux en Java qui commence par **@**. Les
annotations servent à ajouter une information sur une classe, un attribut,
une méthode, un paramètre ou une variable. Une annotation apporte une information
au moment de la compilation, du chargement de la classe dans la JVM ou lors
de l'exécution du code. Le langage Java utilise relativement peu les annotations.
On trouve cependant l'annotation `@Override`_ qui très utile pour le polymorphisme.
Cette annotation s'ajoute au début de la signature d'une méthode pour préciser
que cette méthode est une surcharge d'une méthode héritée. Cela permet au
compilateur de vérifier que la signature de la méthode correspond bien à une
méthode d'une classe parente. Dans le cas contraire, la compilation échoue.

.. todo::

  exemple avec @Override

.. todo::

  * appel à la méthode parente avec super
  * changement de niveau de visibilité pour les méthodes (ex de Object.clone)
  * changement de valeur de retour pour les méthodes
  * introduction aux annotations avec @Override
  * pas de polymorphisme pour les méthodes privées
  * notion de early binding et late binding
  * final sur une méthode
  * constructeur et polymorphisme
  * open/close principle
  * name shadowing pour les attributs (attention certainement un bug)

.. _@Override: https://docs.oracle.com/javase/8/docs/api/java/lang/Override.html
