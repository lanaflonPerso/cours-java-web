L'héritage avec JPA
###################

JPA offre plusieurs stratégies pour associer une relation d'héritage dans le
modèle objet avec une représentation dans le modèle relationnel de données.

Pour décrire la relation d'héritage avec JPA, on utilise l'annotation `@Inheritance`_
ou `@MappedSuperclass`_.

.. note::

    Pour une présentation complète de l'héritage dans JPA, reportez-vous
    au `Wikibook <https://en.wikibooks.org/wiki/Java_Persistence/Inheritance>`__.

L'annotation @Inheritance
*************************

L'annotation `@Inheritance`_ permet d'indiquer qu'il existe une relation d'héritage
dans le modèle objet et dans le modèle relationnel. Comme il existe plusieurs
façon de représenter un héritage de données dans le modèle relationnel,
l'annotation `@Inheritance`_ dispose de l'attribut ``strategy`` pour préciser
la stratégie utilisée dans le modèle de données. Cette stratégie est une énumération
du type InheritanceType_ et accepte les valeurs :

``SINGLE_TABLE``
    l'héritage est représenté par une seule table en base de données
``JOINED``
    l'héritage est représenté par une jointure entre la table de l'entité parente et la table de l'entité enfant
``TABLE_PER_CLASS``
    l'héritage est représenté par une table par entité

Héritage avec une seule table
=============================

La stratégie ``SINGLE_TABLE`` permet de représenter en base de données un héritage
avec une seule table. Une colonne contiendra un identifiant pour déterminer le
type réel de la classe : on parle de la colonne *discriminante*. La table doit
contenir toutes les colonnes nécessaires pour stocker les informations de la
super classe et de l'ensemble des classes filles.

.. note::

    L'inconvénient de la stratégie ``SINGLE_TABLE`` est qu'il n'est pas possible
    d'ajouter des contraintes de type ``NOT NULL`` sur les colonnes représentant
    les propriétés des classes filles.

.. code-block:: java
    :caption: Super classe

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorColumn;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Inheritance;
    import javax.persistence.InheritanceType;

    @Entity
    @Inheritance(strategy=InheritanceType.SINGLE_TABLE)
    @DiscriminatorColumn(name="vehicule_type")
    public abstract class Vehicule {

        @Id
        @GeneratedValue(strategy=GenerationType.IDENTITY)
        private Long id;

        private String marque;

        // getters/setters omis

    }

Dans l'exemple précédent, la colonne discriminante est donnée par l'annotation
`@DiscriminatorColumn`_. Cette colonne n'est donc pas représentée par un attribut
dans la classe.


.. code-block:: java
    :caption: Classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorValue;
    import javax.persistence.Entity;

    @Entity
    @DiscriminatorValue("V")
    public class Voiture extends Vehicule {

        private int nbPlaces;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Une autre classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorValue;
    import javax.persistence.Entity;

    @Entity
    @DiscriminatorValue("M")
    public class Moto extends Vehicule {

        private int cylindree;

        // getters/setters omis

    }

L'annotation `@DiscriminatorValue`_ permet de préciser la valeur dans la colonne
discriminante qui permet d'identifier un objet du type de cette classe. Cette
valeur doit être unique pour l'ensemble des classes de l'héritage. Dans l'exemple
ci-dessus, lors de la persistance d'un objet de la classe ``Voiture``, JPA positionnera
automatiquement la valeur ``"V"`` dans la colonne ``vehicule_type``.

Pour l'exemple précédent, le schéma de base de données contiendra la table ``Vehicule``
qui peut être créée comme suit :

.. code-block:: sql

    create table Vehicule (
        id int(11) AUTO_INCREMENT,
        vehicule_type varchar(1) NOT NULL,
        marque varchar(255),
        cylindree int,
        nbPlaces int,
        primary key (id)
    ) engine = InnoDB;

Héritage avec jointure de tables
********************************

La stratégie ``JOINED`` permet de représenter en base de données un héritage
avec une table par entité. Pour les classes filles, JPA réalisera une jointure
entre la table représentant l'entité et la table représentant l'entité de la
super classe. L'implémentation est très proche de celle d'un héritage avec
une seule table (seule la stratégie change) mais le schéma de la base de données
est très différent.

.. code-block:: java
    :caption: Super classe

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorColumn;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Inheritance;
    import javax.persistence.InheritanceType;

    @Entity
    @Inheritance(strategy=InheritanceType.JOINED)
    @DiscriminatorColumn(name="vehicule_type")
    public abstract class Vehicule {

        @Id
        @GeneratedValue(strategy=GenerationType.IDENTITY)
        private Long id;

        private String marque;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorValue;
    import javax.persistence.Entity;

    @Entity
    @DiscriminatorValue("V")
    public class Voiture extends Vehicule {

        private int nbPlaces;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Une autre classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.DiscriminatorValue;
    import javax.persistence.Entity;

    @Entity
    @DiscriminatorValue("M")
    public class Moto extends Vehicule {

        private int cylindree;

        // getters/setters omis

    }


Dans cette configuration, JPA attend 3 tables dans le schéma de base de données
qui peuvent être créées par les instructions suivantes :

.. code-block:: sql

    create table Vehicule (
        id int(11) AUTO_INCREMENT,
        vehicule_type varchar(1) NOT NULL,
        marque varchar(255),
        primary key (id)
    ) engine = InnoDB;

    create table Voiture (
        id int(11) AUTO_INCREMENT,
        nbPlaces int,
        primary key (id),
        foreign key (id) references Vehicule(id)
    ) engine = InnoDB;

    create table Moto (
        id int(11) AUTO_INCREMENT,
        cylindree int,
        primary key (id),
        foreign key (id) references Vehicule(id)
    ) engine = InnoDB;

Héritage avec une table par classe
**********************************

La stratégie ``TABLE_PER_CLASS`` permet de représenter en base de données un héritage
avec une table par entité. Les attributs hérités sont répétés dans chaque table.
Ainsi, la notion d'héritage n'est pas exprimée dans le modèle relationnel de données.

.. code-block:: java
    :caption: Super classe

    package ROOT_PKG.vehicule;

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Inheritance;
    import javax.persistence.InheritanceType;

    @Entity
    @Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)
    public abstract class Vehicule {

        @Id
        @GeneratedValue(strategy=GenerationType.AUTO)
        private	Long id;

        private String marque;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.Entity;
    import javax.persistence.Table;

    @Entity
    @Table(name="Voiture")
    public class Voiture extends Vehicule {

        private int nbPlaces;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Une autre classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.Entity;
    import javax.persistence.Table;

    @Entity
    @Table(name="Moto")
    public class Moto extends Vehicule {

        private int cylindree;

        // getters/setters omis

    }

Dans cette configuration, JPA attend 2 tables dans le schéma de base de données
qui peuvent être créées par les instructions suivantes :

.. code-block:: sql

    create table Voiture (
        id int not null,
        marque varchar(255),
        nbPlaces int not null,
        primary key (id)
    ) engine = InnoDB;

    create table Moto (
        id int not null,
        marque varchar(255),
        cylindree int not null,
        primary key (id)
    ) engine = InnoDB;

.. note::

    La table ``Vehicule`` n'est pas nécessaire car la classe ``Vehicule`` est
    abstraite. Il n'est donc pas possible de créer des entités de type ``Vehicule``.

.. note::

    La stratégie ``TABLE_PER_CLASS`` est plus complexe à mettre en place pour
    la gestion des clés primaires. En effet, du point de vue de JPA, les objets
    de type ``Voiture`` et ``Moto`` sont également des objets de type ``Voiture``.
    À ce titre, il ne peut pas exister deux objets avec la même clé primaire. Mais,
    comme ces objets sont représentés en base de données par deux tables différentes,
    une colonne de type ``AUTO_INCREMENT`` en MySQL ne suffit pas à garantir qu'il
    n'existe pas une voiture ayant la même clé qu'une moto.

    Avec, la stratégie ``TABLE_PER_CLASS``, il n'est pas possible d'utiliser
    l'annotation `@GeneratedValue`_ avec la valeur ``IDENTITY``. On peut,
    par exemple, utiliser une table servant à générer une séquence de clés.

L'héritage et les requêtes JPQL polymorphiques
**********************************************

Lorsqu'il existe une relation d'héritage entre les entités, il est possible
de créer des requêtes polymorphiques. Si on exécute la requête JPQL suivante :

.. code-block:: text

  select v from Vehicule v
  
Alors quelle que soit la stratégie d'héritage utilisée, la requête JPQL doit
remonter l'ensemble des objets qui héritent de la classe ``Vehicule``. Pour notre
exemple, cette requête retourne la liste de tous les objets ``Voiture`` et ``Moto``.

Néanmoins il est possible d'avoir un type plus précis si nécessaire. Pour retourner
uniquement la liste des objets ``Voiture`` :

.. code-block:: text

  select v from Voiture v

Un cas à part : fusion de la super classe
*****************************************

Il arrive parfois que la relation d'héritage n'ait pas de sens dans le modèle
relationnel. Dans ce cas, la classe parente n'est pas vraiment une entité au
sens JPA, on parle de *mapped superclass*.

.. code-block:: java
    :caption: Super classe

    package ROOT_PKG.vehicule;

    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.MappedSuperclass;

    @MappedSuperclass
    public abstract class Vehicule {

	    @Id
	    @GeneratedValue(strategy=GenerationType.IDENTITY)
	    private	Long id;

	    private String marque;

        // getters/setters omis

    }

La classe ``Vehicule`` n'est plus déclarée avec l'annotation `@Entity`_ mais
avec l'annotation `@MappedSuperclass`_.

.. code-block:: java
    :caption: Classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.Entity;
    import javax.persistence.Table;

    @Entity
    @Table(name="Voiture")
    public class Voiture extends Vehicule {

	    private int nbPlaces;

        // getters/setters omis

    }

.. code-block:: java
    :caption: Une autre classe enfant

    package ROOT_PKG.vehicule;

    import javax.persistence.Entity;
    import javax.persistence.Table;

    @Entity
    @Table(name="Moto")
    public class Moto extends Vehicule {

	    private int cylindree;

        // getters/setters omis

    }

Dans cette configuration, JPA attend 2 tables dans le schéma de base de données
qui peuvent être créées par les instructions suivantes :

.. code-block:: sql

    create table Voiture (
        id int not null auto_increment,
        marque varchar(255),
        nbPlaces int not null,
        primary key (id)
    ) engine = InnoDB;

    create table Moto (
        id int not null auto_increment,
        marque varchar(255),
        cylindree int not null,
        primary key (id)
    ) engine = InnoDB;


L'utilisation de `@MappedSuperclass`_ implique qu'il
n'existe pas de relation entre les classes filles pour JPA. Comme la super classe
n'est pas un entité, il n'est pas possible d'effectuer des requêtes sur la super classe
ni d'utiliser des requêtes polymorphiques.

.. only:: epsi_b3_orm

    Exercice
    ********

    .. admonition:: Gestion des examens
        :class: hint

        On souhaite mettre en place un système de sauvegarde des notes aux examens des étudiants.

        Un résultat d'examen contient le code de l'examen, la date de passage et le nom de l'étudiant.
        Parmi les examens, on distingue :

        * un contrôle pour lequel l'étudiant a une note sur 20
        * un projet pour lequel l'étudiant a une note d'oral et d'écrit sur 10. La note du projet
          correspond à la somme de ces deux notes.

        Créez les entités et une classe Java permettant :

        * d'ajouter un résultat d'un contrôle ou d'un projet dans une base de données.
        * de récupérer la liste des objets contenant les notes d'un étudiant pour une période donnée
        * de connaître la moyenne d'un étudiant
        * de connaître la moyenne d'un contrôle ou d'un projet

        .. note::

            Une classe contenant des méthodes pour interagir avec la base de données
            est souvent qualifiée de DAO (*Data Access Object*).

        .. admonition:: Template de projet JPA

            Vous pouvez :download:`télécharger le projet d'exemple <assets/templates/template-orm.zip>`.
            Il s'agit d'un projet Maven avec une dépendance vers Hibernate et le pilote JDBC MySQL.


.. _@Inheritance: https://docs.oracle.com/javaee/7/api/javax/persistence/Inheritance.html
.. _@MappedSuperclass: https://docs.oracle.com/javaee/7/api/javax/persistence/MappedSuperclass.html
.. _InheritanceType: https://docs.oracle.com/javaee/7/api/javax/persistence/InheritanceType.html
.. _@DiscriminatorColumn: https://docs.oracle.com/javaee/7/api/javax/persistence/DiscriminatorColumn.html
.. _@DiscriminatorValue: https://docs.oracle.com/javaee/7/api/javax/persistence/DiscriminatorValue.html
.. _@GeneratedValue: https://docs.oracle.com/javaee/7/api/javax/persistence/GeneratedValue.html
.. _@MappedSuperclass: https://docs.oracle.com/javaee/7/api/javax/persistence/MappedSuperclass.html
.. _@Entity: https://docs.oracle.com/javaee/7/api/javax/persistence/Entity.html

