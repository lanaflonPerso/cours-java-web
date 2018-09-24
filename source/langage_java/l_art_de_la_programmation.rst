Le logiciel mange le monde
==========================

Aujourd’hui, le logiciel est présent dans toutes les sphères de nos
vies. L’exemple le plus frappant est l'influence des réseaux sociaux. Ils
représentent désormais la porte d’entrée principale de l’information.
Dans ce cadre, ils opèrent une hiérarchisation de chacun de nos fils
d’actualité en fonction de nos préférences et influence donc grandement
pour le meilleur ou pour le pire notre vision du monde. Ces processus
éditoriaux sont entièrement automatisés par des algorithmes, écrits dans
des langages de programmation permettant d’exécuter concrètement les
outils imaginés par les statisticiens, les mathématiciens, les experts
du langage naturel, psychologues…

L’impact sociétal du logiciel se diffuse dans toute la société sans même
que les utilisateurs puissent comprendre la façon dont fonctionne un
programme ni même comment pensent ceux qui le réalise.

L’objectif de ce cours est de vous apprendre à penser comme des
informaticiens ou des *computer scientists* (le terme anglais *computer
scientists* rend un meilleur hommage à la discipline en mettant en avant
son aspect scientifique).

L’approche scientifique de l’informatique combine plusieurs domaines,
comme les mathématiques, l’ingénierie et les sciences naturelles:

1. Comme les mathématiciens, les informaticiens utilisent des langages
   formels pour exprimer des idées, en l’occurrence des calculs
2. Comme les ingénieurs, ils créent et assemblent des composants dans
   des systèmes et arbitrent entre les différentes possibilité
   d’implémentation
3. Comme les scientifiques, ils observent les comportements de systèmes
   complexes, forment des hypothèses et testent leurs prédictions.

La qualité principale d’un informaticien est d’avoir un esprit *orienté
vers la résolution des problèmes* (problem solving). De formuler les
problèmes, de penser de façon créative et exprimer des solutions
clairement. Pour cela, une bonne maîtrise du langage de programmation
est indispensable.

**Votre objectif dans ce cours est d’apprendre comment utiliser le
langage JAVA pour résoudre des problèmes et d’apprendre comment ses
spécificités peuvent vous aider à produire du code rapide, sans bug, et
qui exécute les opérations que vous avez décidé**

La programmation Orientée Objet et le JAVA
==========================================

Pourquoi le JAVA
----------------

Java est le langage le plus utilisé dans l’informatique de gestion, mais
peut être utilisé dans de nombreux autres cas. Dans son écosystème, on
trouve de très bons outils très robustes et rapides. Ce langage vous
permet de très bien “vendre” votre CV, pour trouver des stages et des
emplois après une formation spécialisée en informatique.

+-------------+-------------+-------------+-------------+-------------+
| Rang        | Langage     | popularité  | utilisation | avis        |
+=============+=============+=============+=============+=============+
| 1           | Python      | 24.58       | Calcul      | Simple      |
|             |             |             | scientifiqu | d’utilisati |
|             |             |             | e,          | on,         |
|             |             |             | traitement  | mais        |
|             |             |             | de données  | faibles     |
|             |             |             |             | performance |
|             |             |             |             | s           |
|             |             |             |             | #1 dans la  |
|             |             |             |             | recherche   |
|             |             |             |             | scientifiqu |
|             |             |             |             | e           |
+-------------+-------------+-------------+-------------+-------------+
| 2           | Java        | 22.14 %     | Informatiqu | Puissant et |
|             |             |             | e           | Rapide, #1  |
|             |             |             | de gestion, | en          |
|             |             |             | traitement  | entreprise  |
|             |             |             | de données, |             |
|             |             |             | Web, Mobile |             |
|             |             |             | (android)   |             |
+-------------+-------------+-------------+-------------+-------------+
| 3           | Javascript  | 8.41 %      | Sites       | Simple      |
|             |             |             | internet    | d’utilisati |
|             |             |             |             | on          |
|             |             |             |             | et          |
|             |             |             |             | performant  |
+-------------+-------------+-------------+-------------+-------------+
| 4           | PHP         | 7.77 %      | Sites       | Moyennement |
|             |             |             | internet    | complexe,   |
|             |             |             |             | très        |
|             |             |             |             | utilisés    |
|             |             |             |             | par les     |
|             |             |             |             | techniciens |
+-------------+-------------+-------------+-------------+-------------+
| 5           | C#          | 7.74 %      | Idem à      |             |
|             |             |             | Java,       |             |
|             |             |             | produit     |             |
|             |             |             | microsoft   |             |
+-------------+-------------+-------------+-------------+-------------+
| 6           | C/C++       | 6.22 %      | Systèmes    | Très        |
|             |             |             | bas niveau, | complexe    |
|             |             |             | Systèmes    | mais très   |
|             |             |             | d’exploirat | performant  |
|             |             |             | ion         |             |
|             |             |             | (Linux,     |             |
|             |             |             | Windows,    |             |
|             |             |             | OSX)        |             |
+-------------+-------------+-------------+-------------+-------------+
| 7           | R           | 4.04 %      | Statistique | Beaucoup de |
|             |             |             | s           | fonctionnal |
|             |             |             |             | ités        |
|             |             |             |             | déjà        |
|             |             |             |             | existantes  |
|             |             |             |             | mais lent   |
+-------------+-------------+-------------+-------------+-------------+
| 8           | Objective-C | 3.33 %      | Mobile      | Très        |
|             |             |             | (IOS)       | spécialisé  |
|             |             |             |             | chez Apple, |
|             |             |             |             | en perte de |
|             |             |             |             | vitesse     |
+-------------+-------------+-------------+-------------+-------------+
| 9           | Swift       | 2.65 %      | Mobile      | Nouveau     |
|             |             |             | (IOS)       | langage     |
|             |             |             |             | pour mobile |
|             |             |             |             | IO          |
+-------------+-------------+-------------+-------------+-------------+
| 10          | Matlab      | 2.1 %       | Calcul      | Langage     |
|             |             |             | Scientifiqu | pour les    |
|             |             |             | e           | mathématici |
|             |             |             |             | ens,        |
|             |             |             |             | proche de   |
|             |             |             |             | python mais |
|             |             |             |             | très lent   |
+-------------+-------------+-------------+-------------+-------------+

Compréhension intuitive dans la programmation orientée objet
------------------------------------------------------------

La programmation Orientée objet et le *paradigme* de programmation le
plus populaire au monde actuellement. Ses avantages sont qu’il permet de
modéliser le système d’information à l’aide de concepts naturels à
l’être humain, qui découpent instinctivement le monde en classes (un.e
étudiant.e, un.e prof, un.e administrateur.rice ). Chaque individus
appartenant à une classe possède des attributs qui lui sont propre
(chaque prof a un nom, chaque étudiant.e a un numéro INE) et réalise des
actions communes à tous les individus de sa classe (chaque prof
enseigne, chaque étudiant apprend).

Les classes d’individus peuvent être réparties en famille, dès lors
qu’une classe peut en spécialiser une autre. Par exemple, les prof et
les étudiants.es sont des humains et *héritent* donc de certaines
propriété des individus de la classe des humains. Si on dit que tous les
être humains possèdent un nom et que les prof sont des être humains,
alors un prof possède un nom.
