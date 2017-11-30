Les collections
###############

Lors d'un :doc:`chapitre précédent </tableau>`, nous avons vu qu'il est possible
de déclarer des tableaux en Java pour gérer un ensemble d'éléments. Cependant, 
ce type de structure reste limité : un tableau a une taille fixe (il est impossible
d'ajouter ou d'enlever des éléments d'un tableau). De plus, il est souvent utile
de disposer d'autres structures de données pour gérer des groupes d'éléments.

On appelle *collections* un ensemble de classes et d'interfaces fournies par
l'API standard et disponibles pour la plupart dans le package java.util_. 
Parmi ces collections, on trouve les listes (*lists*), les ensembles (*sets*) et
les tableaux associatifs (*maps*). Elles forment ce que l'on appelle le 
`Java Collections Framework`_.

Toutes ces classes et interfaces sont génériques. Il n'est donc possible que de créer
des collections d'objets. Si vous souhaitez créer une collection pour un type
primitif, vous devez utiliser la classe enveloppe correspondante (par exemple
Integer_ pour **int**).

Les listes
**********

Une liste est une collection ordonnée d'éléments. Il existe différentes façons
d'implémenter des listes selon que l'on veut privilégier les performances pour 
les accès aléatoires aux éléments ou les opérations d'insertion et de suppression
d'éléments dans la liste.

Java propose plusieurs classes d'implémentation pour les listes selon les besoins
de performance. Comme toutes ces classes implémentent des interfaces communes,
il est conseillé de manipuler les instances de ces classes uniquement à travers
des variables du type de l'interface adaptée : Collection_, List_, Queue_ 
ou Deque_.

L'interface Collection_ dont hérite toutes les autres interfaces pour les listes,
hérite elle-même de Iterable_. Cela signifie que toutes les classes et toutes
les interfaces servant à représenter des listes dans le `Java Collections Framework`_
peuvent être parcourues avec une structure de **for** amélioré (*foreach*).

La classe ArrayList
===================

La classe java.util.ArrayList_ est une implémentation de l'interface List_. Elle
stocke les éléments de la liste sous la forme de blocs en mémoire. Cela signifie
que la classe ArrayList_ est très performante pour les accès aléatoire en lecture
aux éléments de la liste. Par contre, les opérations d'ajout et de suppression
d'un élement se font en temps linéaire. Elle est donc moins performante que la
classe LinkedList_ sur ce point.

::

  List<String> liste = new ArrayList<String>();
  
  liste.add("une première chaîne");
  liste.add("une troisième chaîne");
  
  System.out.println(liste.size()); // 2
  
  // insertion d'un élément
  liste.add(1, "une seconde chaîne");

  System.out.println(liste.size()); // 3
  
  for (String s : liste) {
    System.out.println(s);
  }
  
  String premierElement = liste.get(0);
  
  System.out.println(liste.contains("une première chaîne")); // true
  System.out.println(liste.contains("quelque chose qui n'est pas dans la liste")); // false
  
  // suppression du dernier élément de la liste
  liste.remove(liste.size() - 1);
  
  // ajout de tous les éléments d'une autre liste à la fin de la liste
  liste.addAll(Arrays.asList("une autre chaîne", "et encore une autre chaîne"));

  System.out.println(liste.size()); // 4
  
  // [une première chaîne, une seconde chaîne, une autre chaîne, et encore une autre chaîne]
  System.out.println(liste);

Il est possible de réserver de l'espace mémoire pour une liste pouvant contenir
n éléments. Pour cela, on peut passer la taille voulue à la création d'une
instance de ArrayList_ ou en appelant la méthode ArrayList.ensureCapacity_.
La liste ne change pas de taille pour autant, un espace mémoire est simplement
alloué en prévision.

::

  // capacité de 10
  ArrayList<String> liste = new ArrayList<String>(10);

  // capacité d'au moins 100
  liste.ensureCapacity(100);

  System.out.println(liste.size()); // 0

  
La classe LinkedList
====================

La classe java.util.LinkedList_ est une implémentation de l'interface List_.
Sa représentation interne est une liste doublement chaînée. Cela signifie que
la classe LinkedList_ est très performante pour les opérations d'insertion et
de suppression d'éléments. Par contre, l'accès aléatoire en lecture aux éléments
se fait en temps linéaire. Elle est donc moins performante que la classe
ArrayList_ sur ce point.

::

  List<String> liste = new LinkedList<String>();

  
  liste.add("une première chaîne");
  liste.add("une troisième chaîne");
  
  System.out.println(liste.size()); // 2
  
  // insertion d'un élément
  liste.add(1, "une seconde chaîne");

  System.out.println(liste.size()); // 3
  
  for (String s : liste) {
    System.out.println(s);
  }
  
  String premierElement = liste.get(0);
  
  System.out.println(liste.contains("une première chaîne")); // true
  System.out.println(liste.contains("quelque chose qui n'est pas dans la liste")); // false
  
  // suppression du dernier élément de la liste
  liste.remove(liste.size() - 1);
  
  // ajout de tous les éléments d'une autre liste à la fin de la liste
  liste.addAll(Arrays.asList("une autre chaîne", "et encore une autre chaîne"));

  System.out.println(liste.size()); // 4
  System.out.println(liste);
  
La classe LinkedList_ implémente également les interfaces Queue_ et Deque_ (*double
ended queue*), elle peut donc représenter des structures
de type LIFO (*Last In First Out*) ou FIFO (*First In First Out*).

::

  Queue<String> queue = new LinkedList<String>();
  
  // insère un élément dans la file
  queue.offer("un élément");
  
  // lit l'élément en tête de la file sans l'enlever de la file
  System.out.println(queue.peek()); // "un élément"
  // lit l'élément en tête de la file et l'enleve de la file
  System.out.println(queue.poll()); // "un élément"
  
  System.out.println(queue.isEmpty()); // true

::

  Deque<String> deque = new LinkedList<String>();

  // empile deux éléments
  deque.push("élément 1");
  deque.push("élément 2");

  // lit le premier élément de la file sans l'enlever
  System.out.println(deque.peekFirst()); // élément 2
  // lit le dernier élément de la file sans l'enlever
  System.out.println(deque.peekLast()); // élément 1
  // lit l'élément de tête de la file sans l'enlever
  System.out.println(deque.peek()); // élément 2
  // lit l'élément de tête de la file et l'enlève
  System.out.println(deque.pop()); // élément 2
  System.out.println(deque.pop()); // élément 1
  
  System.out.println(deque.isEmpty()); // true

La classe ArrayDeque
====================

La classe java.util.ArrayDeque_ est une implémentation des interfaces Queue_ et 
Deque_ (mais elle **n'implémente pas** List_). Elle est conçue pour être plus 
performante que LinkedList_ pour les opérations d'ajout et de suppression en tête
et en fin de liste. Si vous voulez utiliser une collection uniquement pour 
représenter une file ou une pile de type LIFO (*Last In First Out*) ou FIFO 
(*First In First Out*), alors il est préférable de créer une instance de la classe
ArrayDeque_.

::

  Queue<String> queue = new ArrayDeque<String>();
  
  // insère un élément dans la file
  queue.offer("un élément");
  
  // lit l'élément en tête de la file sans l'enlever de la file
  System.out.println(queue.peek()); // "un élément"
  // lit l'élément en tête de la file et l'enleve de la file
  System.out.println(queue.poll()); // "un élément"
  
  System.out.println(queue.isEmpty()); // true

  
::

  Deque<String> deque = new ArrayDeque<String>();

  // empile deux éléments
  deque.push("élément 1");
  deque.push("élément 2");

  // lit le premier élément de la file sans l'enlever
  System.out.println(deque.peekFirst()); // élément 2
  // lit le dernier élément de la file sans l'enlever
  System.out.println(deque.peekLast()); // élément 1
  // lit l'élément de tête de la file sans l'enlever
  System.out.println(deque.peek()); // élément 2
  // lit l'élément de tête de la file et l'enlève
  System.out.println(deque.pop()); // élément 2
  System.out.println(deque.pop()); // élément 1
  
  System.out.println(deque.isEmpty()); // true

Comme pour la classe ArrayList_, il est possible de réserver un espace mémoire
pour n éléments au moment de la création d'une instance de ArrayDeque.

::

  // Assurer une capacité minimale de 100 éléments
  ArrayDeque<String> arrayDeque = new ArrayDeque<>(100);
  
  System.out.println(arrayDeque.size()); // 0


La classe PriorityQueue
=======================

La classe java.util.PriorityQueue_ permet d'ajouter des éléments dans une file
selon un ordre naturel : soit parce que les éléments de la file implémentent l'interface
Comparable_, soit parce qu'une instance de Comparator_ a été fournie à la création
de l'instance de PriorityQueue_. Quel que soit l'ordre d'insertion, les éléments
seront extraits de la file selon l'ordre naturel.

::

  Queue<String> queue = new PriorityQueue<>();
  
  queue.add("i");
  queue.add("e");
  queue.add("u");
  queue.add("o");
  queue.add("a");
  queue.add("y");
  
  System.out.println(queue.poll()); // a
  System.out.println(queue.poll()); // e
  System.out.println(queue.poll()); // i
  System.out.println(queue.poll()); // o
  System.out.println(queue.poll()); // u
  System.out.println(queue.poll()); // y
  
.. caution::

  La classe PriorityQueue ne garantit pas que l'ordre naturel sera respecté
  si on parcourt la file à l'aide d'un **for**.

Les classes Vector et Stack
===========================

La version 1.0 de Java a d'abord inclus les classes java.util.Vector_ et java.util.Stack_.
La classe Vector_ permet de représenter une liste d'éléments comme la classe ArrayList_.
La classe Stack_ qui hérite de Vector_ permet de représenter des piles de type 
LIFO (*Last In First Out*). Ces deux classes sont toujours présentes dans
l'API pour des raisons de compatibilité ascendante mais il ne faut **surtout pas**
s'en servir. En effet, ces classes utilisent des mécanismes de synchronisation
internes dans le cas où elles sont utilisées pour des accès concurrents 
(programmation parallèle ou *multithread*). Or, non seulement ces mécanismes
de synchronisation pénalisent les performances mais en plus, ils se révèlent
largement inefficaces pour gérer les accès concurrents (il existe d'autres façons
de faire en Java).

Les classes ArrayList_ et ArrayDeque_ se substituent très bien aux classes
Vector_ et Stack_.

Les interfaces pour les listes
==============================

Les listes du `Java Collections Framework`_ sont liées aux interfaces Iterable_,
Collection_, List_, Queue_, Deque_ et RandomAccess_. Ci-dessous le diagramme
de classes présentant les différents héritages et implémentations pour les quatre
principales classes :

.. image:: images/collections/list_classes_interfaces.png

Comme proposé par le `principe de ségrégation d'interface`_, les variables,
les paramètres et les attributs représentant des listes devraient avoir le
type de l'interface adaptée. Par exemple, si vous utilisez une instance de PriorityQueue_,
vous devriez y accéder à partir de l'interface Queue_ si vous n'effectuez que
des opérations d'ajout, de suppression ou de consultation des éléments.

Iterable_
  Cette interface permet d'obtenir un Iterator_ pour parcourir la liste. Elle
  permet également de parcourir la liste avec un **for** amélioré (*foreach*).
  
Collection_
  Il s'agit de l'interface racine pour les collections. Elle déclare beaucoup de méthodes
  pour consulter ou modifier une collection. C'est également cette interface
  qui déclare la méthode size_ pour connaître la taille de la collection et les
  méthodes toArray_ pour obtenir un tableau à partir d'une collection. Par contre,
  cette interface ne permet pas d'accéder aléatoirement à un élément d'une collection
  (c'est-à-dire à partir de son index).

List_
  Cette interface représente une collection ordonnée (une séquence) d'éléments.
  Elle déclare des méthodes pour accéder, pour modifier ou pour supprimer des
  éléments à partir de leur index (on parle aussi d'accès aléatoire). Cette
  interface déclare également la méthode sort_ pour permettre de trier la liste.

Queue_
  Une file (*queue*) est une structure de données pour laquelle l'ordre des éléments
  est important mais les opérations de consultation, d'ajout et de suppression se 
  font uniquement sur la tête de la file (le premier élément).
  
Deque_
  Deque_ est la contraction de *double ended queue*. Cette interface représente une structure
  de données pour laquelle l'ordre des éléments est important mais les opération
  des consultation, d'ajout et de suppression se font soit sur le premier élément
  soit sur le dernier élément.
  
RandomAccess_
  Il s'agit d'une :ref:`interface marqueur <interface_marqueur>` qui signale que
  l'implémentation associée supporte les accès aléatoire en un temps constant. Par
  exemple, ArrayList_ implémente RandomAccess_ mais pas LinkedList_. Cette interface
  existe avant tout pour des raisons d'optimisation de parcours de liste.


Les ensembles (set)
*******************

Les ensembles (*set*) sont des collections qui ne contiennent aucune doublon.
Deux élements e1 et e2 sont des doublons si :

::

  e1.equals(e2) == true
  
ou si e1 vaut **null** et e2 vaut **null**. Pour contrôler l'unicité, le
`Java Collections Framework`_ fournit trois implémentations : TreeSet_, 
HashSet_ et LinkedHashSet_.

.. note::

  Il existe également un EnumSet_ qui représente un ensemble d'énumérations. Son
  implémentation est très compacte et très performante mais n'est utilisable que
  pour des :doc:`énumérations <enumeration>`.

La classe TreeSet
=================

La classe TreeSet_ contrôle l'unicité de ces éléments en maintenant en interne
une liste triée par ordre naturel des éléments. L'ordre peut être donné soit
parce que les éléments implémentent l'interface Comparable_ soit parce qu'une
implémentation de Comparator_ est passée en paramètre de constructeur au moment
de la création de l'instance de TreeSet_.

::

  Set<String> ensemble = new TreeSet<String>();
  
  ensemble.add("élément");
  ensemble.add("élément");
  ensemble.add("élément");
  ensemble.add("élément");
  
  System.out.println(ensemble.size()); // 1

  ensemble.remove("élément");
 
  System.out.println(ensemble.isEmpty()); // true
  
La classe TreeSet_ a donc comme particularité de toujours conserver ses éléments
triés.

La classe HashSet
=================

La classe HashSet_ utilise un code de hachage (hash code) pour contrôler l'unicité
de ces éléments. Un code de hachage est une valeur associée à objet. Deux
objets identiques doivent obligatoirement avoir le même code de hachage. Par contre
deux objets distincts ont des codes de hachage qui peuvent être soit différents
soit identiques. Un ensemble d'éléments différents mais qui ont néanmoins le 
même code de hachage forment un *bucket*. La classe HashSet_ maintient en interne
un tableau associatif entre une valeur de hachage et un *bucket*. Lorsqu'un nouvel
élément est ajouté au HashSet_, ce dernier calcule son code de hachage et vérifie
si cette valeur a déjà été stockée. Si c'est le cas, alors les éléments du 
*bucket* associé sont parcourus un à un pour vérifier s'ils sont identiques
ou non au nouvel élément.

.. note::

  Le code de hachage d'un objet est donné par la méthode Object.hashCode_. 
  L'implémentation par défaut de cette méthode ne convient généralement pas. En 
  effet, elle retourne un code différent pour des objets différents en mémoire.
  Deux objets qui ont un état considéré comme identique mais qui existent de
  manière distincte en mémoire auront un code de hachage différent si on utilise l'implémentation
  par défaut. Beaucoup de classes surchargent donc cette méthode (c'est notamment le
  cas de la classe String_).

::

  Set<String> ensemble = new HashSet<String>();
  
  ensemble.add("élément");
  ensemble.add("élément");
  ensemble.add("élément");
  ensemble.add("élément");
  
  System.out.println(ensemble.size()); // 1

  ensemble.remove("élément");
 
  System.out.println(ensemble.isEmpty()); // true


L'implémentation de la classe HashSet_ a des performances en temps très supérieures 
à TreeSet_ pour les opérations d'ajout et de suppression d'élément.
Elle impose néanmoins que les éléments qu'elle contient génèrent correctement
un code de hachage avec la méthode hashCode_. Contrairement à TreeSet_, elle
ne garantit pas l'ordre dans lequel les éléments sont stockés et donc l'ordre dans
lequel ils peuvent être parcourus.

La classe LinkedHashSet
=======================

La classe LinkedHashSet_, comme la classe HashSet_, utilise en interne un code
de hachage mais elle garantit en plus que l'ordre de parcours des éléments sera le
même que l'ordre d'insertion. Cette implémentation garantit également que si 
elle est créée à partir d'un autre Set_, l'ordre des éléments sera maintenu.

::

  Set<String> ensemble = new LinkedHashSet<String>();
  
  ensemble.add("premier élément");
  ensemble.add("premier élément");
  ensemble.add("premier élément");
  ensemble.add("premier élément");

  ensemble.add("deuxième élément");
  
  ensemble.add("premier élément");
  
  ensemble.add("troisième élément");
  
  ensemble.add("premier élément");
  
  // [premier élément, deuxième élément, troisième élément]
  System.out.println(ensemble);

La classe LinkedHashSet_ a été créée pour réaliser un compromis entre la classe
HashSet_ et la classe TreeSet_ afin d'avoir des performances proches de la première
tout en offrant l'ordre de parcours pour ses éléments.

Les interfaces pour les ensembles
=================================

Les ensembles du `Java Collections Framework`_ sont liés aux interfaces Iterable_,
Collection_, Set_, SortedSet_ et NavigableSet_. Ci-dessous le diagramme
de classes présentant les différents héritages et implémentations pour les trois
principales classes :

.. image:: images/collections/set_classes_interfaces.png

Comme proposé par le `principe de ségrégation d'interface`_, les variables,
les paramètres et les attributs représentant des ensemble devraient avoir le
type de l'interface adaptée. Par exemple, si vous utilisez une instance de HashSet_,
vous devriez y accéder à partir de l'interface Set_.

Iterable_
  Cette interface permet d'obtenir un Iterator_ pour parcourir la liste. Elle
  permet également de parcourir l'ensemble avec un **for** amélioré (*foreach*).
  
Collection_
  Il s'agit de l'interface racine pour les collections. Elle déclare beaucoup de méthodes
  pour consulter ou modifier une collection. C'est également cette interface
  qui déclare la méthode size_ pour connaître la taille de la collection et les
  méthodes toArray_ pour obtenir un tableau à partir d'une collection.

Set_
  Il s'agit de l'interface qui définit la collection comme un ensemble, c'est-à-dire
  comme une liste d'éléments sans doublon.
  
SortedSet_
  Cette interface indique que l'ensemble maintient en interne un ordre naturel
  de ses éléments. Elle offre notamment des méthodes pour accéder au premier et
  au dernier élément de l'ensemble.
  
NavigableSet_
  Cette interface déclare des méthodes de navigation permettant par exemple
  de créer un sous ensemble à partir des éléments qui sont plus grands qu'un
  élément donné.
  
Copie d'une collection dans un tableau
**************************************

L'interface Collection_ commune aux listes et aux ensembles déclare deux
méthodes qui permettent de copier les références des éléments d'une collection
dans un tableau :

`toArray()`_
  Crée une nouvelle instance d'un tableau d'Object de la même taille que la collection et
  copie les références des éléments de la collection dans ce tableau.
  
`toArray(T[])`_
  Si le tableau passé en paramètre est suffisamment grand pour contenir les éléments
  de la collection, alors les références y sont copiées. Sinon un tableau du même
  type que celui passé en paramètre est créé et les références des éléments
  de la collection y sont copiées.
  
::

  Collection<String> collection = new ArrayList<>();
  collection.add("un");
  collection.add("deux");
  collection.add("trois");
  
  Object[] tableauObjet = collection.toArray();
  
  String[] tableauString = collection.toArray(new String[0]);
  
  String[] autreTableauString = new String[collection.size()];
  String[] memeTableauString = collection.toArray(autreTableauString);
  
  // Tous les tableaux contiennent les mêmes éléments
  System.out.println(Arrays.equals(tableauObjet, tableauString)); // true
  System.out.println(Arrays.equals(tableauObjet, autreTableauString)); // true
  System.out.println(Arrays.equals(tableauObjet, memeTableauString)); // true
  
  // Les variables référencent le même tableau
  System.out.println(autreTableauString == memeTableauString); // true


Les tableaux associatifs (maps)
*******************************

Un tableau associatif (parfois appelé dictionnaire) ou *map* permet d'associer
une clé à une valeur. Un tableau associatif ne peut pas contenir de doublon
de clés.

Les classes et les interfaces représentant des tableaux associatifs sont génériques
et permettent de spécifier un type pour la clé et un type pour la valeur. Le
`Java Collections Framework`_ fournit plusieurs implémentations de tableaux
associatifs : TreeMap_, HashMap_, LinkedHashMap_.

.. note::

  La classe EnumMap_ qui représente un tableau associatif dont les clés sont
  des énumérations. Son implémentation est très compacte et très performante 
  mais n'est utilisable que pour des clés de type :doc:`énumération <enumeration>`.
  
La classe TreeMap
=================

La classe TreeMap_ est basée sur l'implémentation d'un arbre bicolore pour déterminer
si une clé existe ou non dans le tableau associatif. Elle dispose d'une bonne
performance en temps pour les opérations d'accès, d'ajout et de suppression de la 
clé.

Cette classe contrôle l'unicité et l'accès à la clé en maintenant en interne
une liste triée par ordre naturel des clés. L'ordre peut être donné soit
parce que les éléments implémentent l'interface Comparable_ soit parce qu'une
implémentation de Comparator_ est passée en paramètre de constructeur au moment
de la création de l'instance de TreeMap_.

::

  Map<String, Integer> tableauAssociatif = new TreeMap<>();
  tableauAssociatif.put("un", 1);
  tableauAssociatif.put("deux", 2);
  tableauAssociatif.put("trois", 3);
  
  System.out.println(tableauAssociatif.get("deux")); // 2
  
  int resultat = 0;
  for (String s : "un deux trois".split(" ")) {
    resultat += tableauAssociatif.get(s);
  }
  
  System.out.println(resultat); // 6
  
  tableauAssociatif.remove("trois");
  tableauAssociatif.put("deux", 1000);
  
  System.out.println(tableauAssociatif.keySet()); // [deux, un]
  System.out.println(tableauAssociatif.values()); // [1000, 1]

  
La classe TreeMap_ a donc comme particularité de conserver toujours ses clés
triées.

La classe HashMap
=================

La classe HashMap_ utilise un code de hachage (hash code) pour contrôler l'unicité
et l'accès aux clés. Un code de hachage est une valeur associée à un objet. Deux
objets identiques doivent obligatoirement avoir le même code de hachage. Par contre
deux objets distincts ont des codes de hachage qui peuvent être soit différents
soit identiques. Un ensemble de clés différentes mais qui ont néanmoins le 
même code de hachage forment un *bucket*. La classe HashMap_ maintient en interne
un tableau associatif entre une valeur de hachage et un *bucket*. Lorsqu'une nouvelle
clé est ajoutée au HashMap_, ce dernier calcule son code de hachage et vérifie
si ce code a déjà été stocké. Si c'est le cas, alors la valeur passée remplace
l'ancienne valeur associée à cette clé. Sinon la nouvelle clé est ajoutée avec
sa valeur.

.. note::

  Le code de hachage d'un objet est donné par la méthode Object.hashCode_. 
  L'implémentation par défaut de cette méthode ne convient généralement pas. En 
  effet, elle retourne un code différent pour des objets différents en mémoire.
  Deux objets qui ont un état considéré comme identique mais qui existent de
  manière distincte en mémoire auront un code de hachage différent si on utilise l'implémentation
  par défaut. Beaucoup de classes surchargent donc cette méthode (c'est notamment le
  cas de la classe String_).

::

  Map<String, Integer> tableauAssociatif = new HashMap<>();
  tableauAssociatif.put("un", 1);
  tableauAssociatif.put("deux", 2);
  tableauAssociatif.put("trois", 3);
  
  System.out.println(tableauAssociatif.get("deux")); // 2
  
  int resultat = 0;
  for (String s : "un deux trois".split(" ")) {
    resultat += tableauAssociatif.get(s);
  }
  
  System.out.println(resultat); // 6
  
  tableauAssociatif.remove("trois");
  tableauAssociatif.put("deux", 1000);
  
  System.out.println(tableauAssociatif.keySet()); // [deux, un]
  System.out.println(tableauAssociatif.values()); // [1, 1000]


L'implémentation de la classe HashSet_ a des performances en temps supérieures 
à TreeSet_ pour les opérations d'ajout et d'accès.
Elle impose néanmoins que les éléments qu'elle contient génèrent correctement
un code de hachage avec la méthode hashCode_. Contrairement à la classe TreeMap_, elle
ne garantit pas l'ordre dans lequel les clés sont stockées et donc l'ordre dans
lequel elles peuvent être parcourues.

La classe LinkedHashMap
=======================

La classe LinkedHashMap_, comme la classe HashMap_, utilise en interne un code
de hachage mais elle garantit en plus que l'ordre de parcours des clés sera le
même que l'ordre d'insertion. Cette implémentation garantit également que si 
elle est créée à partir d'une autre Map_, l'ordre des clés sera maintenu.

::

  Map<String, Integer> tableauAssociatif = new LinkedHashMap<>();
  tableauAssociatif.put("rouge", 0xff0000);
  tableauAssociatif.put("vert", 0x00ff00);
  tableauAssociatif.put("bleu", 0x0000ff);
  
  // affichera : rouge puis vert puis bleu
  for (String k: tableauAssociatif.keySet()) {
    System.out.println(k);
  }

La classe LinkedHashMap_ a été créée pour réaliser un compromis entre la classe
HashMap_ et la classe TreeMap_ afin d'avoir des performances proches de la première
tout en offrant l'ordre de parcours pour ses clés.


Les classes Dictionary et Hashtable
===================================
  
La version 1.0 de Java a d'abord inclus les classes java.util.Dictionary_ et 
java.util.Hashtable_ pour représenter des tableaux associatifs. 
Ces deux classes sont toujours présentent dans
l'API pour des raisons de compatibilité ascendante mais il ne faut **surtout pas**
s'en servir. En effet, ces classes utilisent des mécanismes de synchronisation
internes dans le cas où elles sont utilisées pour des accès concurrents 
(programmation parallèle ou *multithread*). Or, non seulement ces mécanismes
de synchronisation pénalisent les performances mais en plus, ils se révèlent
largement inefficaces pour gérer les accès concurrents (il existe d'autres façons
de faire en Java).

Les interfaces pour les tableaux associatifs
============================================

Les tableaux associatifs du `Java Collections Framework`_ sont liés aux interfaces 
Map_, SortedMap_ et NavigableMap_. Ci-dessous le diagramme
de classes présentant les différents héritages et implémentations pour les trois
principales classes :

.. image:: images/collections/map_classes_interfaces.png

Comme proposé par le `principe de ségrégation d'interface`_, les variables,
les paramètres et les attributs représentant des tableaux associatifs devraient avoir
le type de l'interface adaptée. Par exemple, si vous utilisez une instance de HashMap_,
vous devriez y accéder à partir de l'interface Map_.

Map_
  Il s'agit de l'interface qui définit un tableau associatif. Elle déclare
  les méthodes d'ajout de clé et de valeur, de consultation et de suppression
  à partir de la clé. Il est également possible d'obtenir l'ensemble des clés
  ou la collection de toutes les valeurs. Cette interface permet également
  de connaître la taille du tableau associatif.
  
SortedMap_
  Cette interface indique que le tableau associatif maintient en interne un ordre naturel
  de ses clés. Elle offre notamment des méthodes pour accéder à la première et
  à la dernière clé de l'ensemble.
  
NavigableMap_
  Cette interface déclare des méthodes de navigation permettant par exemple
  de créer un sous ensemble à partir des clés qui sont plus grandes qu'une
  clé donnée.

La classe outil Collections
***************************

La classe java.util.Collections_ est une classe outil qui contient de nombreuses
méthodes pour les listes, les ensembles et les tableaux associatifs. Elle contient
également des attributs de classes correspondant à une liste, un ensemble et
un tableau associatif vides et immutables.

.. code-block:: java
  :emphasize-lines: 41

  package ROOT_PKG;

  import java.util.ArrayList;
  import java.util.Collections;
  import java.util.List;

  public class TestCollections {

    public static void main(String[] args) {

      List<String> liste = new ArrayList<>();
      Collections.addAll(liste, "un", "deux", "trois", "quatre");

      // La chaîne a plus grande dans la liste : "un"
      String max = Collections.max(liste);
      System.out.println(max);

      // Inverse l'ordre de la liste
      Collections.reverse(liste);
      // [quatre, trois, deux, un]
      System.out.println(liste);

      // Trie la liste
      Collections.sort(liste);
      // [deux, quatre, trois, un]
      System.out.println(liste);

      // Recherche de l'index de la chaîne "deux" dans la liste triée : 0
      int index = Collections.binarySearch(liste, "deux");
      System.out.println(index);

      // Remplace tous les éléments par la même chaîne
      Collections.fill(liste, "même chaîne partout");
      // [même chaîne partout, même chaîne partout, même chaîne partout, même chaîne partout]
      System.out.println(liste);

      // Enveloppe la liste dans une liste qui n'autorise plus a modifier son contenu
      liste = Collections.unmodifiableList(liste);

      // On tente de modifier une liste qui n'est plus modifiable
      liste.add("Test"); // ERREUR à l'exécution : UnsupportedOperationException

    }

  }


.. only:: udev

  Exercice
  ********
  
  .. topic:: Ajout d'examen dans un diplôme
  
    Reprenez l'implémentation du système de gestion des diplômes des chapitres
    précédents.

    Dans la représentation interne de la classe *Diplome*, remplacez le tableau
    des examens pour un attribut de type List_.
    
    Pour la classe *Diplome*, ajoutez les méthodes suivantes :
    
    * une méthode pour ajouter un examen à un diplôme
    * une méthode pour retourner la liste des examens pour lesquels la note
      est inférieure à la valeur passée en paramètre. 
    * une méthode pour supprimer tous les examens dont le code correspond à la
      valeur passée en paramètre
      
    Écrivez un programme qui utilise ces nouvelles méthodes.


.. _Java Collections Framework: https://docs.oracle.com/javase/8/docs/technotes/guides/collections/index.html
.. _String: https://docs.oracle.com/javase/8/docs/api/java/lang/String.html
.. _Integer: https://docs.oracle.com/javase/8/docs/api/java/lang/Integer.html
.. _Iterable: https://docs.oracle.com/javase/8/docs/api/java/lang/Iterable.html
.. _Iterator: https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html
.. _Collection: https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html
.. _List: https://docs.oracle.com/javase/8/docs/api/java/util/List.html
.. _Queue: https://docs.oracle.com/javase/8/docs/api/java/util/Queue.html
.. _Deque: https://docs.oracle.com/javase/8/docs/api/java/util/Deque.html
.. _RandomAccess: https://docs.oracle.com/javase/8/docs/api/java/util/RandomAccess.html
.. _ArrayList: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
.. _PriorityQueue: https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html
.. _java.util.PriorityQueue: https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html
.. _LinkedList: https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html
.. _java.util.LinkedList: https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html
.. _ArrayDeque: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayDeque.html
.. _java.util.ArrayDeque: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayDeque.html
.. _Set: https://docs.oracle.com/javase/8/docs/api/java/util/Set.html
.. _SortedSet: https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html
.. _NavigableSet: https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html
.. _HashSet: https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html
.. _LinkedHashSet: https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashSet.html
.. _EnumSet: https://docs.oracle.com/javase/8/docs/api/java/util/EnumSet.html
.. _TreeSet: https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html
.. _java.util.ArrayList: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
.. _java.util.Vector: https://docs.oracle.com/javase/8/docs/api/java/util/Vector.html
.. _java.util.Stack: https://docs.oracle.com/javase/8/docs/api/java/util/Stack.html
.. _Vector: https://docs.oracle.com/javase/8/docs/api/java/util/Vector.html
.. _Stack: https://docs.oracle.com/javase/8/docs/api/java/util/Stack.html
.. _Map: https://docs.oracle.com/javase/8/docs/api/java/util/Map.html
.. _SortedMap: https://docs.oracle.com/javase/8/docs/api/java/util/SortedMap.html
.. _NavigableMap: https://docs.oracle.com/javase/8/docs/api/java/util/NavigableMap.html
.. _HashMap: https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html
.. _LinkedHashMap: https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashMap.html
.. _TreeMap: https://docs.oracle.com/javase/8/docs/api/java/util/TreeMap.html
.. _java.util.Dictionary: https://docs.oracle.com/javase/8/docs/api/java/util/Dictionary.html
.. _java.util.Hashtable: https://docs.oracle.com/javase/8/docs/api/java/util/Hashtable.html
.. _principe de ségrégation d'interface: https://en.wikipedia.org/wiki/Interface_segregation_principle
.. _Object.hashCode: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#hashCode--
.. _hashCode: https://docs.oracle.com/javase/8/docs/api/java/lang/Object.html#hashCode--
.. _Comparable: https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html
.. _Comparator: https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html
.. _java.util: https://docs.oracle.com/javase/8/docs/api/java/util/package-summary.html
.. _EnumMap: https://docs.oracle.com/javase/8/docs/api/java/util/EnumMap.html
.. _ArrayList.ensureCapacity: https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html#ensureCapacity-int-
.. _size: https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#size--
.. _toArray: https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#toArray--
.. _toArray(): https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#toArray--
.. _toArray(T[]): https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#toArray-T:A-
.. _sort: https://docs.oracle.com/javase/8/docs/api/java/util/List.html#sort-java.util.Comparator-
.. _java.util.Collections: https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html

