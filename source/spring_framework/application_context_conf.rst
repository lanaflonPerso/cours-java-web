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
      <property name="locations" value="classpath:configuration.properties" />
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



.. _BeanFactoryPostProcessor: https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-extension-factory-postprocessors
.. _BeanPostProcessor: https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-factory-extension-bpp
