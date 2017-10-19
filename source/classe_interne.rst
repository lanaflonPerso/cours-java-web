Les classes internes
####################

La façon la plus courante de déclarer une classe en Java est de créer un fichier
portant le nom de la classe avec l'extension *.java*. Cependant, il est également
possible de déclarer des classes dans des classes. On parle alors de classes
internes (*inner classes*). Cela est également vrai dans une certaine limite pour
les interfaces et les énumérations. 

La déclaration des classes internes peut se faire dans l'ordre que l'on souhaite
à l'intérieur du bloc de déclaration de la classe externe. Les classes internes 
peuvent être ou non déclarées **static**. Ces deux cas correspondent à deux 
usages particuliers des classes internes.

::

  package ROOT_PKG;

  public class ClasseExterne {
  
    public static class ClasseInterneStatic {
    }
  
    public class ClasseInterne {
    }
    
  }

Les classes internes **static**
*******************************

Les classes internes déclarées **static** sont des classes comme les autres sauf
que l'espace de noms dans lequel elles sont déclarées est celui de la classe
englobante.

Cela a plusieurs conséquences :

* Le nom complet de la classe interne inclus le nom de la classe externe (elle
  agit comme un package)


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
  
