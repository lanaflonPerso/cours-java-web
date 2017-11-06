Les classes internes
####################

La façon la plus courante de déclarer une classe en Java est de créer un fichier
portant le nom de la classe avec l'extension *.java*. Cependant, il est également
possible de déclarer des classes dans des classes. On parle alors de classes
internes (*inner classes*). Cela est également vrai dans une certaine limite pour
les interfaces et les énumérations. 

La déclaration des classes internes peut se faire dans l'ordre que l'on souhaite
à l'intérieur du bloc de déclaration de la classe englobante. Les classes internes 
peuvent être ou non déclarées **static**. Ces deux cas correspondent à deux 
usages particuliers des classes internes.

::

  package ROOT_PKG;

  public class ClasseEnglobante {
  
    public static class ClasseInterneStatic {
    }
  
    public class ClasseInterne {
    }
    
  }

Les classes internes static
***************************

Les classes internes déclarées **static** sont des classes comme les autres sauf
que l'espace de noms dans lequel elles sont déclarées est celui de la classe
englobante.

Cela a plusieurs conséquences :

* Le nom complet de la classe interne inclus le nom de la classe englobante (elle
  agit comme un package)
* La classe englobante et la classe iterne partage le même espace privé. Cela
  signifie que les attributs et les méthodes privés déclarés dans la classe
  englobante sont accessibles à la classe interne. Réciproquement, la classe 
  englobante peut avoir accés aux éléments privés de la classe interne.
* Une instance de la classe interne ne peux pas avoir accès directement aux
  attributs et aux méthodes de la classe englobante qui ne sont pas déclarés
  **static**.

.. todo::
  exemple de classe interne static et préciser le nom complet de la classe

Une classe interne **static** est un moyen de dissimuler l'implémentation
d'une interface. La classe englobante agit comme une *fabrique*.

Une classe interne **static** est également utile pour éviter de séparer
dans des fichiers différents de petites classes utilitaires et ainsi de faciliter
la lecture du code. Dans l'exemple ci-dessous, plutôt que de créer un fichier
spécifique pour l'implémentation d'un comparateur, on ajoute son implémentation
comme une classe interne.

::

  package ROOT_PKG;
  import java.util.Comparator;

  public class Individu {
    
    public static class Comparateur implements Comparator<Individu> {
      @Override
      public int compare(Individu i1, Individu i2) {
        if (i1 == null) {
          return -1;
        }
        if (i2 == null) {
          return 1;
        }
        int cmp = i1.nom.compareTo(i2.nom);
        if (cmp == 0) {
          cmp = i1.prenom.compareTo(i2.prenom);
        }
        return cmp;
      }
    }
    
    private final String prenom;
    private final String nom;
    
    public Individu(String prenom, String nom) {
      this.prenom = prenom;
      this.nom = nom;
    }
    
    @Override
    public String toString() {
      return this.prenom + " " + this.nom;
    }

  }

::

  Individu[] individus = {
      new Individu("John", "Eod"),
      new Individu("Annabel", "Doe"), 
      new Individu("John", "Doe") 
  };
  
  Arrays.sort(individus, new Individu.Comparateur());
  
  System.out.println(Arrays.toString(individus));

Dans l'exemple ci-dessus, la classe *Individu* fournit publiquement une
implémentation d'un Comparator_ qui permet de comparer deux instances en
fonction de leur nom et de leur prénom. Notez que l'implémentation de la
méthode *compare* peut accéder aux attributs privés *nom* et *prenom* de la
classe englobante.

Les classes internes
********************

Une instance d'une classe interne qui n'est pas déclarée avec le mot-clé 
**static** est liée au contexte d'exécution d'une instance de la classe
englobante.

Comme pour les classes internes **static**, le nom complet de classe interne
inclus celui de la classe englobante et les deux classes partagent le même
espace privé. Mais il y a également d'autres conséquences :

* une instance d'une classe interne ne peut être crée que s'il existe un contexte
  d'exécution associé à une instance de la classe englobante. Donc, on ne peut
  créer une instance d'une classe interne que dans un constructeur ou dans
  une méthode de la classe englobante ou dans une de ses classes internes.
* une instance d'une classe interne a accès directement aux attributs de l'instance
  dans le contexte de laquelle elle a été créée.



.. todo::

  * classe interne static
  * intérêt des classes internes : cacher l'implémentation d'interface
  * pas de portée sur les classes (mère/fille, fille/mère et soeur/soeur)
  * classe interne et closure
  * classe anonyme (limitation : pas de possibilité de créer un constructeur)
  * classe dans une méthode (final avec les variables et les attributs)
  * shadowing (MyOutterClass.this.attribut)
  * cas des interfaces
  * cas des énumérations (static par defaut)
  * cas particulier de plusieurs classes dans une unité de compilation

.. _Comparator: https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html
