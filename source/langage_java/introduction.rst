Introduction
############
Java est un langage de programmation originellement proposé par Sun Microsystems et maintenant
par Oracle depuis son rachat de Sun Microsystems en 2010.

Java a été conçu avec deux objectifs principaux :

* Permettre aux développeurs d'écrire des logiciels indépendants de l'environnement *hardware* d'exécution.
* Offrir un langage orienté objet avec une bibliothèque standard riche

L'environnement
***************
L'indépendance par rapport à l'environnement d'exécution est garantie par la *machine virtuelle Java*
(Java Virtual Machine ou **JVM**). En effet, Java est un langage compilé mais le compilateur ne
produit pas de code natif pour la machine, il produit du bytecode_ : un jeu d'instructions compréhensibles
par la JVM qu'elle va traduire en code exécutable par la machine au moment de l'exécution.

Pour qu'un programme Java fonctionne, il faut non seulement que les développeurs aient compilé le code
source mais il faut également qu'un environnement d'exécution (comprenant la JVM) soit installé sur
la machine cible.

Il existe ainsi deux environnements Java qui peuvent être téléchargés et installés depuis le `site
d'Oracle`_ :

JRE - Java Runtime Environment
  Cet environnement fournit uniquement les outils nécessaires à l'exécution de programmes Java. Il
  fournit entre-autres la machine virtuelle Java.

JDK - Java Development Kit
  Cet environnement fournit tous les outils nécessaires à l'exécution mais aussi au développement de
  programmes Java. Il fournit entre-autres la machine virtuelle Java et la compilateur.

Oracle JDK et Open JDK
**********************

Depuis 2006, le code source Java (et notamment le code source de la JVM) est progressivement passé
sous licence libre GNU GPL_. Il existe une version de l'environnement Java incluant uniquement
le code libre : `Open JDK`_. De son côté, Oracle distribue son propre JDK basé sur l'Open JDK et
incluant également des outils et du code source toujours sous licence fermée.


Un bref historique des versions
*******************************


.. list-table:: 
  :widths: 10 20 50
  :header-rows: 1
  
  * - version
    - date
    - faits notables
  * - 1.0
    - janvier 1996
    - La naissance
  * - 1.1
    - février 1997
    - Ajout de JDBC et définition des JavaBeans
  * - 1.2
    - décembre 1998
    - | Ajout de Swing, des collections (JCF), de l'API de réflexion.
      | La machine virtuelle inclut la compilation à la volée (Just In Time)
  * - 1.3
    - mai 2000
    - JVM HotSpot
  * - 1.4
    - février 2002
    - support des regexp et premier parser de XML
  * - 5
    - septembre 2004
    - | évolutions majeures du langage : autoboxing, énumérations, varargs, imports
        statiques, foreach, types génériques, annotations.
      | Nombreux ajout dans l'API standard
  * - 6
    - décembre 2006
    - 
  * - 7
    - juillet 2011
    - Quelques évolutions du langage et l'introduction de java.nio
  * - 8
    - mars 2014
    - évolutions majeures du langage : les lambdas et les streams et une nouvelle API pour les dates
  * - 9
    - septembre 2017
    - les modules (projet Jigsaw) et jshell
    
.. _site d'Oracle: http://www.oracle.com/technetwork/java/javase/downloads/index.html
.. _bytecode: https://fr.wikipedia.org/wiki/Bytecode_Java
.. _GPL: https://fr.wikipedia.org/wiki/Licence_publique_g%C3%A9n%C3%A9rale_GNU
.. _Open JDK: http://openjdk.java.net/
