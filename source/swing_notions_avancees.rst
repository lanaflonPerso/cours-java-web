Swing : notions avancées
########################

Ce chapitre couvre quelques notions avancées pour la programmation d'applications
graphiques avec Swing

Principe du MVC
***************

Le MVC_ (modèle-vue-contrôleur) est modèle de conception adapté pour le 
développement d'interface graphique. Le MVC_ découpe le traitement applicatif 
selon trois catégories :

Le modèle
  Il contient les données applicatives ainsi que les logiques de traitement 
  propres à l'application.
La vue
  Elle gère la représentation graphique des données et l'interface utilisateur
Le contrôleur
  Il est sollicité par les intéractions de l'utilisateur ou les modifications 
  des données. Il assure la cohérence entre le modèle et la vue. 

Ce modèle se retrouve dans l'architecture des composants Swing. Ce modèle est
particulièrement important à comprendre pour les composants grahiques les plus complexes
comme JTable_, JList_ et JTree_.

Les intéractions entre les trois éléments du modèles MVC_ sont réalisées en Swing
grâce à des *listeners*. Par exemple, la vue peut être prévenue par le modèle
que des données ont évoluées et que la représentation graphique doit être
rafraichie.

Pour des composants graphiques comme le JTable_, la vue et le contrôleur sont
très largement pris en charge par le composant. Le développeur doit fournir
la partie modèle en fournissant une classe qui joue le rôle du modèle de données
(*data model*).

La classe JTable
****************

La classe JTable_ représente un tableau à deux dimensions (type tableur). Chaque
cellule peut afficher une information. À la création de ce composant, il est
possible de fournir une instance de TableModel_. Il s'agit d'une interface
qui fournit les informations nécessaires au composant pour s'afficher avec notamment
le nombre de lignes, le nombre de colonnes et le contenu de chaque cellule.
Comme l'interface TableModel_ peut être un peu complexe à implémenter, la
classe abstraite AbstractTableModel_ fournit une partie de l'implémentation.

.. todo::

  * Les composants évolués : JTable et JList
  * Principe du Worker thread

.. _MVC: http://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-contr%C3%B4leur
