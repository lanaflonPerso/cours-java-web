Le langage d'expression SpEL
############################

Un langage d'expression est un langage de programmation simplifié qui permet
(comme son nom l'indique) d'évaluer une expression simple. Il permet, par exemple,
de manipuler un graphe d'objets en accédant à des propriétés. En Java EE, il existe
un langage d'expression (nommé simplement *EL* pour *Expression Language*) qui
permet notamment d'accéder à des données dans une page JSP.

Le Spring Framework introduit sont propre langage d'expression (nommé *SpEL*
pour *Spring Expression Language*). Il est très similaire à l'EL Java EE (tout
en étant plus expressif). Il permet notamment d'écrire des expressions plutôt
que des valeurs en dures dans le fichier de contexte d'application. Une expression
en SpEL est délimitée par ``#{`` ``}``.

Un exemple d'utilisation de SpEL
********************************

Imaginons que notre application contienne un objet de ``Configuration`` qui fournissent
l'URI d'un service.

.. code-block:: java
  :caption: Exemple de classe Configuration

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class Configuration {

    public String getUrl() {
      return "uri du service";
    }

  }



D'un autre côté, une classe ``Service`` doit être construite
en lui fournissant l'URI du service connue de la classe ``Configuration``

Un première implémentation pourrait être :

.. code-block:: java
  :caption: Exemple de classe Service

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class Service {
    private String url;

    public Service(Configuration configuration) {
      this.url = configuration.getUrl();
    }

    // ...

  }

Et enfin, on peut définit le contexte d'application :

.. code-block:: xml
  :caption: Le contexte d'application

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="configuration" class="{{ROOT_PKG}}.Configuration"/>

    <bean name="service" class="{{ROOT_PKG}}.Service">
      <constructor-arg ref="configuration"/>
    </bean>
  </beans>

Même si cette implémentation fonctionne parfaitement, elle a un inconvénient :
la classe ``Service`` est obligée de connaître la classe ``Configuration``. Ce
que nous souhaiterions plutôt, c'est que le Spring Framework injecte le contenu
de la propriété ``url`` du *bean* nommé "configuration". La classe ``Service``
pourrait alors être implémentée comme ceci :

.. code-block:: java
  :caption: Exemple de classe Service sans dépendance à la classe Configuration

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  public class Service {
    private String url;

    public Service(String url) {
      this.url = url;
    }

    // ...

  }

Pour arriver à cette implémentation, nous pouvons utiliser SpEL dans la définition
du contexte d'application :

.. code-block:: xml
  :linenos:

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="configuration" class="{{ROOT_PKG}}.Configuration"/>

    <bean name="service" class="{{ROOT_PKG}}.Service">
      <constructor-arg value="#{ configuration.url }"/>
    </bean>
  </beans>

À la ligne 10, nous injectons comme valeur pour le paramètre ``url`` le résultat
de l'expression ``#{ configuration.url }``.

Principe de SpEL
****************

Dans la définition de contexte, on peut référencer n'importe quel *bean* dans
une expression par son nom et on peut accéder à ses propriétés grâce à l'opérateur
``.``.

On peut également utiliser les opérateurs arithmétiques et logiques dans une expression.

.. code-block:: text
  :caption: Quelques exemples d'expressions avec SpEL

  #{ produit.dateLimite }

  #{ produit.quantite - 1 }

  #{ 1024 * 1024 * 1024 }

  #{ produit.quantite > 0 && produit.quantite < 100 }

Il est également possible d'appeler des méthodes sur des *beans*

.. code-block:: text

  #{ produit.nom.toUppercase() }

ou des méthodes statiques

.. code-block:: text

  #{ T(java.lang.Math).random() * 100.0 }


Dans l'exemple ci-dessus le résultat de l'évaluation est un nombre aléatoire
entre 0 et 100.

.. note::

  L'opérateur spécial ``T()`` permet d'indiquer dans une expression que l'on
  référence une classe est non pas un *bean*.

Il est possible de manipuler le contenu de tableaux, de listes ou de dictionnaires
(Map_) grâce à l'opérateur ``[]``. Il existe un objet implicite nommé "systemProperties"
qui correspond à un dictionnaire des propriétés systèmes au moment de l'exécution
de la JVM. L'expression suivante :

.. code-block:: text

  #{ systemProperties['user.name'] }

Retourne la valeur de la propriété système "user.name" qui correspond au nom
de la session utilisateur qui exécute la JVM.

Il est également possible de créer dans une expression, un tableau, une liste ou
un dictionnaire (Map_) :

.. code-block:: text
  :caption: Expression pour la création d'une liste ou d'un tableau

  #{ {1,2,3,4} }

.. code-block:: text
  :caption: Expression pour la création d'un dictionnaire

  #{ {prenom: 'David', nom: 'Gayerie'} }

Un usage plus avancé des expressions est la projection. Imaginons que nous disposions
d'un *bean* annuaire qui contienne une liste de personnes. Chaque personne dispose
d'une adresse contenant le nom de la ville. Si nous souhaitons récupérer la liste
de toutes les villes nous pouvons utiliser une projection :

.. code-block:: text
  :caption: Expression avec une projection

  #{ annuaire.personnes.![adresse.ville] }

.. note::

  Pour une présentation complète du langage SpEL, reportez-vous à la
  `documentation officielle <https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#expressions-language-ref>`_.

.. _spring_spel_annotation:

Utilisation de SpEL dans les annotations
****************************************

Si nous utilisons des annotations pour déclarer notre contexte d'application, alors
il est tout à fait possible d'utiliser SpEL, notamment avec l'annotation `@Value`_.
Si nous reprenons notre exemple de la classe ``Configuration`` et ``Service`` :

.. code-block:: java
  :caption: La classe Configuration

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.stereotype.Component;

  @Component
  public class Configuration {

    public String getUrl() {
      return "url du service";
    }

  }

.. code-block:: java
  :caption: La classe Service

{% if not jupyter %}
  package {{ROOT_PKG}};
{% endif %}

  import org.springframework.beans.factory.annotation.Value;
  import org.springframework.stereotype.Component;

  @Component
  public class Service {
    private String url;

    public Service(@Value("#{ configuration.url }") String url) {
      this.url = url;

      System.out.println(this.url);
    }

    // ...

  }

.. code-block:: xml
  :caption: Le fichier de contexte d'application

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:context="http://www.springframework.org/schema/context"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
                        http://www.springframework.org/schema/beans/spring-beans.xsd
                        http://www.springframework.org/schema/context
                        http://www.springframework.org/schema/context/spring-context.xsd">

    <context:component-scan base-package="{{ROOT_PKG}}" />

  </beans>

.. _Map: https://docs.oracle.com/javase/8/docs/api/java/util/Map.html
.. _@Value: https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/beans/factory/annotation/Value.html

