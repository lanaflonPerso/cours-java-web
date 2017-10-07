Attributs & méthodes
####################

Dans ce chapitre, nous allons revenir sur la déclaration d'une classe en Java
et détailler les notions d'attributs et de méthodes.

Les attributs
*************

Les attributs représentent l'état interne d'un objet. Nous avons vu précédemment
qu'un attribut a une portée, un type et un identifiant :

::

  public class Voiture {

    public String marque;
    public float vitesse;

  }

La classe ci-dessus ne contient que des attributs, elle s'apparente à une simple
structure de données. Il est possible de créer une instance de cette classe
avec l'opérateur **new** et d'accéder aux attributs de l'objet créé avec
l'opérateur **.** :

::

  Voiture v = new Voiture();
  v.marque = "DeLorean";
  v.vitesse = 88.0f;

La portée
=========

Jusqu'à présent, nous avons vu qu'il existe deux portées différentes : *public* et *private*.
Java est un langage qui supporte l'encapsulation de données. Cela signifie que lorsque
nous créons une classe nous avons la choix de laisser accessible ou non au reste du programme
des attributs (mais aussi des méthodes). Le mécanisme d'encapsulation permet notamment
d'implémenter en Java le principe du *ouvert/fermé* qui est un des cinq principes SOLID_
de la conception objet.

Pour l'instant nous distinguerons les portées :

**public**
  Signale que l'attribut est visible de n'importe quelle partie de l'application.

**private**
  Signale que l'attribut n'est accessible que par l'objet lui-même ou par un objet du même type.
  Donc seules les méthodes de la classe déclarant cet attribut peuvent accéder à cet attribut.

Lorsque nous parlerons de l'encapsulation et du principe du *ouvert/fermé*, nous verrons qu'il
est très souvent préférable qu'un attribut ait une portée *private*.

L'initialisation
================

En Java, on peut indiquer la valeur d'initialisation d'un attribut pour chaque
nouvel objet.

::

  public class Voiture {

    public String marque = "DeLorean";
    public float vitesse = 88f;

  }

En fait, un attribut possède nécessairement une valeur par défaut qui dépend de son type :

.. list-table:: Initialisation par défaut des attributs
   :widths: 1 1
   :header-rows: 1

   * - Type
     - Valeur par défaut

   * - boolean
     - false

   * - char
     - ``'\0'``

   * - byte
     - 0

   * - short
     - 0

   * - int
     - 0

   * - long
     - 0

   * - float
     - 0.0

   * - double
     - 0.0

   * - Object
     - null

Donc, écrire ceci :

::

  public class Voiture {

    public String marque;
    public float vitesse;

  }

ou ceci

::

  public class Voiture {

    public String marque = null;
    public float vitesse = 0.0f;

  }

est strictement identique en Java.

attributs finaux
================

Un attribut peut être déclaré comme **final**. Cela signifie qu'il n'est plus possible
de modifier la valeur de cet attribut. De plus l'attribut doit être *explicitement*
initialisé.

::

  public class Voiture {

    public String marque;
    public float vitesse;
    public final int nombreDeRoues = 4;

  }

L'attribut *Voiture.nombreDeRoues* sera initialisé avec la valeur 4 pour chaque instance
et ne pourra plus être modifié.

.. code-block:: java
  :emphasize-lines: 2

  Voiture v = new Voiture();
  v.nombreDeRoues = 5; // ERREUR DE COMPILATION

.. caution::

  **final** porte sur l'attribut et empêche sa modification. Par contre si l'attribut
  est du type d'un objet, rien n'empêche de modifier des attributs ou d'appeler des méthodes
  qui vont modifier l'état de l'objet si ce dernier le permet.

  Pour une application d'un concessionnaire automobile, nous pouvons créer un objet *Facture*
  qui contient un attribut de type *Voiture* et le déclarer **final**.

  ::

    public class Facture {

      public final Voiture voiture = new Voiture();

    }

  Sur une instance de *Facture*, on ne pourra plus modifier la référence de l'attribut
  *voiture* par contre, on pourra toujours modifier les attributs de l'objet référencé

  .. code-block:: java
    :emphasize-lines: 3

    Facture facture = new Facture();
    facture.voiture.marque = "DeLorean"; // OK
    facture.voiture = new Voiture() // ERREUR DE COMPILATION

attributs de classe
===================

Jusqu'à présent, nous avons vu comment déclarer des attributs d'objet. C'est-à-dire
que chaque instance d'une classe aura ses propres attributs avec ses propres valeurs
représentant l'état interne de l'objet et qui peut évoluer au fur et à mesure de
l'exécution de l'application.

Mais il est également possible de créer des *attributs de classe*. La valeur de ces attributs
est partagée par l'ensemble des instances de cette classe. Cela signifie que si on modifie
la valeur d'un attribut de classe dans un objet, la modification sera visible dans
les autres objets. Cela signifie également que cet attribut existe au niveau de la classe
et est donc accessible même si on ne crée aucune instance de cette classe.

Pour déclarer un attribut de classe, on utilise le mot-clé **static**.

::

  public class Voiture {

    public static int nombreDeRoues = 4;
    public String marque;
    public float vitesse;

  }

Dans l'exemple ci-dessus, l'attribut *nombreDeRoues* est maintenant un attribut de classe.
C'est une façon de suggérer que toutes les voitures de notre application ont le même nombre
de roues. Cette caractéristique appartient donc à la classe plutôt qu'à chacune de ses instances.
Il est donc possible d'accéder directement à cet attribut depuis la classe :

::

  System.out.println(Voiture.nombreDeRoues);

Notez que dans l'exemple précédent, out_ est également un attribut de la classe System_. Si
vous vous rendez sur la documentation de cette classe, vous constaterez que out_ est déclaré
comme **static** dans cette classe. Il s'agit d'une autre utilisation des attributs de classe :
lorsqu'il n'existe qu'une seule instance d'un objet pour toute une application, cette instance
est généralement accessible grâce à un attribut **static**. C'est une des façons
d'implémenter le design pattern singleton_ en Java. Dans notre exemple, out_ est l'objet
qui représente la sortie standard de notre application. Cet objet est unique pour toute l'application
et nous n'avons pas à le créer car il existe dès le lancement de l'application.

Si le programme modifie un attribut de classe, alors la modification est visible depuis toutes
les instances :

::

  Voiture v1 = new Voiture();
  Voiture v2 = new Voiture();

  System.out.println(v1.nombreDeRoues); // 4
  System.out.println(v2.nombreDeRoues); // 4

  // modification d'un attribut de classe
  v1.nombreDeRoues = 5;

  Voiture v3 = new Voiture();

  System.out.println(v1.nombreDeRoues); // 5
  System.out.println(v2.nombreDeRoues); // 5
  System.out.println(v3.nombreDeRoues); // 5

Le code ci-dessus, même s'il est parfaitement correct, peut engendrer des difficultés de compréhension.
Si on ne sait pas que *nombreDeRoues* est un attribut de classe on peut le modifier en pensant que
cela n'aura pas d'impact sur les autres instances. C'est notamment pour cela que Eclipse émet un
avertissement si on accède ou si on modifie un attribut de classe à travers un objet.
Même si l'effet est identique, il est plus lisible d'accéder à un tel attribut à travers le nom de la classe uniquement :

::

  System.out.println(Voiture.nombreDeRoues); // 4

  Voiture.nombreDeRoues = 5;

  System.out.println(Voiture.nombreDeRoues); // 5


Attributs de classe finaux
==========================

Il n'existe pas de mot-clés pour déclarer une constante en Java. Même si **const**
est un mot-clé, il n'a aucune signification dans le langage. On utilise donc
la combinaison des mots clés **static** et **final** pour déclarer une constante.
Pour les distinguer des autres attributs, on écrit leur nom en majuscules et
les mots sont séparés par _.

::

  public class Voiture {

    public static final int NOMBRE_DE_ROUES = 4;
    public String marque;
    public float vitesse;

  }

.. caution ::

  Rappelez-vous que, si l'attribut référence un objet, **final** n'empêche pas d'appeler des méthodes
  qui vont modifier l'état interne de l'objet. On ne peut vraiment parler de constantes que pour les
  attributs de type primitif.

Les méthodes
************



.. todo::

portée public et private
paramètre et paramètres ...
paramètre final
overloading : redéfinition
méthodes statiques (rappel sur main)

portée des noms et this
***********************

.. todo::

  mot-clé this
  principe du name scoping

Les constructeurs
*****************

.. todo::

  portée public et private
  paramètre et initialisation (cas des final)
  appel à un autre constructeur de la classe depuis un constructeur

blocs d'initialisation
**********************

.. todo::

  bloc d'initialisation
  bloc d'initialisation static

principe d'encapsulation
*************************

.. todo::

  introduction au JavaBeans : notion de getter/setter


.. _SOLID: https://fr.wikipedia.org/wiki/SOLID_(informatique)
.. _singleton: https://fr.wikipedia.org/wiki/Singleton_(patron_de_conception)
.. _System: http://docs.oracle.com/javase/9/docs/api/java/lang/System.html
.. _out: http://docs.oracle.com/javase/9/docs/api/java/lang/System.html#out
