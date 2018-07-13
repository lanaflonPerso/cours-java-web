Introduction
############

Le Spring Framework est très largement utilisé dans la communauté Java pour le
développement d'application pour les entreprises (notamment pour les applications
Web). Mais on trouve même des applications Java basées sur le Spring Framework...
dans des photocopieurs.

Pour comprendre l'origine et l'apport du Spring Framework, il faut savoir que
son principal auteur, Rod Johnson, ne voulait pas suivre la même direction que
celle prise par la plate-forme J2EE au début des années 2000.

J2EE proposait un environnement de déploiement d'application basé sur des serveurs
d'application qui devaient héberger les composants fournis par les développeurs
dans des conteneurs logiciels. Les composants à fournir (notamment pour les EJB 1.x)
devaient suivre une spécification technique assez complexe et lourde à mettre en
œuvre.

À l'opposé, le Spring Framework proposait de bâtir des applications avec
beaucoup moins de contraintes techniques et qui pouvait facilement être intégré
dans les applications. C'est pour cette raison, que l'on qualifie parfois
le Spring Framework de conteneur léger.

L'idée centrale du Spring Framework est de n'imposer aucune norme de développement
ni aucune contrainte technique sur la façon dont les développeurs doivent coder
leurs applications (pas d'héritage spécifique ou d'interface à implémenter obligatoirement).
Le Spring Framework se veut non intrusif et basé sur le principe de l'inversion
de contrôle (ou *Inversion of Control* IoC) et la programmation orientée Aspect
(*Aspect Oriented Programming* AOP). Il met en œuvre des modèles de conception
(comme les *factories*) pour fournir un environnement le plus souple possible.

Une des forces du Spring Framework est sa très grande modularité. En fonction
des besoins techniques de son application, il est possible d'incorporer tel ou
tel module du Spring Framework et de laisser de côté ceux qui ne sont pas
nécessaires.

Les modules Spring
******************

Le Spring Framework est découpé en modules pour faciliter son intégration
dans les projets.

.. image:: assets/spring_modules.png
  :alt: vue générale des modules Spring

Parmi ces modules, il y a les modules fondamentaux qui font partie du noyau
du Spring Framework (*core*) :

*Core*
  Les classes fondamentales utilisées par tous les autre modules

*Beans*
  Le module qui permet de manipuler les objets Java et de créer des *beans*

*Context*
  Introduit la notion de contexte d'application et fournit plusieurs implementétations
  de ces contextes. Avec ce module, il est possible de construire des conteneur
  léger IoC.

*SpEL*
  Ce module fournit un interpréteur pour le langage d'expression intégré au
  Spring Framework (*Spring Expression Language* ou *SpEL*).

Les autres modules du Spring Framework permettent majoritairement d'intégrer
dans une application des technologies tierces. Ainsi le Spring Framework agit
comme une glu qui permet de construire des applications par adjonctions de
fonctionnalités. Par exemple, Spring MVC est le module qui permet de créer
des applications Web basés sur le modèle MVC et de les déployer notamment dans une conteneur
de Servlet Java EE, Spring Data permet de gérer les interactions avec
des bases de données en utilisant diverses technologies : JDBC, JPA, Hibernate, MongoDB...

.. note::

  Si vous gérez votre projet avec Maven, alors chaque
  module du Spring Framework est disponible sous la forme d'un artefact Maven.

  Pour intégrer le noyau du Spring Framework, il suffit d'ajouter la dépendance
  avec Spring Core :

  .. code-block:: xml

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-core</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

  Généralement, une application qui utilise le Spring Framework a au minimum
  besoin de Spring Context pour pouvoir créer une contexte d'application :

  .. code-block:: xml

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

  Avec le mécanisme de dépendance transitive de Maven, la déclaration d'une dépendance
  avec ``spring-context`` permet de récupérer les autres dépendances minimales
  et suffit généralement pour commencer à implémenter une application basée sur
  le Spring Framework.

Les projets Spring
******************

En plus des modules, le Spring Framework s'est enrichi de projets bâtis sur le
Spring Framework et qui apportent des fonctionnalités de haut niveau. Contrairement
au Spring Framework, ces projets n'ont pas pour objectif d'être non intrusifs.

Parmi les projets Spring, on trouve :

* `Spring Boot <https://spring.io/projects/spring-boot>`_
* `Spring Cloud <https://projects.spring.io/spring-cloud>`_
* `Spring Data <https://spring.io/projects/spring-data>`_
* `Spring Security <https://spring.io/projects/spring-security>`_
* `Spring HATEOAS <https://spring.io/projects/spring-hateoas>`_

Documentation
*************

Un autre point fort du Spring Framework est la qualité de sa documentation.
Attention cependant, l'environnement du Spring Framework est très vaste et
donc il est très facile de se perdre dans la documentation.

Pour commencer, vous pouvez consulter la documentation sur Spring Core :

https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#spring-core

et plus généralement la documentation sur les principaux modules du Spring Framework :

https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/index.html

Pour avoir une vision d'ensemble des projets qui existent dans l'éco-système Spring :

https://spring.io/projects

Enfin les guides fournissent des réponses pratiques et rapides sur certains
points techniques :

https://spring.io/guides

