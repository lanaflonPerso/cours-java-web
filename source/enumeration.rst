Les énumérations
################

Dans une application, il est très utile de pourvoir représenter des listes 
finies d'élements. Par exemple, si une application a besoin d'une liste
de niveaux de criticité, elle peut créer des constantes dans une classe 
utilitaire quelconque.

::

  package ROOT_PKG;

  public class ClasseUtilitaireQuelconque {
  
    public static final int CRITICITE_FAIBLE = 0;
    public static final int CRITICITE_NORMAL = 1;
    public static final int CRITICITE_HAUTE = 2;
  }
  
Ce choix d'implémentation est très imparfait. Même si le choix du type **int**
permet de retranscrire une notion d'ordre dans les niveaux de criticité, il ne
permet pas de créer un vrai type représentant une criticité.

Il existe un type particulier en Java qui permet de fournir une meilleure
implémentation à ce cas : l'énumération. Un énumération se déclare avec le mot-clé
**enum**.

::

  package ROOT_PKG;

  public enum Criticite {

    FAIBLE,
    NORMAL,
    HAUTE

  }


.. note::

  Les éléments d'une énumération sont des constantes. Donc, par convention,
  ils sont écrits en majuscules et les mots sont séparés par _.

Comme une classe, une énumération a une portée et elle est définie dans un fichier
qui porte son nom. Pour l'exemple ci-dessus, le code source sera dans le fichier
*Criticite.java*.

L'énumération permet de définir un type avec un nombre fini de valeurs possibles.
Il est possible de manipuler ce nouveau type comme une constante, comme un attribut,
un paramètre et une variable.

::

  package ROOT_PKG;
  
  public class RapportDeBug {
  
    private Criticite criticite = Criticite.NORMAL;
    
    public RapportDeBug() {
    }

    public RapportDeBug(Criticite criticite) {
      this.criticite = criticite;
    }
  }
  
::

  RapportDeBug rapport = new RapportDeBug(Criticite.HAUTE);
  

.. note::

  Une variable, un attribut ou un paramètre du type d'une énumération peut
  avoir la valeur **null**.

Les méthodes d'une énumération
******************************

Nous verrons bientôt qu'une énumération est en fait une classe particulière.
Donc une énumération fournit également des méthodes de classe et des méthodes
pour chacun des éléments de l'énumération.

**valueOf**
  permet de convertir une chaîne de caractères en une énumération. Attention
  toutefois, si la chaîne de caractères ne correspond pas à un élément
  de l'énumération, cette méthode produit une IllegalArgumentException_.
  
  ::
  
    Criticite criticite = Criticite.valueOf("HAUTE");
  
**values**
  retourne un tableau contenant tous les élements de l'énumération dans l'ordre
  de leur déclaration. Cette méthode est très pratique pour connaître la liste
  des valeurs possibles par programmation.
  
  ::
  
    for(Criticite c : Criticite.values()) {
      System.out.println(c);
    }

Chaque élément d'une énumération possède les méthodes suivantes :

**name**
  Retourne le nom de l'élement sous la forme d'une chaîne de caractères.
  
  ::
    
    String name = Criticite.NORMAL.name(); // "NORMAL"

**ordinal**
  Retourne le numéro d'ordre d'un élément. Le numéro d'ordre est donné
  par l'ordre de la déclaration, le premier élément ayant le numéro 0.
  
  ::
  
    int ordre = Criticite.HAUTE.ordinal(); // 2


.. note::

  Une énumération implémente également l'interface Comparable_.
  Donc, une énumération implémente la méthode compareTo_ qui réalise une
  comparaison en se basant sur le numéro d'ordre.

.. todo::

  comparaison avec ==
  utilisation dans switch
  déclaration d'une énum dans une classe
  principe de génération par la compilateur
  ajout de méthodes (le cas du ;)
  ajout de constructeurs (forcément private)
  classe parente d'un enum (Enum<?>)
  
.. _IllegalArgumentException: http://docs.oracle.com/javase/8/docs/api/java/lang/IllegalArgumentException.html  
.. _Comparable: http://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html
.. _compareTo: http://docs.oracle.com/javase/8/docs/api/java/lang/Enum.html#compareTo-E-

