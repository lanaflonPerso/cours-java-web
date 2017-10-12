Les packages
############

Un problème courant dans les langages de programmation est celui de la collision
de noms. Si par exemple, je veux créer une classe *TextEditor* pour représenter
une composant graphique complexe pour éditer un texte, un autre développeur
peut également le faire. Si nous distribuons nos classes, cela signifie qu'une
application peut se retrouver avec deux classes dans son *classpath* qui
portent exactement le même nom mais qui ont des méthodes et des comportements
différents.

Dans la pratique, la JVM chargera la première classe qu'elle peut trouver et ignorera
la seconde. Ce comportement n'est pas acceptable. Pour cela, il faut pouvoir
différencier ma classe *TextEditor* d'une autre.

Le moyen le plus efficace est d'introduire un espace de noms qui me soit réservé.
Dans cet espace, *TextEditor* ne désignerait que ma classe. En Java, les **packages**
servent à délimiter des espaces de noms.

Déclaration d'un package
************************

Pour qu'une classe appartienne à un package, il faut que son fichier source
commence par l'instruction :

.. code-block:: text

  package [nom du package];

Une classe ne peut appartenir qu'à un seul package. Les packages sont également
représentés sur le disque par des répertoires. Donc pour la classe suivante :

::

  package monapplication;

  public class TextEditor {

  }

Cette classe doit se trouver dans le fichier *TextEditor.java* et ce fichier
doit lui-même se trouver dans un répertoire nommé *monapplication*. Pour les fichiers
*class* résultants de la compilation, l'organisation des répertoires doit être
conservée (c'est d'ailleurs ce que fait le compilateur). Ainsi, si deux classes
portent le même nom, elles se trouveront chacune dans un fichier avec le
même nom mais dans des répertoires différents puisque ces classes appartiendront
à des packages différents.

.. note::

  Quand on spécifie le **classpath** à la compilation ou au lancement d'un
  programme, on spécifie le ou les répertoires à partir duquel se trouvent
  les packages.

Si une classe ne déclare pas d'instruction **package** au début du fichier,
on dit qu'elle appartient au package par défaut (qui n'a pas de nom). Même
si le langage l'autorise, c'est quasiment toujours une mauvaise idée. Les IDE
comme Eclipse signale d'ailleurs un avertissement si vous voulez créer une classe
dans le package par défaut. Jusqu'à présent, les exemples données ne mentionnaient
pas de package. Mais maintenant que cette notion a été introduite, les exemples
à venir préciseront toujours un package.

Sous package
************

Comme pour les répertoires, les packages suivent une organisation arborescente.
Un package contenu dans un autre package est appelé un **sous package** :

::

  package monapplication.monsouspackage;

Sur le système de fichiers, on trouvera donc un répertoire *monapplication* avec
à l'intérieur un sous répertoire *monsouspackage*.

Nom complet d'une classe
************************

Une classe est normalement désignée par son *nom complet*, c'est-à-dire par le chemin
de packages suivi d'un **.** suivi du nom de la classe.

Par exemple, la classe String_ s'appelle en fait java.lang.String_ car elle se
trouve dans le package java.lang_. J'ai donc la possibilité si je le souhaite
de créer ma propre classe String par exemple dans le package |ROOT_PKG| :

::

  package ROOT_PKG;

  public class String {

  }


.. note ::

  package java.lang
  nom de package réservé java et javax

.. _String: https://docs.oracle.com/javase/8/docs/api/java/lang/String.html
.. _java.lang.String: https://docs.oracle.com/javase/8/docs/api/java/lang/String.html
.. _java.lang: https://docs.oracle.com/javase/8/docs/api/java/lang/package-summary.html
