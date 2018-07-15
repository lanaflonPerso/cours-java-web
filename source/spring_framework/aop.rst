Spring AOP : programmation orientée aspect
##########################################

En programmation objet, il arrive souvent que l'on trouve des portions de code qui
se répètent à travers différentes méthodes. Par exemple, pour une application qui accède à une base
de données, chaque interaction avec la base de données doit s'inscrire dans
une transaction. Même si nous concevons une architecture objet avec une classe
spécialisée pour gérer une transaction, nous allons devoir faire appel à cette
classe dans chaque méthode qui interagit avec la base de données.

Ce type d'implémentation relève souvent d'une problématique technique sans rapport directe
avec ce que fait l'application. Dans des applications pour les entreprises, ce
type de problématique est souvent lié à la gestion des transactions, à l'écriture
de fichiers de log ou encore à la sécurité (contrôler si une partie du code
de l'application peut être appelée dans un certain contexte d'exécution).

La programmation orientée objet ne fournit pas de solution élégante à ce type
de situation. C'est pour résoudre spécifiquement ces cas de figure que la
**programmation orientée aspect** a été introduite.

La programmation orientée aspect n'est pas une notion propre au Spring Framework.
Le module qui est chargé de l'intégrer dans le framework est appelé
Spring AOP (AOP pour *Aspect Oriented Programming*).

Principe de la programmation orientée aspect
********************************************

La programmation orientée aspect (POA) est utilisée pour implémenter des
fonctionnalités transverses (*cross-cutting concerns*). Elle permet de rendre
l'architecture plus modulaire. Un **aspect** représente la réalisation d'une fonction
particulière (par exemple écrire dans un fichier de log). Plutôt que de répéter
(ou d'appeler) ce code dans les différentes classes de l'application, nous allons
définir des points à partir desquels l'aspect devra s'exécuter. Puis à l'aide
d'un tisseur d'aspects (*weaver*), le flot normal d'exécution de l'application
va être modifié afin d'exécuter l'aspect aux points voulus.

Dans la POA, on distingue l'approche statique et l'approche dynamique. L'approche
statique modifie le code au moment de la compilation afin d'introduire aux points
voulus l'exécution des aspects. Cette approche est un peu complexe à prendre en charge
car elle nécessite une étape supplémentaire à la compilation. L'approche dynamique
est réalisée au moment de l'exécution. Elle ne nécessite donc pas de compilation
particulière. Elle peut néanmoins nécessiter une instrumentation du code au moment
du chargement des classes dans la JVM mais ce processus est transparent pour
le développeur. L'approche dynamique introduit un coût à l'exécution puisqu'une
bibliothèque tierce doit prendre en charge l'exécution des aspects. En pratique,
ce surcoût est négligeable.

.. note::

  Spring AOP permet à la fois de réaliser de la POA
  statique (en intégrant la bibliothèque tierce AspectJ) et de la POA dynamique (
  au chargement des classes avec AspectJ ou à l'exécution grâce
  au mécanisme des proxies Java et/ou en utilisant la bibliothèque tierce CGLIB).

Terminologie de la programmation orientée aspect
************************************************

La POA introduit un vocabulaire spécifique pour décrire le mécanisme de
traitement de problématiques transverses (*cross-cutting concerns*) :

Aspect
  La problématique spécifique que l'on veut ajouter transversalement à notre
  architecture : par exemple la gestion des transactions avec la base de données.

Point de jonction (*JoinPoint*)
  Un point dans le flot d'exécution d'un programme à partir duquel on souhaite
  ajouter la logique d'exécution de l'aspect. Par exemple au moment de l'appel
  d'une méthode ou à l'instanciation d'une classe.

Greffon (*Advice*)
  L'action particulière de l'aspect, c'est-à-dire le code à exécuter à un point
  de jonction. Si le point de jonction correspond à l'appel d'une méthode,
  le greffon peut spécifier que le code doit s'exécuter avant ou après l'appel
  à la méthode par exemple.

Coupe (*Pointcut*)
  Une expression qui définit l'ensemble des points de jonctions éligibles pour
  le greffon. Par exemple :

  .. code-block:: java

    execution(* ROOT_PKG.Service.*(...))

  pour indiquer l'appel à n'importe quelle méthode de la classe ``Service``.

Objet cible (*Target object*)
  L'objet sur lequel est appliqué l'aspect.

Tissage (*Weaving*)
  Le processus qui permet de réaliser l'insertion de l'aspect soit au moment
  de la compilation (POA statique) soit au moment de l'exécution (POA dynamique).

Introduction
  Le processus qui permet à un aspect d'ajouter une méthode ou un attribut à un
  objet lors du tissage.

.. _spring_aop_exemple:

Exemple de programmation orientée aspect avec Spring AOP
********************************************************

Imaginons que notre application contienne une classe ``BusinessService`` qui
réalise un traitement important pour notre application :

::

  package ROOT_PKG;

  public class BusinessService {

    public void doSomething() {
       System.out.println("réalise un traitement important pour l'application");
       // ...
    }

  }

Si nous voulons tracer le début de chaque appel et la fin de chaque appel
d'une méthode de cette classe, nous pouvons ajouter du code au début et à la fin
de la méthode ``doSomething``. Mais si nous voulons faire la même chose pour
toutes les méthodes de toutes les classes dont le nom est suffixé par le mot "Service"
alors nous alors devoir dupliquer du code. Si nous utilisons la POA et Spring OAP,
nous pouvons plutôt créer une classe qui va jouer le rôle de greffon (*advice*) :

::

  package ROOT_PKG;

  public class SimpleLogger {

    public void logAvant() {
      System.out.println("Log avant");
    }

    public void logApres() {
      System.out.println("Log après");
    }
  }

Puis nous pouvons configurer le contexte d'application Spring.
L'espace de nom XML ``http://www.springframework.org/schema/aop`` fournit
des éléments XML pour configurer un tissage d'aspect. Nous pouvons ainsi
configurer un aspect de manière à ce que
la méthode ``SimpleLogger.logAvant`` soit invoquée avant tous les appels à la méthode
``BusinessService.doSomething`` et la méthode ``SimpleLogger.logApres`` soit
invoquée après tous les appels à la méthode ``BusinessService.doSomething``.

.. code-block:: xml
  :caption: le fichier application-context.xml

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:aop="http://www.springframework.org/schema/aop"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/aop
                             http://www.springframework.org/schema/aop/spring-aop.xsd">

      <bean name="businessService" class="ROOT_PKG.BusinessService"/>

      <bean name="logger" class="ROOT_PKG.SimpleLogger"/>

      <aop:config>
        <aop:aspect ref="logger">
          <aop:before method="logAvant" pointcut-ref="logPointcut"/>
          <aop:after method="logApres"  pointcut-ref="logPointcut"/>
          <aop:pointcut id="logPointcut"
                        expression="execution(* ROOT_PKG.*Service.*())"/>
        </aop:aspect>
      </aop:config>

  </beans>

Enfin le code de l'application :

::

  package ROOT_PKG;

  import org.springframework.context.support.GenericXmlApplicationContext;

  public class Application {

    public static void main(String[] args) throws Exception {
      try(GenericXmlApplicationContext appCtx = new GenericXmlApplicationContext("file:application-context.xml")) {
        BusinessService service = appCtx.getBean("businessService", BusinessService.class);
        service.doSomething();
      }
    }

  }

.. note::

  Pour fonctionner ce programme a besoin de Spring AOP et de AspectJ. Vous
  pouvez les ajouter comme dépendances à votre projet Maven :

  .. code-block:: xml

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aop</artifactId>
      <version>5.0.7.RELEASE</version>
    </dependency>

    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjrt</artifactId>
      <version>1.9.1</version>
    </dependency>

    <dependency>
      <groupId>org.aspectj</groupId>
      <artifactId>aspectjweaver</artifactId>
      <version>1.9.1</version>
    </dependency>

À l'exécution de ce programme, la sortie standard affiche

.. code-block:: text

  Log avant
  réalise un traitement important pour l'application
  Log après

La classe ``SimpleLogger`` a bien été traitée comme un greffon et ses méthodes
sont invoquées automatiquement avant et après un appel à ``BusinessService.doSomething``.
La POA permet donc d'enrichir l'exécution d'un programme sans avoir besoin d'impacter
le code source (notamment pour notre exemple le code source de ``BusinessService``).

.. note::

  L'exemple ci-dessus est une mise en pratique très simple de la PAO. Pour la plupart
  des usages, il n'est pas nécessaire de connaître en détail le module Spring AOP. En effet, peu
  d'applications s'en servent explicitement. Par contre, il est important de
  comprendre les mécanismes généraux de la POA car ils sont utilisés en
  arrière-plan par certains modules du Spring Framework, et notamment par
  Spring Transaction.

