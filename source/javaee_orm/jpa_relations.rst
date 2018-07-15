Les relations avec JPA
######################

Une des fonctionnalités majeures des ORM est de gérer les relations
entre objets comme des relations entre tables dans un modèle de base de
données relationnelle. JPA définit des modèles de relation qui peuvent
être déclarés par annotation.

Les relations sont spécifiées par les annotations : `@OneToOne`_, `@ManyToOne`_,
`@OneToMany`_, `@ManyToMany`_.

Pour une présentation approfondie des relations dans JPA, reportez-vous
au `Wikibook <https://en.wikibooks.org/wiki/Java_Persistence/Relationships>`__.

La relation 1:1 (one to one)
****************************

L'annotation `@OneToOne`_ définit une relation 1:1 entre deux entités.
Si cette relation n'est pas
forcément très courante dans un modèle relationnel de base de données,
elle se rencontre très souvent dans une modèle objet.

.. code-block:: java
    :caption: Exemple de relation OneToOne

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.OneToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @OneToOne
      private Abonnement abonnement;

      // getters et setters omis ...
    }

.. code-block:: java
    :caption: La classe associée dans la relation OneToOne

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;

    @Entity
    public class Abonnement {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      // getters et setters omis ...
    }

L'annotation `@OneToOne`_ implique que la table ``Individu`` contient
une colonne qui est une clé étrangère contenant la clé d'un abonnement.
Par défaut, JPA s'attend à ce que cette colonne se nomme ABONNEMENT\_ID,
mais il est possible de changer ce nom grâce à l'annotation
`@JoinColumn`_ :

.. code-block:: java
    :caption: Déclaration de la clé étrangère

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.OneToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @OneToOne
      @JoinColumn(name = "abonnement_fk")
      private Abonnement abonnement;

      // getters et setters omis ...
    }

La relation n:1 (many to one)
=============================

L'annotation `@ManyToOne`_ définit une relation n:1 entre deux entités.

.. code-block:: java
    :caption: Exemple de relation ManyToOne

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.ManyToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToOne
      private Societe societe;

      // getters et setters omis ...
    }

.. code-block:: java
    :caption: La classe associée dans la relation ManyToOne

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;

    @Entity
    public class Societe {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      // getters et setters omis ...
    }

L'annotation `@ManyToOne`_ implique que la table ``Individu`` contient
une colonne qui est une clé étrangère contenant la clé d'une société.
Par défaut, JPA s'attend à ce que cette colonne se nomme SOCIETE\_ID,
mais il est possible de changer ce nom grâce à l'annotation `@JoinColumn`_.
Plutôt que par une colonne, il est également possible d'indiquer à JPA
qu'il doit passer par une table d'association pour établir la relation
entre les deux entités avec l'annotation `@JoinTable`_ :

.. code-block:: java
    :caption: Déclaration d'une table d'association

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.JoinTable;
    import javax.persistence.ManyToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToOne
      // déclaration d'une table d'association
      @JoinTable(name = "societe_individu",
                 joinColumns = @JoinColumn(name = "individu_id"),
                 inverseJoinColumns = @JoinColumn(name = "societe_id"))
      private Societe societe;

      // getters et setters omis ...
    }

La relation 1:n (one to many)
*****************************

L'annotation `@OneToMany`_ définit une relation 1:n entre deux entités.
Cette annotation ne peut être utilisée qu'avec une collection d'éléments
puisqu'elle implique qu'il peut y avoir plusieurs entités associées.

.. code-block:: java
    :caption: Exemple de relation OneToMany

    import java.util.ArrayList;
    import java.util.List;

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.OneToMany;

    @Entity
    public class Societe {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @OneToMany
      private List<Individu> employes = new ArrayList<>();

      // getters et setters omis ...
    }

.. code-block:: java
    :caption: La classe associée dans la relation OneToMany

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      // getters et setters omis ...
    }

L'annotation `@OneToMany`_ implique que la table ``Individu`` contient
une colonne qui est une clé étrangère contenant la clé d'une société.
Par défaut, JPA s'attend à ce que cette colonne se nomme SOCIETE\_ID,
mais il est possible de changer ce nom grâce à l'annotation `@JoinColumn`_.
Il est également possible d'indiquer à JPA qu'il doit passer par une
table d'association pour établir la relation entre les deux entités avec
l'annotation `@JoinTable`_.
Ainsi, `@ManyToOne`_ fonctionne exactement comme `@OneToMany`_ sauf
que cette annotation porte sur l'autre côté de la relation.

La relation n:n (many to many)
******************************

L'annotation `@ManyToMany`_
définit une relation n:n entre deux entités. Cette annotation ne peut
être utilisée qu'avec une collection d'éléments puisqu'elle implique
qu'il peut y avoir plusieurs entités associées.

.. code-block:: java
    :caption: Exemple de relation ManyToMany

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.ManyToMany;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToMany
      private List<Individu> enfants = new ArrayList<>();

      // getters et setters omis ...
    }

L'annotation `@ManyToMany`_ implique qu'il existe une table
d'association ``Individu_Individu`` qui contient les clés étrangères
``INDIVIDU_ID`` et ``ENFANTS_ID`` permettant de modéliser la relation.
Il est possible de décrire explicitement la relation grâce à l'annotation
`@JoinTable`_ :

.. code-block:: java
    :caption: Déclaration de la table d'association

    import java.util.ArrayList;
    import java.util.List;

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.JoinColumn;
    import javax.persistence.JoinTable;
    import javax.persistence.ManyToMany;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToMany
      @JoinTable(name = "ParentEnfant",
                 joinColumns = @JoinColumn(name = "parent_id"),
                 inverseJoinColumns = @JoinColumn(name = "enfant_id"))
      private List<Individu> enfants = new ArrayList<>();

      // getters et setters omis ...
    }

Les relations bi-directionnelles
********************************

Parfois, il est nécessaire de construire un lien entre deux objets qui
soit navigables dans les deux sens. D'un point de vue objet, cela
signifie que chaque objet dispose d'un attribut pointant sur l'autre
instance. Mais d'un point de vue du schéma de base de données
relationnelle, il s'agit du même lien. Avec JPA, il est possible de
qualifier une relation entre deux objets comme étant une relation
inverse grâce à l'attribut ``mappedBy`` de l'annotation indiquant le
type de relation.

.. code-block:: java
    :caption: Exemple d'une relation bi-directionnelle avec ``mappedBy``

    import java.util.ArrayList;
    import java.util.List;

    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.ManyToMany;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToMany
      private List<Individu> enfants = new ArrayList<>();

      @ManyToMany(mappedBy = "enfants")
      private List<Individu> parents = new ArrayList<>();

      // getters et setters omis ...
    }

Dans l'exemple précédent, la liste des ``enfants`` représente bien une
relation entre plusieurs instances de la classe Individu et la liste
``parents`` représente la relation inverse. Pour le spécifier à JPA, on
utilise l'attribut ``mappedBy`` de l'annotation `@ManyToMany`_ pour
indiquer sur l'attribut représentant la relation inverse, le nom de
l'attribut modélisant la relation principale.

La propagation en cascade
*************************

Avec JPA, il est possible de propager des modifications à tout ou partie
des entités liées. Les annotations permettant de spécifier une relation
possèdent un attribut ``cascade`` permettant de spécifier les opérations
concernées : ``ALL``, ``DETACH``, ``MERGE``, ``PERSIST``, ``REFRESH`` ou
``REMOVE``.

.. code-block:: java
    :caption: Exemple d'opérations en cascade

    import javax.persistence.CascadeType;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.ManyToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToOne(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
      private Societe societe;

      // getters et setters omis ...
    }

Dans l'exemple précédent, on précise que l'instance de société doit être
enregistrée en base si nécessaire au moment où l'instance d'Individu
sera elle-même enregistrée. De plus, lors d'un appel à merge pour une
instance d'Individu, un merge sera automatiquement realisé sur
l'instance de l'attribut société.

Requêtes JPQL et jointure
*************************

Dès que l'on introduit des relations entre entités, on complexifie également
le langage de requêtage. Comment par exemple demander la liste des individus
travaillant pour une société dont on passe le nom en paramètre ? On peut
utiliser une jointure avec une condition :

.. code-block:: text

  select i from Individu i join i.societe s where s.nom = :nom

Il est également possible d'utiliser le mot-clé ``on`` pour filtrer les entités
à sélectionner dans la jointure :

.. code-block:: text

  select i from Individu i join i.societe s on s.nom = :nom

Comme en SQL, JPQL fait la différence entre une jointure et une jointure
externe (*left outer join*). Avec une jointure simple, on élimine toutes les
entités pour lesquelles la jointure n'existe pas. Alors qu'avec une jointure
externe, nous préservons les entités pour lesquelles il n'existe pas de jointure.

.. code-block:: text

  select i from Individu i left join i.societe s on s.nom = :nom

Attention avec l'exemple de requête ci-dessus : elle retourne l'union des individus qui
n'ont aucune relation avec l'entité société et ceux qui ont une relation avec
une société dont le nom est donné par le paramètre ``:nom``.

Fetch lazy ou fetch eager
*************************

Lorsque JPA doit charger une entité depuis la base de données (qu'il
s'agisse d'une appel à ``EntityManager.find(...)`` ou d'une requête), la
question est de savoir quelles informations doivent être chargées.
Doit-il charger tous les attributs d'une entité ? Parmi ces attributs,
doit-il charger les entités qui sont en relation avec l'entité chargée ?
Ces questions sont importantes, car la façon d'y répondre peut avoir un
impact sur les performances de l'application.

Dans JPA, l'opération de chargement d'une entité depuis la base de
données est appelée **fetch**. Un fetch peut avoir deux stratégies :
**eager** ou **lazy** (que l'on peut traduire respectivement et
approximativement par *chargement immédiat* et *chargement différé*). On
peut décider de la stratégie pour chaque membre de la classe grâce à
l'attribut ``fetch`` présent sur les annotations `@Basic`_, `@OneToOne`_,
`@ManyToOne`_, `@OneToMany`_ et `@ManyToMany`_.

-  **eager** signifie que l'information doit être chargée
   sytématiquement lorsque l'entité est chargée. Cette stratégie est
   appliquée par défaut pour `@Basic`_, `@OneToOne`_ et `@ManyToOne`_.
-  **lazy** signifie que l'information ne sera chargée qu'à la demande
   (par exemple lorsque la méthode ``get`` de l'attribut sera appelée).
   Cette stratégie est appliquée par défaut pour `@OneToMany`_ et
   `@ManyToMany`_.

.. code-block:: java
    :caption: Exemple d'utilisation de fetch lazy

    import javax.persistence.Basic;
    import javax.persistence.Entity;
    import javax.persistence.FetchType;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Lob;
    import javax.persistence.ManyToOne;

    @Entity
    public class Individu {

      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @ManyToOne(fetch = FetchType.LAZY)
      private Societe societe;

      /*
       * Stocke la photo d'identité sous une forme binaire. Comme l'information peut être
       * volumineuse, on déclare un fetch lazy pour ne déclencher le chargement qu'à l'appel
       * de getPhoto(), c'est-à-dire quand l'application en a vraiment besoin.
       */
      @Lob
      @Basic(fetch = FetchType.LAZY)
      private byte[] photo;

      // getters et setters omis ...
    }

::

    // Exécute une requête de la forme : SELECT i.id FROM Individu i WHERE i.id = ?
    // Un appel à la méthode find ne charge pas les attributs marqués avec un fetch lazy.
    Individu persistedIndividu = entityManager.find(Individu.class, individuId);

    // Exécute une requête de la forme : SELECT i.photo FROM Individu i WHERE i.id = ?
    byte[] photo = persistedIndividu.getPhoto();

    // Exécute une requête de la forme :  SELECT * FROM Societe WHERE id = ?
    Societe societe = persistedIndividu.getSociete();

Il est possible d'utiliser une requête JPQL pour forcer la récupération d'informations
en mode *lazy* si on sait qu'elle seront nécessaires plus tard dans le programme.
Cela limite le nombre de requêtes à exécuter et peut se révéler nécessaire si
la consultation des attributs *lazy* doit se faire à un moment où un *entity manager*
n'est plus disponible. On utilise dans la requête l'option 
`JOIN FETCH <https://en.wikibooks.org/wiki/Java_Persistence/JPQL#JOIN_FETCH>`__ :

::

    // Exécute une requête de type JOIN FETCH
    String query = "select i from Individu i left join fetch i.societe where i.id = :id";
    Individu persistedIndividu = entityManager.createQuery(query, Individu.class)
                                              .setParameter("id", individuId)
                                              .getSingleResult();

    // N'exécute aucune requête car la société a déjà été récupérée par le left join fetch
    Societe societe = persistedIndividu.getSociete();


La définition des stratégies de fetch est une partie importante du
tuning dans le développement d'une application utilisant JPA.

.. only:: epsi_b3_orm

    Exercice
    ********

    .. admonition:: Gestion des examens (suite)
        :class: hint
        
        On souhaite faire évoluer le système de sauvegarde des notes aux examens des étudiants.
        
        Introduisez la classe ``Diplome`` qui contient contient une liste d'examens et créez
        une méthode permettant de sauver un diplôme en base de données avec tous ses examens.
        
        Pour réaliser cette fonctionnalité, utilisez la déclaration de relation sur les entités
        JPA.
        
        .. note::
        
            N'hésitez pas à expérimenter les possibilités de persistance en cascade et les relations
            bidirectionnelles (La classe ``Examen`` peut avoir une relation inverse vers la classe
            ``Diplome``).


.. _@OneToOne: https://docs.oracle.com/javaee/7/api/javax/persistence/OneToOne.html
.. _@ManyToOne: https://docs.oracle.com/javaee/7/api/javax/persistence/ManyToOne.html
.. _@OneToMany: https://docs.oracle.com/javaee/7/api/javax/persistence/OneToMany.html
.. _@ManyToMany: https://docs.oracle.com/javaee/7/api/javax/persistence/ManyToMany.html
.. _@JoinColumn: https://docs.oracle.com/javaee/7/api/javax/persistence/JoinColumn.html
.. _@JoinTable: https://docs.oracle.com/javaee/7/api/javax/persistence/JoinTable.html
.. _@Basic: https://docs.oracle.com/javaee/7/api/javax/persistence/Basic.html

