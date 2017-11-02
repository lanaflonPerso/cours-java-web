Les génériques
##############

Parfois, on souhaite créer une classe qui est liée très fortement à un autre type.
C'est souvent le cas quand la classe sert de conteneur à un autre type.

L'exemple de la classe ArrayList
********************************

En Java, l'API standard fournit un ensemble de classes que l'on appelle couramment
les collections. Ces classes permettent de gérer un ensemble d'objets. Elles apportent
des fonctionnalités plus avancées que les tableaux. Par exemple la classe java.util.ArrayList_
permet de gérer une liste d'objets. Cette classe autorise l'ajout en fin de liste,
l'insertion, la suppression et bien évidemment l'accès à un élément selon son index
et le parcours.

.. code-block:: java
  :emphasize-lines: 15,16
   
  package ROOT_PKG;

  import java.util.ArrayList;

  public class TestArrayList {
    
    public static void main(String[] args) {
      ArrayList list = new ArrayList();
      
      list.add("bonjour le monde");
      list.add(1); // boxing ! list.add(Integer.valueOf(1));
      list.add(new Object());
      
      String s1 = (String) list.get(0);
      String s2 = (String) list.get(1); // ERREUR à l'execution : ClassCastException
      String s3 = (String) list.get(2); // ERREUR à l'execution : ClassCastException
    }

  }

Avec la classe ArrayList_, on peut ajouter des éléments avec la méthode
ArrayList.add_ et accéder à un élément selon son index avec la méthode ArrayList.get_.
Dans l'exemple précédent, on voit que cela n'est pas sans risque. En effet, un objet de
type ArrayList_ peut contenir tout type d'objet. Donc quand le programme accède à un élément
d'une instance de ArrayList_, il doit réaliser explicitement un trans-typage (*cast*) avec le risque
que cela suppose de se tromper de type. Ce type de classe exige donc beaucoup de rigueur
d'utilisation pour les développeurs.

Une situation plus simple serait de pouvoir déclarer en tant que développeur qu'une instance
de ArrayList_ se limite à un type d'éléments : par exemple au type String_. Ainsi le 
compilateur pourrait signaler une erreur si le programme tente d'ajouter un élément qui n'est
pas compatible avec le type String_ ou s'il veut récupérer un élément dans un variable qui
n'est pas d'un type compatible. Les génériques permettent de gérer ce type de situation.
Ils sont une aide pour les développeurs pour écrire des programmes plus robustes.

La classe ArrayList_ est justement une classe générique. Il est possible, par
exemple, de déclarer qu'une instance est une liste de chaîne de caractères :

::

  ArrayList<String> list = new ArrayList<String>();

On ajoute entre les signes **<** et **>** le type géré par la liste. À partir
de cette information, le compilateur va pouvoir nous aider à résoudre les ambiguïtés.
Il peut maintenant déterminer si un élément peut être ajouté ou référencé par 
une variable sans nécessiter un trans-typage explicite du développeur.

::

  list.add("bonjour");
  String s = list.get(0); // l'opération de trans-typage n'est plus nécessaire

Par contre :

::

  list.add(1); // Erreur de compilation type String attendu

  Object o = "je suis une chaîne affectée à une variable de type Object";
  list.add(o); // Erreur de compilation : type String attendu
  
  Voiture v = (Voiture) list.get(0); // Erreur de compilation Voiture n'hérite pas de String

Pour les génériques, le principe de substitution s'applique. Comme la classe String_
hérite de la classe Object_, il est possible de récupérer un élément de ma liste
dans une variable de type Object_ :

::

  Object o = list.get(0); // OK



.. todo::

  * Pourquoi les génériques : les classes de qqchose (liste de, facture de, conteneur de)
  * Le cas de la classe ArrayList
  * utiliser des génériques (la notation en diamand pour l'initialisation)
  * Les règles de typage pour l'affectation et les paramètres (ArrayList<T> -> ArrayList<V>)
  * écrire des méthodes génériques (paramètres et type de retour)
  * écrire des classes génériques
  * Bounded type <T extends XXX> <T super XXX>
  * ? le caractère générique
  * Limitation : instanceof, pas d'instanciation générique
  * le cas du @SuppressWarnings
  
.. _java.util.ArrayList: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html 
.. _ArrayList: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
.. _ArrayList.add: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#add-E-
.. _ArrayList.get: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#get-int-
.. _String: https://docs.oracle.com/javase/8/docs/api/java/lang/String.html
.. _Object: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html
