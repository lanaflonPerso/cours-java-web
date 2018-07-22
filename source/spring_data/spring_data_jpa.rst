JPA avec Spring Data
####################

`Spring Data`_ est un projet *Spring* qui a pour objectif de simplifier l'interaction
avec différents systèmes de stockage de données : qu'il s'agisse d'une base de données
relationnelle, d'une base de données NoSQL, d'un système *Big Data* ou encore
d'une API Web.

Le principe de *Spring Data* est d'éviter aux développeurs de coder les accès à
ces systèmes. Pour cela, *Spring Data* utilise une convention de nommage des méthodes
d'accès pour exprimer la requête à réaliser.

Ajout de Spring Data JPA dans un projet Maven
*********************************************

`Spring Data`_ se compose d'un noyau central et de plusieurs sous modules dédiés
à un type de système de stockage et une technologies d'accès. Dans un projet
Maven, pour utiliser *Spring Data* pour une base de données relationnelles avec
JPA, il faut déclarer la dépendance suivante :

.. code-block:: xml

  <dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
    <version>2.0.8.RELEASE</version>
  </dependency>

Notion de repository
********************

*Spring Data* s'organise autour de la notion de *repository*. Ainsi il fournit
une interface marqueur générique `Repository<T, ID>`_. Le type **T** correspond
au type de l'objet géré par le *repository*. Le type **ID** correspond au type
de l'objet qui représente la clé d'un objet.

L'interface `CrudRepository<T, ID>`_ hérite de `Repository<T, ID>`_ et fournit
un ensemble d'opérations élémentaires pour la manipulation des objets.

Pour une intégration de *Spring Data* avec JPA, il existe également l'interface
`JpaRepository<T, ID>`_ qui hérite indirectement de `CrudRepository<T, ID>`_ et
qui fournit un ensemble de méthodes pour interagir avec une base de données.


