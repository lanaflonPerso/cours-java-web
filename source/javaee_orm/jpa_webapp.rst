JPA dans une application Web
############################

JPA permet de réaliser l'accès à la couche de données. Si on considère Java EE
comme modèle prescriptif pour la conception d'architecture logicielle, alors
l'ensemble des composants forme une application multi-couches (N-tiers) :

Couche client (Client tier)
    Pour une application Web, il s'agit des pages Web et du code Javascript 
    téléchargés par le navigateur client. Cette couche est responsable de 
    l'affichage et de l'interaction avec l'utilisateur.

Couche Web (Web tier)
    Il s'agit du point d'échange entre le client et le serveur. Les composants 
    principaux sont les Servlets/JSP et les Facelets JSF. La logique de ces 
    composants se limite à valider les données en entrée et à produire une 
    représentation des données en sortie.

Couche métier (Business tier)
    Il s'agit de l'ensemble des traitements propres à l'application. Les composants sont les EJB.

Couche du système d'information (Enterprise Information System tier)
    Il s'agit principalement des serveurs de bases de données. L'application 
    interagit avec ces serveurs grâce au service JDBC ou aux Entity Beans (JPA).

Si nous suivons cette logique, alors un *entity manager* doit être manipulé par
un EJB.

Obtenir un EntityManager dans un serveur Java EE
************************************************

Pour une application déployée dans un serveur d'application Java EE, 
l'initialisation de JPA est un peu différente car le serveur utilise la notion 
de :ref:`DataSource JDBC <datasource_ref>` et gère les 
:ref:`transactions avec JTA (Java Transaction API) <jta_ref>`. 
De plus, le fichier :file:`persistence.xml` ne contient pas de déclaration à 
une URL JDBC mais une DataSource.

.. code-block:: xml
    :caption: Exemple de persistence.xml utilisant une DataSource

    <?xml version="1.0" encoding="UTF-8"?>
    <persistence version="2.0"
      xmlns="http://java.sun.com/xml/ns/persistence" 
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://java.sun.com/xml/ns/persistence 
	                  http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd">
      <persistence-unit name="individuPersistenceUnit">
        <jta-data-source>individuDataSource</jta-data-source>
        <properties>
            <property name="hibernate.show_sql" value="true" />
            <property name="hibernate.format_sql" value="true" />
        </properties>
      </persistence-unit>
    </persistence>

L'unité de persistance est déclarée en utilisant la balise 
``<jta-data-source>`` qui précise le nom de la DataSource_ déclarée dans le serveur. 
Pour un déploiement dans Wildfly, il faudra, par exemple, ajouter la déclaration 
de cette DataSource dans le fichier :file:`web.xml` ainsi que dans le serveur 
comme nous l'avons vu dans le :ref:`chapitre consacré à JDBC <configuration_datasource>`.

Il est possible d'obtenir une instance d'un EntityManagerFactory_ par injection dans 
n'importe quel composant Java EE (servlet, managed bean CDI, EJB) 
grâce à l'annotation `@PersistenceUnit`_. Cette annotation supporte l'attribut
``unitName`` afin de préciser le nom de l'unité de persistance :

.. code-block:: java
    :caption: Injection d'une EntityManagerFactory dans un composant Java EE

    import javax.persistence.EntityManagerFactory;
    import javax.persistence.PersistenceUnit;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;

    @WebServlet("/MyServlet")
    public class MyServlet extends HttpServlet {

      @PersistenceUnit(unitName="individuPersistenceUnit")
      private EntityManagerFactory entityManagerFactory;

    }

.. note::

    Il est très rare d'injecter un EntityManagerFactory_ dans une Servlet. En
    effet, le modèle en couche Java EE préconise de séparer la couche Web de
    la couche d'accès aux données (couche du système d'information) par une
    couche métier dans laquelle on trouve les EJB de l'application. Donc, une 
    Servlet recevra plutôt par injection un EJB.

Il est également possible d'obtenir un EntityManager_ grâce à l'annotation 
`@PersistenceContext`_. Cette annotation accepte l'attribut ``unitName``
permettant de préciser l'unité de persistance pour laquelle on désire obtenir
un EntityManager_. Attention, un EntityManager_ n'est pas thread-safe. 
Il ne doit pas être injecté dans un composant Java EE qui est utilisé dans des 
accès concurrents. Les beans CDI de portée requête (`@RequestScoped`_) et la plupart 
des EJB sont des composants Java EE dans lesquels on peut injecter en toute 
sécurité un EntityManager_.


.. code-block:: java
    :caption: Injection d'un EntityManager dans un EJB

    import javax.persistence.EntityManager;
    import javax.persistence.PersistenceContext;
    import javax.ejb.Stateless;

    @Stateless
    public class IndividuRepository {
	
      @PersistenceContext(unitName="individuPersistenceUnit")
      private EntityManager entityManager;

    }

Dans un environnement Java EE, il est de la responsabilité du serveur d'application 
d'initialiser et de fermer les différentes instances de type EntityManagerFactory_
et EntityManager_. Autrement dit, le développeur de composant n'a pas à se préoccuper 
d'appeler les méthodes ``close()`` sur ces instances.


.. code-block:: java
    :caption: Utilisation d'un EntityManager dans un EJB

    import javax.persistence.EntityManager;
    import javax.persistence.PersistenceContext;
    import javax.ejb.Stateless;

    @Stateless
    public class IndividuRepository {
	
      @PersistenceContext(unitName="individuPersistenceUnit")
      private EntityManager entityManager;
      
      public Individu find(long id) {
        return entityManager.find(id, Individu.class);
      }

    }


JPA et JTA
**********

JTA (Java Transaction API) est une API dédiée à la gestion de la transaction. 
Cette API ne se limite pas aux transactions avec des SGBDR mais a pour but d'offrir 
une interface unique pour tous les systèmes transactionnels. 

.. warning::

    L'inconvénient de l'utilisation de JTA est qu'il rend obsolète la méthode 
    ``EntityManager.getTransaction()``. Ainsi, du code JPA écrit pour une interaction
    avec une base de données sans JTA utilisera la classe EntityTransaction_ fournie par JPA.
    Cependant ce code ne fonctionnera plus si on utilise une DataSource_ compatible JTA.

.. only:: tomee

    Dans TomEE, une DataSource gérée par le serveur doit utiliser obligatoirement 
    JTA pour fonctionner. Il faut donc penser à activer le 
    support JTA dans la déclaration de la DataSource_ :

    .. code-block:: xml
        :caption: Activation du support JTA dans une DataSource TomEE
    
        <?xml version="1.0" encoding="UTF-8"?>
        <tomee>
        <Resource id="nomDeLaDataSource" type="javax.sql.DataSource">
          JdbcDriver com.mysql.jdbc.Driver
          JdbcUrl jdbc:mysql://localhost:3306/myDataBase
          UserName root
          Password root
          JtaManaged true
        </Resource>
        </tomee>

Pour signaler la démarcation transactionnelle avec JTA, il existe deux solutions :

* Soit on utilise une forme déclarative avec les EJB 
  (Cf. :ref:`la gestion des transactions dans les EJB <demarcation_transactionnelle>`)
* Soit on utilise un forme programmatique grâce à l'objet UserTransaction_

Pour la méthode programmatique, une instance de l'objet UserTransaction_ peut être 
récupérée par injection grâce à l'annotation `@Resource`_ dans un composant Java EE.

.. code-block:: java
    :caption: Utilisation de l'API JTA dans un composant Java EE

    import java.io.IOException;

    import javax.annotation.Resource;
    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import javax.transaction.UserTransaction;

    @WebServlet("/myServlet")
    public class MyServlet extends HttpServlet {

      @Resource
      private UserTransaction userTransaction;

      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
                                      throws ServletException, IOException {

        boolean transactionOk = false;
        try {
          userTransaction.begin();

          // ...

          transactionOk = true;
        } catch (Exception e) {
          // ...
        } finally {
          try {
            if (transactionOk) {
              userTransaction.commit();
            } else {
              userTransaction.rollback();
            }
          } catch (Exception e) {
            // ...
          }
        }
      }

    }

L'utilisation de l'API JTA est très verbeuse. De plus, chaque méthode peut jeter 
plusieurs exceptions et il n'est pas toujours facile de savoir comment les traiter. 
En général, il est plus simple d'opter pour une approche déclarative 
(basée par exemple sur :ref:`les méthodes des EJB <demarcation_transactionnelle>`).


.. _DataSource: https://docs.oracle.com/javase/8/docs/api/javax/sql/DataSource.html
.. _EntityManager: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManager.html
.. _EntityManagerFactory: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityManagerFactory.html
.. _@PersistenceUnit: http://docs.oracle.com/javaee/7/api/javax/persistence/PersistenceUnit.html
.. _@PersistenceContext: http://docs.oracle.com/javaee/7/api/javax/persistence/PersistenceContext.html
.. _UserTransaction: http://docs.oracle.com/javaee/7/api/javax/transaction/UserTransaction.html
.. _@Resource: https://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html
.. _EntityTransaction: https://docs.oracle.com/javaee/7/api/javax/persistence/EntityTransaction.html
.. _@RequestScoped: https://docs.oracle.com/javaee/7/api/javax/enterprise/context/RequestScoped.html
