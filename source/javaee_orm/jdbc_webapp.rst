JDBC dans une application Web
#############################

JDBC (Java DataBase Connectivity) est l'API standard pour interagir avec les
bases données relationnelles en Java. Cette API peut être utilisée dans une
application Web.

.. _datasource_ref:

Déclaration d'une DataSource
****************************

Dans un serveur d'application, l'utilisation du DriverManager_ JDBC est remplacée
par celle de la DataSource_. L'interface DataSource_ n'offre que deux méthodes :

::

    // Attempts to establish a connection with the data source
    Connection getConnection()

    // Attempts to establish a connection with the data source
    Connection getConnection(String username, String password)

Il n'est pas possible de spécifier l'URL de connexion à la base de données
avec une DataSource_. Par contre une DataSource_ peut être injectée dans
n'importe quel composant Java EE grâce à l'annotation `@Resource`_ :

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

L'annotation `@Resource`_ permet de spécifier le nom de la DataSource_ grâce à
l'attribut *name*.

.. note::

    L'annotation `@Resource`_ se base sur **JNDI** (Java Naming and Directory
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

.. _configuration_datasource:

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
  </resource-ref>

Mais comment le serveur d'application fait-il pour lier
une DataSource_ avec une connexion vers une base de données ? Malheureusement,
il n'existe pas de standard et chaque serveur d'application dispose de sa
procédure. Nous allons voir dans la section suivante comment créer une DataSource_
spécifiquement pour Tomcat.

Déclaration d'une DataSource dans Tomcat
****************************************

Tomcat n'est pas à proprement parler un serveur d'application, il s'agit juste
d'un conteneur de Servlet. Néanmoins, il peut déployer des applications Web Java
et il supporte l'annotation `@Resource`_ ainsi que la configuration d'une
DataSource_ dans le serveur ou dans l'application.

Une connexion JDBC est réalisée à travers un pilote. Pour déclarer une DataSource_
vers une base de données MySQL, par exemple, nous devons installer le pilote
MySQL dans le serveur. Pour cela, il vous faut
`télécharger le pilote <http://mvnrepository.com/artifact/mysql/mysql-connector-java>`_
et le placer dans le répertoire :file:`lib` situé dans le répertoire
d'installation du serveur.

Une fois, le pilote ajouté, il est possible
de déclarer la DataSource_ dans le fichier :file:`conf/server.xml`. Si vous
utilisez Tomcat dans Eclipse, alors vous devez disposer d'un projet :file:`Servers`
qui a été créé automatiquement dans votre espace de travail. Dedans, se trouvent
toutes les configurations des serveurs que vous avez créés. Pour Tomcat 9, le
nom par défaut est :file:`Tomcat v9.0 Server at localhost-config`. Dans ce
répertoire, se trouve le fichier :file:`server.xml` qu'il va falloir modifier.

.. note::

  L'intégration de Tomcat dans Eclipse crée automatiquement une copie de la configuration
  originale du serveur pour chacune des instances de serveur créées dans Eclipse.
  Ainsi, il est possible de déclarer plusieurs serveurs Tomcat dans Eclipse qui
  possèdent chacun leur configuration spécifique.

Dans le fichier :file:`server.xml`, vous devez ajouter avant la fin de l'élement
``<Host />`` (aux environs de la ligne 150 du fichier), les informations
de déploiement de votre application :

.. code-block:: xml
  :caption: Exemple de balise de contexte de déploiement dans le fichier server.xml

  <Context docBase="nomAppli"
           path="/nomAppli"
           reloadable="true"
           source="org.eclipse.jst.jee.server:jdbc">
    <Resource name="[nomDataSource]"
              auth="Container"
              type="javax.sql.DataSource"
              maxTotal="100"
              maxIdle="30"
              maxWaitMillis="10000"
              username="[USERNAME]"
              password="[PASSWORD]"
              driverClassName="com.mysql.jdbc.Driver"
              url="jdbc:mysql://[HOST]:3306/[NOM BASE]" />
  </Context>


Si vous ne voulez pas modifier la configuration du serveur, il est possible
d'ajouter un fichier :file:`src/main/webapp/META-INF/context.xml` dans votre
projet Maven et de déclarer à l'intérieur l'élément ``<Resource />`` :

.. code-block:: xml
  :caption: Exemple de fichier context.xml dans l'application

  <Context>

    <Resource name="[nomDataSource]"
              auth="Container"
              type="javax.sql.DataSource"
              maxTotal="100"
              maxIdle="30"
              maxWaitMillis="10000"
              username="[USERNAME]"
              password="[PASSWORD]"
              driverClassName="com.mysql.jdbc.Driver"
              url="jdbc:mysql://[HOST]:3306/[NOM BASE]" />

  </Context>

.. note::

  Pour une présentation de la déclaration des *data sources* pour différents
  SGBDR, `reportez-vous à la documentation de Tomcat <https://tomcat.apache.org/tomcat-9.0-doc/jndi-datasource-examples-howto.html>`_.

Dans sa gestion des *data sources*, Tomcat inclut la gestion d'un *pool* de
connexions en s'appuyant sur la bibliothèque Apache DBCP. L'ensemble des
paramètres de configuration du *pool* de connexions est disponibles dans la
`documentation de DBCP <http://commons.apache.org/proper/commons-dbcp/configuration.html>`_.
Ces paramètres sont utilisables comme attributs de l'élément ``<Resource />``.

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
.. _@Resource: https://docs.oracle.com/javaee/7/api/javax/annotation/Resource.html
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


