Configuration d'un contexte d'application
#########################################

Le Spring Framework ne fournit pas uniquement un conteneur IoC, il fournit
également un nombre impressionnant de classes qui permettent d'enrichir le 
comportement par défaut du framework. Parmi elles, il y a les 
classes implémentant les interfaces BeanPostProcessor_ et BeanFactoryPostProcessor_. 
Ces classes utilitaires permettent d'effectuer des traitements sur le contenu
du contexte d'application et donc apporter des modifications sur les *beans* qui
sont créés.

Le PropertyPlaceholderConfigurer
********************************

L'une de ces classes de post-traitement mérite particulièrement l'attention, il s'agit du 
PropertyPlaceholderConfigurer_. Cette classe permet de substituer n'importe quelle
valeur d'un attribut du fichier XML de configuration par une valeur déclarée dans
une fichier de configuration externe. Ainsi le Spring Framework nous offre un
mécanisme simple et puissant pour créer facilement des fichiers de configuration
pour nos applications.

Un PropertyPlaceholderConfigurer_ a au moins besoin de connaître le chemin du
fichier properties qui contient les valeurs à substituer. Comme pour toutes les
ressources accédées par le Spring Framework, ce fichier peut se trouver sur
le système de fichier, dans le *classpath* voire même sur le Web. On peut
ainsi déclarer un PropertyPlaceholderConfigurer_ de la façon suivante :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer">
      <property name="location" value="classpath:configuration.properties" />
    </bean>

  </beans>

En utilisant l'espace de nom XML ``context``, il existe un élément 
``property-placeholder`` qui simplifie l'écriture de la configuration :

.. code-block:: xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd">

    <context:property-placeholder location="classpath:configuration.properties" />

  </beans>

.. hint::

  L'attribut ``location`` accepte plusieurs chemins de fichiers séparés par une virgule.
  Les fichiers suivants dans la liste surchargent les précédents. Si une même propriété est définie
  dans deux fichiers alors c'est la valeur du fichier le plus à droite dans la liste
  qui sera retenue. Il est ainsi facile de créer des fichiers de configuration internes
  à l'application (dans le *classpath* par exemple) avec une configuration par
  défaut et des fichiers de configuration externes spécifiques à chaque déploiement
  de l'application qui ne contiennent que les valeurs à surcharger.

Les propriétés à remplacer dans le fichier de contexte d'application sont encadrées
par ``${`` ``}``.

Il est par exemple très simple d'externaliser dans un fichier de configuration
les identifiants d'accès à une base de données :

.. code-block:: properties
  :caption: Fichier jdbc.properties

  db.username=john
  db.password=doe
  db.url=jdbc:mysql://localhost:3306/mabase

.. code-block:: xml
  :caption: Utilisation du PropertyPlaceholderConfigurer pour configurer les accès JDBC

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd">

      <context:property-placeholder location="classpath:jdbc.properties"/>
      
      <bean name="dbConnection" class="java.sql.DriverManager" 
            factory-method="getConnection" destroy-method="close">
        <constructor-arg value="${db.url}"/>
        <constructor-arg value="${db.username}"/>
        <constructor-arg value="${db.password}"/>
      </bean>

  </beans>

Comme le PropertyPlaceholderConfigurer_ permet de remplacer n'importe quelle valeur
d'un attribut du document XML, il est même possible de rendre configurable
les classes des *beans*. Cela permet de construire des applications différentes
en fonction de la configuration.

.. code-block:: properties
  :caption: Fichier configuration.properties

  bean.classe=MonBean
  # bean.classe=MonAutreBean
  # bean.classe=MonSimulateur

.. code-block:: xml
  :caption: Utilisation du PropertyPlaceholderConfigurer pour configurer la classe d'un bean

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/context
                             http://www.springframework.org/schema/context/spring-context.xsd">

      <context:property-placeholder location="classpath:configuration.properties"/>
      
      <bean class="ROOT_PKG.${bean.classe}"> 
      </bean>

  </beans>

.. hint::

  On peut fournir une valeur par défaut à une propriété en utilisant ``:``.
  
  .. code-block:: text
  
    ${mapropriete:valeur}

.. note::

  Il existe également le PropertyOverrideConfigurer_ qui permet de surcharger
  la valeur d'une propriété d'un *bean* en utilisant une convention de nom
  pour la propriété de la forme :
  
  .. code-block:: properties
  
    nombean.nompropriete=valeur

  Pour plus d'information, reportez-vous à la 
  `documentation officielle <https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-overrideconfigurer>`_.

.. _BeanFactoryPostProcessor: https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-extension-factory-postprocessors
.. _BeanPostProcessor: https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-extension-bpp
.. _PropertyPlaceholderConfigurer: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/config/PropertyPlaceholderConfigurer.html
.. _PropertyOverrideConfigurer: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/config/PropertyOverrideConfigurer.html

