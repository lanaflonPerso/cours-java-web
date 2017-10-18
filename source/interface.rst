Les interfaces
##############

Une interface permet de définir en ensemble de service qu'un client peut
obtenir d'un objet. Une interface introduit une abstraction pure qui permet
une découplage maximal entre un service et son implémentation. On retrouve
ainsi les interfaces au cœur de l'implémentation de beaucoup de frameworks.
Le mécanisme des interfaces permet d'introduire également une forme simplifiée 
d'héritage multiple.


Déclaration d'un interface
**************************

Une interface se déclare avec le mot-clé **interface**.

::

  package ROOT_PKG.compte;

  public interface Compte {
  
  }
  
Comme pour une classe, une interface a une portée, un nom et une déclaration
dans un bloc. Une interface est déclarée dans son propre fichier portant le même
nom que l'interface. Pour l'exemple ci-dessous, le fichier doit s'appeler 
*Compte.java*.

Une interface décrit un ensemble de méthodes en fournissant uniquement leur
signature.

::

  package ROOT_PKG.compte;

  public interface Compte {
  
    void deposer(int montant) throws OperationInterrompueException, 
                                     CompteBloqueException;
  
    int retirer(int montant) throws OperationInterrompueException, 
                                    CompteBloqueException;
                                    
    int getBalance() throws OperationInterrompueException;

  }


Une interface introduit un nouveau type d'abstraction qui définit à travers
ces méthodes un ensemble d'interactions autorisées. 
Une classe peut implémenter une ou plusieurs interfaces.

.. note ::

  Les méthodes d'une interface sont par défaut **public** et **abstract**. Il 
  n'est pas possible de déclarer une autre portée que **public**.
  
  ::
  
    package ROOT_PKG;

    public interface Mobile {
      
      public abstract void deplacer() ;

    }
    
  L'interface ci-dessus est strictement identique à celle-ci :
  
  ::
  
    package ROOT_PKG;

    public interface Mobile {
      
      void deplacer() ;

    }
   

Implémentation d'une interface
******************************

Une classe signale les interfaces qu'elle implémente grâce au mot-clé **implements**.
Une classe concrète doit fournir une implémentation pour toutes les méthodes
d'une interface, soit dans sa déclaration, soit parce qu'elle en hérite.

::

  package ROOT_PKG.compte;

  public class CompteBancaire implements Compte {

    private final String numero;
    private int balance;
    
    public CompteBancaire(String numero) {
      this.numero = numero;
    }

    @Override
    public void deposer(int montant) {
      this.balance += montant;
    }

    @Override
    public int retirer(int montant) throws OperationInterrompueException {
      if (balance < montant) {
        throw new OperationInterrompueException();
      }
      return this.balance -= montant;
    }

    @Override
    public int getBalance() {
      return this.balance;
    }
    
    public String getNumero() {
      return numero;
    }

  }

L'implémentation des méthodes d'une interface suit les mêmes règles que la surcharge.

.. note ::
  
  Si la classe qui implémente l'interface est une classe abstraite, alors elle n'est
  pas obligée de fournir une implémentation pour les méthodes de l'interface.

Même si les mécanismes des interfaces sont proches de ceux des classes abstraites,
ces deux notions sont clairement distinctes. Une classe abstraite permet de mutualiser
une implémentation dans une hiérarchie d'héritage en introduisant un type plus abstrait.
Une interface permet de définir les interactions possibles entre un objet et
ses clients. Une interface agit comme un contrat que les deux parties doivent 
remplir. Comme l'interface n'impose pas de s'insérer dans une hiérarchie d'héritage,
il est relativement simple d'adapter une classe pour qu'elle implémente une interface.

Une interface introduit un nouveau type de relation qui serait du type *est
comme un* (*is-like-a*).

Pour une exemple d'application de comptes, cela signifie qu'il est 
possible de créer tout un système de gestion de comptes à travers l'interface
*Compte*. Il est facile ensuite de fournir une implémentation de cette interface,
pour un compte bancaire, un porte-monnaie électronique, un compte en ligne...

Une classe peut implémenter plusieurs interfaces si nécessaire. Pour cela, il
suffit de donner les noms des interfaces séparés par une virgule.

::

  package ROOT_PKG.animal;

  public interface Carnivore {
    
    void manger(Animal animal);

  }

::

  package ROOT_PKG.animal;

  public interface Herbivore {
    
    void manger(Vegetal vegetal);

  }

::

  package ROOT_PKG.animal;

  public class Humain extends Animal implements Carnivore, Herbivore {

    @Override
    public void manger(Animal animal) {
      // ...
    }

    @Override
    public void manger(Vegetal vegetal) {
      // ...
    }

  }

Dans l'exemple précédent, la classe *Humain* implémente les interfaces
*Carnivore* et *Herbivore*. Donc une instance de la classe *Humain* peut
être utilisée dans une application partout où les types *Carnivore* et *Herbivore*
sont attendus.


::

  Humain humain = new Humain();
  
  Carnivore carnivore = humain;
  carnivore.manger(new Poulet()); // Poulet hérite de Animal
  
  Herbivore herbivore = humain;
  herbivore.manger(new Chou());   // Chou hérite de Vegetal


Attributs et méthodes statiques
*******************************

Une interface peut déclarer des attributs. Cependant tous les attributs d'une
interface sont par défaut **public**, **static** et **final**. Autrement
dit, une interface peut déclarer uniquement des constantes.

.. todo ::

  * déclaration
  * public abstract pour les méthodes
  * implémentation d'interface (remarque sur les classes abstraites)
  * is like a

  * méthodes static et attributs static final (par défaut)
  * héritage entre interfaces
  * interface marqueur (exemple Cloneable et Serializable)
  * implémentation par défaut
  * ségrégation d'interface
  * exemple Comparable pour le tri et la recherche de tableau
  
