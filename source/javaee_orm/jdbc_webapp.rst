JDBC dans une application Web
#############################

JDBC (Java DataBase Connectivity) est l'API standard pour interagir avec les
bases données relationnelles en Java. Cette API peut être utilisée dans une 
application Web.

Déclaration d'une DataSource 
****************************

Dans un serveur d'application, l'utilisation du DriverManager_ JDBC est remplacée
par celle de la DataSource_. L'interface DataSource_ n'offre que deux méthodes :

::

    // Attempts to establish a connection with the data source
    Connection getConnection()

    // Attempts to establish a connection with the data source
    Connection getConnection(String username, String password)

Il n'est pas possible de spécifier l'URL de connection à la base de données
avec une DataSource_. Par contre une DataSource_ peut être injectée dans
n'importe quel composant Java EE grâce à l'annotation Resource_ :

.. code-block:: java
    :caption: Injection d'une DataSource dans une Servlet


    import java.io.IOException;
    import java.sql.Connection;

    import javax.annotation.Resource;
    import javax.servlet.ServletException;
    import javax.servlet.annotation.WebServlet;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import javax.sql.DataSource;

    @WebServlet("/MyServlet")
    public class MyServlet extends HttpServlet {

      @Resource(name = "nomDeLaDataSource")
      private DataSource dataSource;

      @Override
      protected void doGet(HttpServletRequest req, HttpServletResponse resp)
                              throws ServletException, IOException {

        try (Connection connection = dataSource.getConnection()) {
          // ...
        }

      }

    }

L'annotation Resource_ permet de spécifier le nom de la DataSource_ grâce à
l'attribut *name*.

.. note::

    L'annotation Resource_ se base sur **JNDI** (Java Naming and Directory
    Interface) pour rechercher la DataSource_ demandée. JNDI est une API standard
    de Java permettant de se connecter à des annuaires (notamment les annuaires
    LDAP). Les serveurs d'application Java EE disposent de leur propre implémentation
    interne d'annuaire permettant de stocker des instances d'objet.

    Les ressources telles que les *DataSources* sont donc stockées dans un annuaire
    interne et il est possible d'y accéder avec l'API JNDI. Les ressources sont
    classées dans une arborescence (comme le sont les fichiers dans un système
    de fichiers). Une ressource est stockée dans l'arborescence **java:/comp/env**.

    .. code-block:: java
        :caption: Exemple de récupération d'une DataSource en utilisant l'API JNDI

        // javax.naming.InitialContext désigne le contexte racine de l'annuaire.
        // Un annuaire JDNI est constitué d'instances de javax.naming.Context
        // (qui sont l'équivalent des répertoires dans un système de fichiers).
        Context envContext = InitialContext.doLookup("java:/comp/env");

        // On récupère la source de données dans le contexte java:/comp/env
        DataSource dataSource = DataSource.class.cast(envContext.lookup("nomDeLaDataSource"));

    Le contexte JNDI **java:/comp/env** est un contexte particulier. Il désigne
    l'ensemble des composants Java EE disponibles dans l'environnement (env) du
    composant Java EE (comp) courant.


Déclaration de la DataSource dans le fichier web.xml
****************************************************

Le fichier de déploiement :file:`web.xml` doit déclarer la DataSource_ comme
une ressource de l'application. Cela va permettre au serveur d'application
de permettre à l'application de se connecter à la base de données associée. 
Pour cela, on utilise l'élément ``<resource-ref>`` dans le fichier :file:`web.xml` :

.. code-block:: xml
  :caption: Déclaration de la DataSource dans le fichier web.xml

  <resource-ref>
  <res-ref-name>nomDeLaDataSource</res-ref-name>
    <res-type>javax.sql.DataSource</res-type>
    <mapped-name>java:/nomDeLaDataSource</mapped-name>
  </resource-ref>

Mais comment le serveur d'application fait-il pour lier
une DataSource_ avec une connexion vers une base de données ? Malheureusement,
il n'existe pas de standard et chaque serveur d'application dispose de sa
procédure. Nous allons voir dans la section suivante comment créer une DataSource_
spécifiquement pour Wildfly.

Déclaration d'une DataSource dans Wildfly
*****************************************

Une connexion JDBC est réalisée à travers un pilote. Pour déclarer une DataSource_
vers une base de données MySQL par exemple, nous devons installer le pilote
MySQL dans le serveur.

Vous pouvez télécharger le driver MySQL pour JDBC 
`ici selon la version <http://mvnrepository.com/artifact/mysql/mysql-connector-java>`__.

Pour ajouter ce pilote dans Wildfly, il faut créer un nouveau module dans le serveur.
Pour cela, à partir du répertoire d'installation du serveur lui-même, placez
le fichier *jar* du pilote dans le répertoire :file:`modules/system/layers/base/com/mysql/driver/main`.
Créez les répertoires manquants si nécessaire.

Créez ensuite le fichier :file:`module.xml` dans le répertoire 
:file:`modules/system/layers/base/com/mysql/driver/main`. Ce fichier doit pointer
sur le fichier *jar* du pilote :

.. code-block:: xml
  :caption: Fichier module.xml

  <?xml version='1.0' encoding='UTF-8'?>
  <module xmlns="urn:jboss:module:1.5" name="com.mysql.driver">
    <resources>
      <!-- Indiquez le chemin vers le fichier jar du pilote -->
      <resource-root path="mysql-connector-java-X.X.X.jar" />
    </resources>
    <dependencies>
      <module name="javax.api"/>
      <module name="javax.transaction.api"/>
      <module name="javax.servlet.api" optional="true"/>
      <module name="javax.ws.rs.api" optional="true"/>
    </dependencies>
  </module>

Une fois, le pilote déclaré comme un module dans le serveur, il est possible
de déclarer la DataSource_ dans le fichier :file:`standalone/configuration/standalone.xml`.
Au alentour de la ligne 140 dans ce fichier, on trouve la section de déclaration
des pilotes de base de données et des sources de données :

.. code-block:: xml
  :caption: ajout d'une source de données dans le fichier standalone.xml
  :linenos:
  :lineno-start: 141
  :emphasize-lines: 11-18, 23-25

    <subsystem xmlns="urn:jboss:domain:datasources:5.0">
        <datasources>
            <datasource jndi-name="java:jboss/datasources/ExampleDS" pool-name="ExampleDS" enabled="true" use-java-context="true">
                <connection-url>jdbc:h2:mem:test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE</connection-url>
                <driver>h2</driver>
                <security>
                    <user-name>sa</user-name>
                    <password>sa</password>
                </security>
            </datasource>
            <datasource jta="true" jndi-name="java:/nomDeLaDataSource" pool-name="nomDeLaDataSource" enabled="true">
                <connection-url>jdbc:mysql://[HOST]:[PORT]/[NOM SCHEMA]</connection-url>
                <driver>mysql</driver>
                <security>
                    <user-name>[LOGIN]</user-name>
                    <password>[PASSWORD]</password>
                </security>
            </datasource>
            <drivers>
                <driver name="h2" module="com.h2database.h2">
                    <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>
                </driver>
                <driver name="mysql" module="com.mysql.driver">
                    <driver-class>com.mysql.jdbc.Driver</driver-class>
                </driver>
            </drivers>
        </datasources>
    </subsystem>


Ce système de configuration est certes plus compliqué que l'utilisation du
DriverManager_ mais il permet à l'application d'ignorer les détails de
configuration. Généralement le développeur de l'application référence une DataSource_
et c'est l'administrateur du serveur qui configure la connexion de cette DataSource_
vers une base de données spécifiques.

L'utilisation des *DataSources* dans un serveur d'application
apporte également des fonctionnalités supplémentaires telles que la mise en
cache et la réutilisation de connexions (pour améliorer les performances),
les tests permettant de vérifier que les connexions sont correctement
établies, la supervision des connexions...


.. _try-with-resources: https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html
.. _AutoCloseable: https://docs.oracle.com/javase/8/docs/api/java/lang/AutoCloseable.html
.. _java.sql.Connection: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html
.. _Connection: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html
.. _Statement: https://docs.oracle.com/javase/8/docs/api/java/sql/Statement.html
.. _PreparedStatement: https://docs.oracle.com/javase/8/docs/api/java/sql/PreparedStatement.html
.. _CallableStatement: https://docs.oracle.com/javase/8/docs/api/java/sql/CallableStatement.html
.. _ResultSet: https://docs.oracle.com/javase/8/docs/api/java/sql/ResultSet.html
.. _ResultSet.next: https://docs.oracle.com/javase/8/docs/api/java/sql/ResultSet.html#next--
.. _DriverManager: https://docs.oracle.com/javase/8/docs/api/java/sql/DriverManager.html
.. _DataSource: https://docs.oracle.com/javase/8/docs/api/javax/sql/DataSource.html
.. _Resource: https://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html
.. _Oracle DB: https://www.oracle.com/index.html
.. _MySQL: https://www.mysql.com/
.. _PostgreSQL: https://www.postgresql.org/
.. _Apache Derby: http://db.apache.org/derby/
.. _SQLServer: https://docs.microsoft.com/fr-fr/sql/connect/jdbc/microsoft-jdbc-driver-for-sql-server
.. _SQLite: http://www.sqlite.org/
.. _HSQLDB: http://hsqldb.org/
.. _Maven Repository: http://mvnrepository.com/
.. _site d'Oracle: https://www.oracle.com/technetwork/database/features/jdbc/index-091264.html
.. _createStatement: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#createStatement--
.. _prepareCall: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#prepareCall-java.lang.String-
.. _prepareStatement: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#prepareStatement-java.lang.String-
.. _datasource configuration: http://tomee.apache.org/datasource-config.html
.. _common datasource configurations: http://tomee.apache.org/common-datasource-configurations.html
.. _setnull(int parameterindex, int sqltype): https://docs.oracle.com/javase/8/docs/api/java/sql/PreparedStatement.html#setNull-int-int-
.. _execute: https://docs.oracle.com/javase/8/docs/api/java/sql/Statement.html#execute-java.lang.String-
.. _executeQuery: https://docs.oracle.com/javase/8/docs/api/java/sql/Statement.html#executeQuery-java.lang.String-
.. _executeUpdate: https://docs.oracle.com/javase/8/docs/api/java/sql/Statement.html#executeUpdate-java.lang.String-
.. _rollback: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#rollback--
.. _setAutocommit: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#setAutoCommit-boolean-
.. _commit: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#commit--
.. _getAutocommit: https://docs.oracle.com/javase/8/docs/api/java/sql/Connection.html#getAutoCommit--
.. _ACID: https://fr.wikipedia.org/wiki/Propri%C3%A9t%C3%A9s_ACID


