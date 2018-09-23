Les relations entre objets
##########################

Une application Java est composée d'un ensemble d'objets. Un des intérêts de la
programmation objet réside dans les relations que ces objets entretiennent les
uns avec les autres. Ces relations sont construites par les développeurs et
constituent ce que l'on appelle l'architecture d'une application. Il existe
deux relations fondamentales en programmation objet :

**est un** (*is-a*)
  Cette relation permet de créer une chaîne de relation d'identité entre des
  classes. Elle indique qu'une classe peut être assimilée à une autre classe
  qui correspond à une notion plus abstraite ou plus générale.
  On parle **d'héritage** pour désigner le mécanisme qui permet d'implémenter ce type de relation.

**a un** (*has-a*)
  Cette relation permet de créer une relation de dépendance d'une classe envers
  une autre. Une classe a besoin des services d'une autre classe pour réaliser
  sa fonction. On parle également de relation de **composition** pour désigner
  ce type de relation.


L'héritage (is-a)
*****************

Imaginons que nous voulions développer un simulateur de conduite. Nous pouvons
concevoir une classe *Voiture* qui sera la représentation d'une voiture dans
notre application.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Voiture {

    private final String marque;
    private float vitesse;

    public Voiture(String marque) {
      this.marque = marque;
    }

    // ...

  }


Mais nous pouvons également rendre possible la simulation d'une moto. Dans ce
cas, nous aurons également besoin d'une classe *Moto*.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Moto {

    private final String marque;
    private float vitesse;

    public Moto(String marque) {
      this.marque = marque;
    }

    // ...

  }

On se rend vite compte qu'au stade de notre développement, une voiture et une
moto représentent la même chose. Faut-il alors créer deux classes
différentes ? En programmation objet, il n'y a pas de réponse toute faite à cette
question. Mais si notre application gère, par exemple, le type de permis de
conduire, il serait judicieux d'avoir des représentations différentes pour ces
types de véhicule car ils nécessitent des permis de conduire différents.
Si mon application de simulation permet de faire se déplacer des objets
de ces classes, alors il va peut-être falloir autoriser les objets de type
*Voiture* à aller en marche arrière mais pas les objets de type *Moto*. Bref,
comme souvent en programmation objet, on se retrouve avec des classes qui ont
des notions en commun (dans notre exemple, la vitesse et la marque), tout en ayant
leurs propres spécificités.

Pour ce type de relations, nous pouvons utiliser l'héritage pour faire apparaître
une classe réprésentant une notion plus générale ou plus abstraite. Dans notre
exemple, il pourrait s'agir de la classe *Vehicule*. Les classes *Voiture* et
*Moto* peuvent *hériter* de cette nouvelle classe puiqu'une voiture **est un**
véhicule et une moto **est un** véhicule.

.. image:: images/heritage/heritage_vehicule.png

En Java, l'héritage est indiqué par le mot clé **extends** après le nom de la
classe. On dit donc qu'une classe en *étend* une autre. La classe qui est étendue
est appelée *classe mère* ou *classe parente* et la classe qui étend est appelée
*classe fille* ou *classe enfant*.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Vehicule {

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Voiture extends Vehicule {

    private final String marque;
    private float vitesse;

    public Voiture(String marque) {
      this.marque = marque;
    }

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Moto extends Vehicule {

    private final String marque;
    private float vitesse;

    public Moto(String marque) {
      this.marque = marque;
    }

    // ...

  }


Le terme d'héritage vient du fait qu'une classe qui en étend une autre *hérite*
de la définition de sa classe parente et notamment de ses attributs et de ses
méthodes. Par exemple, les classes *Voiture* et *Moto* ont en commun la déclaration
de l'attribut *vitesse*. Cet attribut semble donc faire partie de la généralisation
commune de *Vehicule*.

.. image:: images/heritage/heritage_vehicule_attribut_vitesse.png


.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Vehicule {

    private float vitesse;

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Voiture extends Vehicule {

    private final String marque;

    public Voiture(String marque) {
      this.marque = marque;
    }

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Moto extends Vehicule {

    private final String marque;

    public Moto(String marque) {
      this.marque = marque;
    }

    // ...

  }

Il est maintenant possible d'ajouter les méthodes *accelerer* et *decelerer* à
la classe Vehicule et les classes *Voiture* et *Moto* en hériteront.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Vehicule {

    private float vitesse;

    public void accelerer(float deltaVitesse) {
      this.vitesse += deltaVitesse;
    }

    public void decelerer(float deltaVitesse) {
      this.vitesse = Math.max(this.vitesse - deltaVitesse, 0f);
    }

    // ...

  }

Tous les véhicules de cette application peuvent maintenant accélérer et décélérer.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class AppliSimple {

    public static void main(String[] args) {
      Voiture voiture = new Voiture("DeLorean");
      voiture.accelerer(88);

      Moto moto = new Moto("Kaneda");
      moto.accelerer(120);
    }

  }


Héritage et constructeur
************************

Dans notre exemple précédent, l'attribut *marque* pourrait tout aussi bien être
mutualisé dans la classe *Vehicule*. Cependant, il va falloir tenir compte
des constructeurs de *Voiture* et *Moto* qui garantissent une initialisation
de cet attribut à partir du paramètre.

En Java, nous avons vu qu'un constructeur peut appeler un autre constructeur
déclaré dans la même classe grâce au mot-clé *this*. De la même manière, un
constructeur peut appeler un constructeur de sa classe parente grâce au mot-clé
**super**. Il doit respecter les mêmes contraintes :

* Un constructeur ne peut appeler qu'un constructeur.
* L'appel au constructeur doit être la première instruction du constructeur.

Il est donc possible de déclarer un constructeur dans la classe *Vehicule* et
d'appeler ce constructeur depuis les constructeurs de *Voiture* et *Moto*.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

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

    // ...

  }


.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Voiture extends Vehicule {

    public Voiture(String marque) {
      super(marque);
    }

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Moto extends Vehicule {

    public Moto(String marque) {
      super(marque);
    }

    // ...

  }


*Voiture* et *Moto* peuvent maintenant proposer leurs propres méthodes et attributs
tout en ayant en commun les mêmes méthodes et attributs que la classe *Vehicule*.

.. image:: images/heritage/heritage_vehicule_attribut_vitesse_marque.png

En java, si votre constructeur n'appelle aucun constructeur, alors le compilateur
génèrera une instruction d'appel au constructeur sans paramètre de la classe parente.

Si vous créez la classe suivante :

.. code-block:: java

  package {{ROOT_PKG}}.simple.test

  public class MaClasse {

    public MaClasse() {
    }

  }

Le compilateur génèrera le bytecode correspondant au code suivant :

.. code-block:: java

  package {{ROOT_PKG}}.simple.test

  public class MaClasse extends Object {

    public MaClasse() {
      super()
    }

  }


Si vous omettez d'appeler un constructeur, alors le compilateur part du principe
qu'il en existe un de disponible dans la classe parente et que ce constructeur
ne prend pas de paramètre. Ainsi, Java garantit qu'un constructeur de la classe
parente est toujours appelé avant l'exécution du constructeur courant. Cela signifie
que, lors de la création d'un objet, on commence toujours par initialiser la
classe la plus haute dans la hiérarchie d'héritage.

Ce qui peut sembler surprenant dans l'exemple précédent est que la classe
*MaClasse* ne déclare pas de classe parente mais que le compilateur va forcer
un héritage.


Héritage simple : Object
************************

Java ne supporte pas l'héritage multiple. Soit le développeur déclare avec
le mot-clé **extends** une seule classe parente, soit le compilateur part
du principe que la classe hérite de la classe Object_. Toutes les classes
en Java ont une classe parente (hormis la classe Object_). L'arbre d'héritage
en Java ne possède qu'une seule classe racine : la classe Object_.

.. note ::

  C'est la classe Object_ qui déclare notamment les méthodes toString_ et equals_.
  Voilà pourquoi tous les objets Java peuvent avoir par défaut une représentation
  sous forme de chaîne de caractères et qu'ils peuvent être comparés aux autres.


Héritage et affectation
***********************

L'héritage introduit la notion de *substituabilité* entre la classe enfant et la
classe parente. Une classe enfant a son propre type mais partage également le
même type que sa classe parente.

Pour notre exemple, cela signifie que l'on peut affecter à une variable de type
*Vehicule*, une instance de *Voiture* ou une instance de *Moto* :

.. code-block:: java

  Vehicule vehicule = null;
  vehicule = new Voiture("DeLorean");
  vehicule = new Moto("Kaneda");

Cette possibilité introduit une abstraction importante dans la programmation
objet. Si une partie d'un programme a besoin d'une instance de type *Vehicule*
pour s'exécuter, alors cela signifie qu'une instance de n'importe quelle classe
héritant directement ou indirectement de *Vehicule* peut être utilisée.

Lorsqu'on crée une classe par héritage, cela signifie qu'il faut faire attention
à ne pas altérer le comportement attendu par les utilisateurs de la classe parente.

.. note ::

  L'acronyme SOLID_ proposé par Robert Matin regroupe 5 principes importants
  de la programmation objet. La lettre L désigne le `Liskov substitution principle`_
  (principe de substitution de Liskov) qui décrit ce principe de substitution
  entre un type et son sous-type et les contraintes qui en découlent pour la
  conception objet.

Le principe de substituabilité est une application du transtypage (*casting*).
Comme pour les types primitifs, il est possible d'affecter une référence d'un
objet à une variable, attribut ou paramètre d'un type différent. Pour que cette
affectation soit possible il faut que les deux types fassent partie de la même
hiérarchie d'héritage.

.. image:: images/heritage/heritage_downcasting_casting.png

Si le type d'arrivée correspond à un type parent, on parle *d'upcasting*
(transtypage vers le haut). Si le type d'arrivée correspond à un type enfant,
on parle de *downcasting* (transtypage vers le bas).

À partir du moment où l'implémentation des classes respectent le
`principe de substitution de Liskov`_, l'upcasting est une opération sûre en
programmation objet. Voilà pourquoi, il est possible d'affecter des instances
de type *Voiture* à des variables de type *Vehicule*.

.. note::

  Comme Java se base sur une hiérarchie à racine unique, toutes les classes
  héritent directement ou indirectement de Object_. Donc, toute instance peut
  être affectée à une variable, un attribut ou un paramètre de type Object_.

  .. code-block:: java

    Object obj = null;
    obj = new Voiture("DeLorean");
    obj = "ceci est une chaine de caractère";
    obj = Integer.valueOf(1);


À l'inverse, le downcasting n'est pas une opération sûre en programmation objet.
Prenons l'exemple trivial suivant :

.. code-block:: java
  :emphasize-lines: 2

  Vehicule vehicule = new Voiture("DeLorean");
  Moto moto = vehicule; // ERREUR

La variable *vehicule* référence un objet de type Voiture, il n'est donc pas possible
d'affecter cet objet à une variable de type *Moto*. Pour cette raison, le
langage Java, n'autorise pas par défaut le downcasting : l'exemple ci-dessus
ne compilera pas. Il est cependant possible de forcer le transtypage en
utilisant la même syntaxe que pour les types primitifs.

.. code-block:: java
  :emphasize-lines: 3

  Vehicule vehicule = new Voiture("DeLorean");
  Voiture voiture = (Voiture) vehicule;
  Moto moto = (Moto) vehicule; // ERREUR

Le code précédent compile puisque le développeur déclare explicitement le downcasting.
Cependant, l'affectation à la ligne 3 est erronée puisque la variable *vehicule*
référence une instance de *Voiture* que l'on veut affecter à une variable de type
*Moto*. Pour les types primitifs, un transtypage invalide conduit à une possible
perte de données. Par contre, pour des objets, un transtypage invalide génère à
l'exécution une erreur de type java.lang.ClassCastException_.

Le mot-clé instanceof
*********************

Il est possible de découvrir à l'exécution si une variable, un attribut ou un
paramètre est d'un type attendu, cela permet de contrôler les opérations de
downcasting et d'éviter des erreurs d'exécution. Pour cela, le mot-clé **instanceof**
retourne **true** si l'opérande à gauche est d'un type compatible avec l'opérande
à droite.

.. info

  Si l'opérande à gauche vaut **null**, **instanceof** retourne **false** pour tout
  type utilisé comme opérande à droite.

.. code-block:: java
  :linenos:

  Vehicule vehicule = new Voiture("DeLorean");

  if (vehicule instanceof Voiture) {
    Voiture voiture = (Voiture) vehicule;
    // ...
  }

  if (vehicule instanceof Moto) {
    Moto moto = (Moto) vehicule;
    // ...
  }

Le code ci-dessus s'exécutera sans erreur. À la ligne 8, comme la variable
*vehicule* ne référence pas un objet compatible avec le type *Moto*, **instanceof**
retournera **false**, empêchant ainsi le bloc de s'exécuter. Une opération de
downcasting devrait toujours être contrôlée par une expression **instanceof** et
le programme devrait être capable de se comporter correctement si l'instruction
**instanceof** retourne **false**.

.. caution::

  Si le recours à **instanceof** permet de rendre les applications plus robustes,
  il n'en reste pas moins que les opérations de downcasting doivent rester
  l'exception dans un programme. Un recours systématique au downcasting est souvent
  le signe d'une mauvaise conception objet.

.. _portee_protected:

La portée protected
*******************

Précédemment, nous avons introduit la classe *Vehicule* et nous avons pu l'utiliser
pour mutualiser la déclaration des attributs *vitesse* et *marque*. Ces attributs
ont été déclarés comme *private*. Donc ils ne sont accessibles que depuis la
classe *Vehicule*. Même si la classe *Voiture* hérite des attributs et des
méthodes de *Vehicule*, elles ne peut pas accéder aux attributs et aux méthodes
privés des classes parentes. Imaginons maintenant que nous souhaitons ajouter
la méthode *reculer*. Comme nous ne souhaitons pas fournir cette possibilité aux
objets de la classe *Moto*, nous voulons ajouter cette méthode uniquement à la
classe *Voiture*.

.. code-block:: java
  :emphasize-lines: 10

  package {{ROOT_PKG}}.conduite;

  public class Voiture extends Vehicule {

    public Voiture(String marque) {
      super(marque);
    }

    public void reculer(float vitesse) {
      this.vitesse = -vitesse;
    }

    // ...

  }

Le code précédent ne peut pas accéder à l'attribut *vitesse* déclaré dans la
classe parente car il a été déclaré avec une portée **private**.

En Java, il existe une quatrième portée : la portée **protected**. Les attributs
et les méthodes déclarés avec la portée **protected** sont accessibles par
les membres du même package et par les classes filles. Ainsi en modifiant
la déclaration de la classe *Vehicule* :

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

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

La classe *Voiture* pourra compiler car elle a maintenant accès à l'attribut
*vitesse*.

Le tableau ci-dessous résume toutes les portées en Java en les triant de la moins
restrictive à la plus restrictive.

.. csv-table:: Les portées en Java
  :header: "type", "mot-clé", "Description"
  :widths: 1,1,3

  Publique, **public**, "Accessible depuis n'importe quel point de l'application"
  Protégée, **protected**, "Accessible uniquement depuis les classes du même package et les classes filles"
  Package, , "Accessible uniquement depuis les classes du même package"
  Privée, **private**, "Accessible uniquement dans la classe de déclaration et les classes internes"

La portée **protected** pose parfois un soucis de conception. En effet, on pourrait
considérer que les portées de type privé et package sont inutiles et que tous
les attributs peuvent être déclarés avec la portée *protected*. Cependant,
en programmation objet, le `principe du ouvert/fermé`_ stipule qu'une classe devrait
être ouverte en extension mais fermée en modification. Cela signifie que par
héritage, les développeurs doivent pouvoir étendre les fonctionnalités d'une
classe en créant un sous-type mais ne doivent pas pouvoir modifier
significativement le comportement de la classe parente. Empêcher une sous-classe
de modifier l'état d'un attribut en le déclarant **private** est une bonne
façon d'éviter aux développeurs d'une sous-classe de modifier involontairement
le comportement d'une classe.

Un règle simple consiste à systématiquement déclarer **private** les attributs
d'une classe sauf si une raison évidente nous suggère de déclarer la portée
**protected**.

.. note::

  Dans l'exemple précédent, la déclaration de l'attribut *vitesse* comme
  **protected** est peu satisfaisante car toutes les classes filles ont maintenant
  accès à cet attribut : cela n'est pas conforme au `principe du ouvert/fermé`_.
  Nous verrons au :ref:`chapitre suivant <redefinition_et_signature>` qu'il existe une
  solution qui évite de modifier la portée de cet attribut.

.. note::

  Le `principe du ouvert/fermé`_ (Open/close principle) représente le O dans
  l'acronyme SOLID_. Cet acronyme rassemble cinq notions fondamentales dans
  la conception objet.


Héritage des méthodes et attributs de classe
********************************************

Comme leur nom l'indique, les méthodes et les attributs de classe appartiennent
à une classe. Il est possible d'accéder à une méthode de classe par la classe
dans laquelle la méthode a été déclarée ou par n'importe quelle classe qui en
hérite. Il en va de même pour les attributs de classe. Attention cependant,
si l'attribut de classe est modifiable, sa valeur est partagée par l'ensemble
des classes qui font partie de la hiérarchie d'héritage.

Un exemple classique est l'implémentation d'un compteur qui permet de savoir
combien d'instances ont été créées. Il suffit de créer un compteur comme
attribut de classe.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Vehicule {

    private static int nbInstances = 0;

    private final String marque;
    private float vitesse;

    public Vehicule(String marque) {
      ++Vehicule.nbInstances;
      this.marque = marque;
    }

    public static int getNbInstances() {
      return nbInstances;
    }

    // ...
  }

Dans l'exemple précédent, nous avons ajouté l'attribut de classe *nbInstances*
et la méthode de classe *getNbInstances*. L'attribut de classe est un compteur
qui est incrémenté à chaque fois que le constructeur de *Vehicule* est appelé.


.. code-block:: java

  Voiture voiture = new Voiture("DeLorean");

  Moto moto = new Moto("Kaneda");

  System.out.println(Vehicule.getNbInstances()); // 2
  System.out.println(Voiture.getNbInstances());  // 2
  System.out.println(Moto.getNbInstances());     // 2


Dans l'exemple ci-dessus, la création d'une instance de *Voiture* et d'une
instance de *Moto* incrémente le compteur *nbInstances*. L'appel à la méthode
*getNbInstances* retournera le chiffre 2 quelle que soit la classe utilisée
pour invoquer cette méthode. On voit ici, qu'il est parfois important, pour
des raisons de lisibilité, d'utiliser la classe dans laquelle la méthode a été
déclarée pour l'invoquer. En effet, une lecture rapide du code, pourrait nous
faire croire que l'appel à *Voiture.getNbInstances* retourne le nombre
d'instances de type *Voiture* créées alors qu'il s'agit du nombre d'instances
de type *Vehicule* (donc incluant les instances de *Moto*).


Héritage et final
*****************

En Java, il est possible de déclarer une classe **final**. Cela signifie
qu'il est impossible d'étendre cette classe.
Elle représente un élément terminal dans l'arborescence d'héritage.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public final class Moto extends Vehicule {

    public Moto(String marque) {
      super(marque);
    }

    // ...

  }


Dans l'exemple ci-dessus, la classe *Moto* est déclarée **final**. Donc il
est maintenant impossible de déclarer une classe qui étende la classe *Moto*.

En raison de son impact très fort, la déclaration d'une classe comme **final**
est réservée à des cas très particuliers. Un exemple est la classe
java.lang.String_. Cette classe est déclarée **final**. Il est donc impossible
en Java de créer une classe qui hérite de java.lang.String_. Les développeurs de
l'API standard ont jugé qu'en raison de son importance, cette classe devait être
fermée en extension afin d'éviter toute modification de comportement par héritage.


La composition (has-a)
**********************

La composition est le type de relation le plus souvent utilisé en programmation
objet. Elle indique une dépendance entre deux classes. L'une a besoin des
services d'une autre pour réaliser sa fonction. La composition se fait en déclarant
des attributs dans la classe.

Dans notre application de simulation de conduite, si nous introduisons une
classe pour représenter des pneus.

.. image:: images/heritage/composition_vehicule_pneu.png

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Pneu {

    private float coefficientAdherence;

    // ..

  }


Alors, nous pouvons indiquer que les véhicules **ont des** pneus.

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Vehicule {

    private final String marque;
    protected float vitesse;
    protected Pneu[] pneus;

    public Vehicule(String marque) {
      this.marque = marque;
    }

    public Pneu[] getPneus() {
      return this.pneus;
    }

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Voiture extends Vehicule {

    public Voiture(String marque) {
      super(marque);
      this.pneus = new Pneu[] {new Pneu(), new Pneu(), new Pneu(), new Pneu()};
    }

    // ...

  }

.. code-block:: java

  package {{ROOT_PKG}}.conduite;

  public class Moto extends Vehicule {

    public Moto(String marque) {
      super(marque);
      this.pneus = new Pneu[] {new Pneu(), new Pneu()};
    }

    // ...

  }


.. _Object: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html
.. _toString: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#toString--
.. _equals: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#equals-java.lang.Object-
.. _java.lang.String: https://docs.oracle.com/javase/8/docs/api/java/lang/String.html
.. _java.lang.ClassCastException: https://docs.oracle.com/javase/8/docs/api/java/lang/ClassCastException.html
.. _SOLID: https://fr.wikipedia.org/wiki/SOLID_(informatique)
.. _Liskov substitution principle: https://fr.wikipedia.org/wiki/Principe_de_substitution_de_Liskov
.. _principe de substitution de Liskov: https://fr.wikipedia.org/wiki/Principe_de_substitution_de_Liskov
.. _principe du ouvert/fermé: https://fr.wikipedia.org/wiki/Principe_ouvert/ferm%C3%A9
