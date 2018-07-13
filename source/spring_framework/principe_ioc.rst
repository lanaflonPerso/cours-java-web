.. _spring_ioc:

L'inversion de contrôle
#######################

Le module principale du Spring Framework (*Spring Core*) repose sur un principe
de conception objet unique : **l'inversion de contrôle**.

Principe et implémentation
**************************

L'inversion de contrôle (IoC - *Inversion of control*), également appelée
inversion de dépendance, se base sur la technique de l'injection de dépendance.
Ce principe n'est pas propre au Spring Framework mais est utilisé fréquemment
en programmation objet.

Un objet est très souvent dépendant d'autres objets pour assurer l'ensemble de ses services.
En Java, une dépendance entre deux objets est simplement indiqué par la présence
d'un attribut.

Par exemple, une classe de type ``Voiture`` peut posséder un attribut de type
``Moteur`` :

::

  public class Voiture {

    private Moteur moteur;

    // ...

  }

Un objet de type ``Voiture`` a un dépendance avec un objet de type ``Moteur``.
Au final, une application orientée objet peut être conçue comme une myriades
d'objets ayant des interdépendances les uns avec les autres.

Le principe d'inversion de contrôle consiste à inverser le rapport entre un objet
et l'objet dont il dépend. Si nous reprenons l'exemple ci-dessus, nous pouvons
considérer que puisqu'un objet de type ``Voiture`` est dépendant d'un objet
de type ``Moteur`` alors il peut le créer au moment de sa propre création.

::

  public class Voiture {

    private Moteur moteur;

    public Voiture() {
      this.moteur = new Moteur();
    }

    // ...

  }

Cette implémentation n'est cependant pas sans conséquence car elle introduit
un couplage très fort entre les classes ``Voiture`` et ``Moteur``. En effet,
non seulement la classe ``Voiture`` est dépendante de la classe ``Moteur`` mais
surtout, elle crée elle-même l'objet de type ``Moteur``. En architecture logicielle,
on constate souvent qu'un classe dépendante d'une autre n'est pas nécessairement
la mieux placée pour créer l'objet dont elle dépend. Il peut y avoir des raisons
très diverses pour cela. Par exemple :

* La classe ``Moteur`` pourrait avoir besoin de paramètres de constructeur que
  la classe ``Voiture`` n'a pas nécessairement à connaître
* Il peut exister une hiérarchie d'héritage de la classe ``Moteur``. Par exemple,
  les classes ``MoteurEssence``, ``MoteurElectrique``, ``MoteurHybride`` pourraient
  toutes héritées de la classe ``Moteur``. Si la classe ``Voiture`` crée l'objet
  de type ``Moteur`` alors il faudra choisir un fois pour toute dans la classe
  ``Voiture`` le type réel du moteur
* La classe ``Moteur`` pourrait être une interface. Donc il pourrait s'agir d'une
  pure abstraction. Si la classe ``Voiture`` crée l'objet implémentant cette interface,
  alors on perd tout intérêt à travailler à partir d'abstractions telle que les interfaces.

Pour améliorer notre implémentation, nous pouvons avoir recours à l'inversion
de contrôle en partant du principe que la classe ``Voiture`` ne devrait pas
être responsable de la création d'un objet d'un type ``Moteur``. Pour cela,
nous pouvons passer un objet de type ``Moteur`` comme argument du constructeur.
On parle alors d'injection de dépendance par constructeur :

::

  public class Voiture {

    private Moteur moteur;

    public Voiture(Moteur moteur) {
      this.moteur = moteur;
    }

    // ...

  }

Nous avons déplacé la responsabilité de création de l'objet de type ``Moteur``
en dehors de la classe ``Voiture``. Nous pouvons maintenant créer facilement
des voitures utilisant des moteurs de type différents :

::

  Voiture voitureEssence = new Voiture(new MoteurEssence());
  Voiture voitureElectrique = new Voiture(new MoteurEssence());
  Voiture voitureHybride = new Voiture(new MoteurHybride());

Nous pouvons également créer une méthode *setter* pour positionner un objet de type
``Moteur`` dans la classe ``Voiture``. On parle alors d'injection de dépendance
par *setter* :

::

  public class Voiture {

    private Moteur moteur;

    public void setMoteur(Moteur moteur) {
      this.moteur = moteur;
    }

    // ...

  }

Comme précédemment, nous avons déplacé la responsabilité de création de l'objet
en dehors de la classe ``Voiture`` :

::

  Voiture voiture = new Voiture();
  voiture.setMoteur(new MoteurEssence());

.. note::

  Même si du point de vue de la dépendance d'injection, les deux mécanismes
  conduisent au même résultat, la dépendance d'injection par constructeur à
  une sémantique plus forte. Cela traduit que l'objet a besoin de cette
  dépendance pour fonctionner correctement. L'injection par *setter* permet
  de modifier la dépendance durant la vie de l'objet. Bien évidemment, il
  est possible d'utiliser les deux mécanismes au sein d'une même classe.

Notion de conteneur IoC
***********************

Pour fonctionner, l'inversion de contrôle implique l'existence d'un composant
supplémentaire. Dans l'exemple que nous avons pris précédemment, un code tiers est
responsable de créer une instance de la classe ``Moteur``, une instance de
la classe ``Voiture`` et de créer la dépendance soit par injection au constructeur
soit par appel de la méthode *setter*.

La construction des objets de notre application va être déléguée à ce composant
que l'on appelle un conteneur IoC (*IoC container*). De ce point de vue, le
Spring Framework fournit avant tout un conteneur IoC. On pourrait dire que
le Spring Framework sert principalement à créer des objets à notre place et à s'assurer
que les dépendances entre eux sont correctement créées. De manière plus triviale,
lorsqu'on utilise un conteneur IoC, nous limitons dans notre code l'usage du
mot-clé :code:`new` car nous laissons le conteneur créer les objets.

