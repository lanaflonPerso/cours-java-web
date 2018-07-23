Les requêtes JPA
################

Les méthodes ``find``, ``persist``, ``merge``, ``detach``, ``refresh``
et ``remove`` disponibles avec une instance d'un EntityManager_
permettent de gérer simplement une entité mais ne permettent pas de
réaliser des requêtes très élaborées.

Heureusement, un EntityManager_ fournit également différentes API
pour exécuter des requêtes. Le principe est toujours le même :

#. On crée un objet de type Query_ ou TypedQuery_ grâce à l'API
#. Pour les requêtes paramétrées, on positionne la valeur des paramètres
   grâce aux méthodes ``setParameter(String name, XXX xxx)`` ou
   ``setParameter(int position, XXX xxx)``
#. On peut optionnellement positionner plusieurs autres informations
   pour la requête (par exemple, le nombre maximum de résultats pour une
   consultation grâce à la méthode ``setMaxResults(int)``)
#. On exécute la requête grâce aux méthodes ``executeUpdate()`` (pour un
   update ou un delete), ``getSingleResult()`` (pour une requête SELECT
   ne retournant qu'un seul résultat) ou ``getResultList()`` (pour une
   requête SELECT retournant une liste de résultats).

Pour les différents exemples de requêtes qui suivent, nous nous baserons
sur l'entité JPA suivante :

::

    import javax.persistence.Basic;
    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.GeneratedValue;
    import javax.persistence.GenerationType;
    import javax.persistence.Id;
    import javax.persistence.Table;

    @Entity
    @Table(name = "individu")
    public class Individu {
      @Id
      @Column(name = "individuId")
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      private Long id;

      @Basic
      @Column(length = 30, nullable = false)
      private String nom;

      @Basic
      @Column(length = 30, nullable = false)
      private String prenom;

      @Column(length = 3, nullable = false)
      private Integer age;

      // les getters et setters sont omis ...
    }

Cette entité JPA correspond à la table MySQL :

.. code-block:: sql

    CREATE TABLE `individu` (
      `individuId` int NOT NULL AUTO_INCREMENT,
      `nom` varchar(30) NOT NULL,
      `prenom` varchar(30) NOT NULL,
      `age` int(3) NOT NULL,
      PRIMARY KEY (`individu_id`)
    );

Les requêtes Natives
********************

Les requêtes natives en JPA désignent les requêtes SQL. On crée une
requête native à partir des méthodes
``EntityManager.createNativeQuery(...)``.

.. code-block:: java
    :caption: Exemple : récupérer tous les individus

    List<Individu> individus = null;
    individus = entityManager.createNativeQuery("select * from individu", Individu.class)
                             .getResultList();


.. code-block:: java
    :caption: Exemple : récupérer tous les individus âgés au plus de ageMax

    int ageMax = 25;
    List<Individu> individus = null;
    individus = entityManager
                  .createNativeQuery("select * from individu where age <= ?", Individu.class)
                  .setParameter(1, ageMax)
                  .getResultList();

.. code-block:: java
    :caption: Exemple : connaître le nombre d'individus enregistrés

    long result = (Long) entityManager
                       .createNativeQuery("select count(1) from individu")
                       .getSingleResult();

.. code-block:: java
    :caption: Exemple : Suppression d'un individu dont l'id est individuId

    long individuId = 1;
    // Cette requête nécessite une transaction active
    entityManager.createNativeQuery("delete from individu where individuId = ?")
                 .setParameter(1, individuId)
                 .executeUpdate();

Les requêtes JPQL
*****************

Avec JPA, il est possible d'utiliser une autre langage pour l'écriture
des requêtes, il s'agit du **JPA Query Language** (JPQL). Ce langage est
un langage de requête objet. L'objectif n'est plus d'écrire des requêtes
basées sur le modèle relationnel des tables mais sur le modèle objet des
classes Java.

Pour une **introduction à la syntaxe du JPQL**, reportez-vous au
`Wikibook <https://en.wikibooks.org/wiki/Java_Persistence/JPQL>`__.

On crée une requête JPQL à partir des méthodes ``EntityManager.createQuery(...)``.

.. code-block:: java
    :caption: Exemple : récupérer tous les individus

    List<Individu> individus = null;
    individus = entityManager.createQuery("select i from Individu i", Individu.class)
                             .getResultList();

.. code-block:: java
    :caption: Exemple : récupérer tous les individus âgés au plus de ageMax

    int ageMax = 25;
    List<Individu> individus = null;
    individus = entityManager
                    .createQuery("select i from Individu i where i.age <= :ageMax", Individu.class)
                    .setParameter("ageMax", ageMax)
                    .getResultList();

.. code-block:: java
    :caption: Exemple : connaître le nombre d'individus enregistrés

    long result = (Long) entityManager.createQuery("select count(i) from Individu i")
                               .getSingleResult();

.. code-block:: java
    :caption: Exemple : Suppression d'un individu dont l'id est individuId

    long individuId = 1;
    // Cette requête nécessite une transaction active
    entityManager.createQuery("delete from Individu i where i.id = :id")
                 .setParameter("id", individuId)
                 .executeUpdate();

Sur des exemples aussi simples que les exemples précédents, le JPQL
semble très proche du SQL. Cependant, avec le JPQL, on ne fait référence
qu'aux objets et à leurs attributs, **jamais** au nom des tables et des
colonnes.

Ainsi, dans la requête JPQL suivante :

::

    select individu from Individu individu

**individu** désigne la variable contenant l'instance courante de la
classe Individu. Il ne s'agit absolument pas d'un alias de table comme
en SQL. La déclaration d'une variable en JPQL est obligatoire ! Alors
qu'un alias de table SQL est optionnel.

Enfin, le JPQL introduit une nouvelle façon de déclarer un paramètre
dans une requête sous la forme ``:nom``. Les paramètres disposent
ainsi d'un nom explicite, rendant ainsi le code plus facile à lire et à
maintenir.

Les requêtes par programmation
==============================

Lorsque l'on souhaite construire une requête JPQL dynamiquement, il
n'est pas toujours très facile de construire la requête par simple
concaténation de chaînes de caractères. Pour cela, JPA fournit une API
permettant de définir entièrement une requête JPQL par programmation. On
crée cette requête à travers un CriteriaBuilder_ que l'on peut récupérer grâce
à la méthode ``EntityManager.getCriteriaBuilder()``.

.. code-block:: java
    :caption: Exemple : récupérer tous les individus

    CriteriaBuilder builder = entityManager.getCriteriaBuilder();

    CriteriaQuery<Individu> query = builder.createQuery(Individu.class);
    Root<Individu> i = query.from(Individu.class);
    query.select(i);

    List<Individu> individus = entityManager.createQuery(query).getResultList();

.. code-block:: java
    :caption: Exemple : récupérer tous les individus âgés au plus de ageMax

    int ageMax = 25;

    CriteriaBuilder builder = entityManager.getCriteriaBuilder();

    CriteriaQuery<Individu> query = builder.createQuery(Individu.class);
    Root<Individu> i = query.from(Individu.class);
    query.select(i);
    query.where(builder.lessThanOrEqualTo(i.get("age").as(int.class), ageMax));

    List<Individu> individus = entityManager.createQuery(query).getResultList();

.. code-block:: java
    :caption: Exemple : connaître le nombre d'individus enregistrés

    CriteriaBuilder builder = entityManager.getCriteriaBuilder();

    CriteriaQuery<Long> query = builder.createQuery(Long.class);
    Root<Individu> i = query.from(Individu.class);
    query.select(builder.count(i));

    long result = entityManager.createQuery(query).getSingleResult();

Pour des exemples supplémentaires d'utilisation du CriteriaBuilder_,
reportez-vous au `Wikibook <https://en.wikibooks.org/wiki/Java_Persistence/Criteria>`__.

.. _jpa_requetes_nommees:

Utilisation de requêtes nommées
*******************************

L'utilisation de requêtes peut rendre l'application difficile à comprendre et à faire
évoluer. En effet, les requêtes sont mêlées au code source Java sous la forme de chaîne
de caractères. Si vous préférez regrouper toutes vos requêtes dans des parties
clairement identifiées du code, alors vous pouvez utiliser les requêtes nommées
(*named queries*).

Une requête nommée permet d'associer un identifiant de requête à une requête JPQL. On utilise
pour cela l'annotation `@NamedQuery`_ que l'on peut placer sur la classe de l'entité
pour centraliser toutes les requêtes relatives à cette entité.

.. code-block:: java
  :caption: Déclaration d'une requête nommée

  package ROOT_PKG;

  import javax.persistence.Entity;
  import javax.persistence.GeneratedValue;
  import javax.persistence.GenerationType;
  import javax.persistence.Id;
  import javax.persistence.NamedQuery;

  @Entity
  @NamedQuery(name="findIndividuByNom", query="select i from Individu i where i.nom = :nom")
  public class Individu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String nom;

    // getters et setters omis
    
  }

Dans l'exemple ci-dessus, on déclare une requête que l'on nomme "findIndividuByNom".

Si vous voulez nommer plusieurs requêtes, vous devez utiliser l'annotation
`@NamedQueries`_ pour les regrouper toutes sous la forme d'un tableau.

.. code-block:: java
  :caption: Déclaration de plusieurs requêtes nommées

  package ROOT_PKG;

  import javax.persistence.Entity;
  import javax.persistence.GeneratedValue;
  import javax.persistence.GenerationType;
  import javax.persistence.Id;
  import javax.persistence.NamedQueries;
  import javax.persistence.NamedQuery;

  @Entity
  @NamedQueries({
    @NamedQuery(name="findIndividuByNom", query="select i from Individu i where i.nom = :nom"),
    @NamedQuery(name="deleteIndividuByNom", query="delete from Individu i where i.nom = :nom"),
    @NamedQuery(name="deleteAllIndividus", query="delete from Individu i")
  })
  public class Individu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String nom;

    // getters et setters omis
    
  }

On peut ensuite créer et exécuter des requêtes nommées à partir d'un EntityManager_.

::

  Individu individu = entityManager.createNamedQuery("findIndividuByNom", Individu.class)
                                   .setParameter("nom", "David Gayerie")
                                   .getSingleResult();

::

  entityManager.getTransaction().begin();
  entityManager.createNamedQuery("deleteIndividuByNom")
               .setParameter("nom", "David Gayerie")
               .executeUpdate();
  entityManager.getTransaction().commit();

.. note::

  Il est également possible de créer des requêtes nommées en SQL en utilisant
  les annotations `@NamedNativeQuery`_ et `@NamedNativeQueries`_ sur le même
  principe qu'avec des requêtes nommées en JPQL.
  
.. warning::

  Même si une requête nommée est déclarée dans une classe, son nom est globale
  à l'ensemble de l'unité de persistance. Il faut donc absolument éviter
  tout doublon dans le nom des requêtes.

.. _CriteriaBuilder: https://docs.oracle.com/javaee/7/api/javax/persistence/criteria/CriteriaBuilder.html
.. _EntityManager: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManager.html
.. _Query: https://docs.oracle.com/javaee/7/api/javax/persistence/Query.html
.. _TypedQuery: https://docs.oracle.com/javaee/7/api/javax/persistence/TypedQuery.html
.. _@NamedQuery: https://docs.oracle.com/javaee/7/api/javax/persistence/NamedQuery.html
.. _@NamedQueries: https://docs.oracle.com/javaee/7/api/javax/persistence/NamedQueries.html
.. _@NamedNativeQuery: https://docs.oracle.com/javaee/7/api/javax/persistence/NamedNativeQuery.html
.. _@NamedNativeQueries: https://docs.oracle.com/javaee/7/api/javax/persistence/NamedNativeQueries.html


