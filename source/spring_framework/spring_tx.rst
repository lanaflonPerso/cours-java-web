Spring Transaction
##################

La transaction
**************

La notion de transaction est récurrente dans les systèmes d'information.
Par exemple, la plupart des SGBDR (Oracle, MySQL, PostGreSQL...) 
intègrent un moteur de transaction. Une transaction est
définie par le respect de quatre propriétés désignées par l'acronyme ACID_ :

Atomicité
  La transaction garantit que l'ensemble des opérations qui la composent sont
  soit toutes réalisées avec succès soit aucune n'est conservée.
Cohérence
  La transaction garantit qu'elle fait passer le système d'un état valide vers
  un autre état valide.
Isolation
  Deux transactions sont isolées l'une de l'autre. C'est-à-dire que leur
  exécution simultanée produit le même résultat que si elles avaient été
  exécutées successivement.
Durabilité
  La transaction garantit qu'après son exécution, les modifications qu'elle a
  apportées au système sont conservées durablement.

Une transaction est définie par un début et une fin qui peut être soit une
validation des modifications (*commit*), soit une annulation des modifications
effectuées (*rollback*). On parle de **démarcation transactionnelle** pour désigner
la portion de code qui doit s'exécuter dans le cadre d'une transaction.

La plupart des applications utilisent une gestion de transaction dans l'interaction
avec un SGBDR (puisque ce dernier fourni le moteur de transaction). Néanmoins il
existe d'autres types de systèmes d'information qui supportent les transactions.
C'est pour cette raison que la gestion des transactions est un domaine indépendant
des bases de données. Parmi les standards Java, JTA (*Java Transaction API*) est
précisément l'API officielle pour interagir avec un moteur transactionnel. Cependant,
cette API n'est pas systématiquement utilisée et il existe des solutions fournies
par des technologies particulières. Par exemple, Hibernate et JPA fournissent leur
propre solution et leur propre API pour gérer les transactions. Cela rend souvent
l'intégration des transactions dans une application complexe.

Spring Transaction est le module spécifique chargé de l'intégration des transactions.
Il offre plusieurs avantages : 

* Il fournit une abstraction au dessus des différentes
  solutions disponibles dans le monde Java pour les gestion des transactions.
  Cela permet une intégration plus simple.
* Il suit les mêmes principes que les autres modules du Spring Framework.
  Donc il peut être utilisé de manière non intrusive ou encore en ayant recours
  à des annotations.
* Il permet une gestion déclarative des transactions.

Transaction globale et transaction locale
*****************************************

Dans la configuration de la gestion des transactions, on distingue une gestion
globale (appelée aussi transaction distribuée) et une gestion locale. Une gestion
globale est utile lorsqu'une application interagit avec plusieurs systèmes transactionnels.
Cela peut, par exemple, survenir si une application utilise simultanément plusieurs
schémas de base de données et doit s'assurer de la cohérence des échanges.
La gestion globale permet d'orchestrer les interactions entre les différents systèmes.
Par exemple, si on annule la transaction avec un *rollback* alors la transaction
est annulée simultanément dans les différents systèmes transactionnels.

La transaction locale est plus simple car elle n'implique de gérer que l'interaction
entre l'application et un seul système transactionnel. Si votre application n'interagit
qu'avec une seule de base de données, alors la transaction locale suffit au besoin
de l'application.

Spring Transaction permet de gérer soit des transactions globales soit
des transactions locales. La différence se fait dans la configuration du contexte.
Donc cela signifie que le type de transaction n'a pas d'impact sur le code
de l'application. Une application conçue pour s'exécuter avec des transactions locales
pourra être reconfigurée pour utiliser des transactions globales.

.. _spring_tx_transaction_manager:

Déclaration d'un gestionnaire de transactions avec Spring
*********************************************************

Comme nous l'avons précisé au début de ce chapitre, la gestion de la transaction
dans une application Java / Java EE peut sembler compliquée du fait de la pluralité
des technologies existantes. Le module Spring Transaction essaie de simplifier cette situation
en utilisant une interface unique pour la gestion des transactions : 
PlatformTransactionManager_. Le module fournit ensuite plusieurs implémentations
selon la technologie sous-jacente utilisée.

.. list-table:: 
  :header-rows: 1
  
  * - Technologie tierce pour la gestion des transactions
    - Implémentation du PlatformTransactionManager_
  * - DataSource_ JDBC
    - DataSourceTransactionManager_
  * - JTA
    - JtaTransactionManager_
  * - JPA
    - JpaTransactionManager_
  * - Hibernate
    - HibernateTransactionManager_
    
Gestionnaire de transactions JTA
================================

Pour déclarer un gestionnaire de transactions compatible JTA dans un serveur
d'application Java EE, il suffit de récupérer la source de données à partir
d'un annuaire JNDI et de déclarer un *bean* de type JtaTransactionManager_.

.. code-block:: xml
  :caption: Configuration d'un gestionnaire de transactions JPA

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:jee="http://www.springframework.org/schema/jee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/jee
                             http://www.springframework.org/schema/jee/spring-jee.xsd">

    <jee:jndi-lookup id="dataSource" jndi-name="nomdeladatasource"/>

    <bean id="txManager" class="org.springframework.transaction.jta.JtaTransactionManager" />

  </beans>

Gestionnaire de transactions JPA
================================

Pour déclarer un gestionnaire de transactions pour JPA, il faut pouvoir configurer
dans le contexte d'application un *bean* de type EntityManagerFactory_ et l'injecter
dans un *bean* de type JpaTransactionManager_.

.. code-block:: xml
  :caption: Configuration d'un gestionnaire de transactions JPA
  
  <bean id="txManager" class="org.springframework.orm.jpa.JpaTransactionManager">
    <property name="entityManagerFactory" ref="entityManagerFactory" />
  </bean>

Pour créer le *bean* "entityManagerFactory", nous pouvons utiliser la classe
LocalContainerEntityManagerFactoryBean_ qui, comme l'indique son nom, permet
de créer un EntityManagerFactory_ pour des transactions locales.

Stratégie des transactions
**************************

Spring transaction définit 4 propriétés pour une transaction. Ensemble, elles forment
la stratégie des transactions au sein d'une application :

**Propagation**
  Le plus couramment, le code qui s'exécute entre le début et la fin de la transaction
  fait partie de la transaction. Cependant, il est possible de modifier ce comportement
  par défaut en indiquant comment la transaction se *propage*, notamment quand
  du code faisant partie d'une transaction invoque une méthode.
  
**Isolation**
  L'isolation fait partie des propriétés ACID_ d'une transaction. Cependant la
  plupart de systèmes transactionnels proposent différents niveaux d'isolation.
  L'application a la possibilité de définir le niveau qu'elle souhaite.

**Timeout**
  Cette propriété permet de préciser une durée au delà de laquelle la transaction
  doit être automatiquement annulée (*rollback*).

**Lecture seule** (*Read-only*)
  Cette propriété permet de préciser si la transaction est en lecture seule. Dans
  ce cas le code n'a pas la possibilité d'effectuer des modifications dans le ou
  les systèmes transactionnels. Cette propriété existe pour des raisons d'optimisation.
  En effet, quand un système transactionnel peut anticiper qu'aucune modification
  ne sera effectuée durant une transaction, il peut gérer la transaction avec
  moins de ressources.
  
**Conditions d'annulation** (*rollback*)
  Cette propriété permet de définir quand la transaction est considérée en échec
  et doit être obligatoirement annulée (*rollback*). L'échec d'une transaction
  est conditionnée à l'émission d'une exception dans le code Java.

Configuration déclarative des transactions
******************************************

Une fois qu'un :ref:`gestionnaire de transactions a été déclaré <spring_tx_transaction_manager>`
dans le contexte de l'application, il faut configurer la démarcation transactionnelle.
Spring Transaction utilise pour cela la programmation orientée aspect. Le principe
est le suivant : on déclare un ou des points de coupure (*pointcuts*) qui
déterminent quand une transaction doit se déclarer et on configure un greffon
(*advice*) spécialisé dans la gestion de transactions pour indiquer les stratégies
à appliquer.

.. code-block:: xml
  :caption: déclaration des transactions (avec un gestionnaire JTA)
  :linenos:

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:aop="http://www.springframework.org/schema/aop"
         xmlns:tx="http://www.springframework.org/schema/tx"
         xmlns:jee="http://www.springframework.org/schema/jee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/tx
                             http://www.springframework.org/schema/tx/spring-tx.xsd
                             http://www.springframework.org/schema/aop
                             http://www.springframework.org/schema/aop/spring-aop.xsd
                             http://www.springframework.org/schema/jee
                             http://www.springframework.org/schema/jee/spring-jee.xsd">

      <!-- Mise en place du gestionnaire de transactions -->
      <jee:jndi-lookup id="dataSource" jndi-name="nomdeladatasource"/>

      <bean id="txManager" class="org.springframework.transaction.jta.JtaTransactionManager" />

      <!-- Configuration des transactions -->
      <tx:advice id="txAdvice" transaction-manager="txManager">
          <tx:attributes>
              <tx:method name="get*" read-only="true"/>
              <tx:method name="*"/>
          </tx:attributes>
      </tx:advice>

      <!-- Configuration de l'aspect -->
      <aop:config>
          <aop:pointcut id="serviceOperation" 
                        expression="execution(* ROOT_PKG.service.*Service.*(..))"/>
          <aop:advisor advice-ref="txAdvice" pointcut-ref="serviceOperation"/>
      </aop:config>

      <!-- déclaration des autres beans -->

  </beans>

Pour l'exemple ci-dessus, nous pouvons laisser de côté les lignes 16 à 19 puisqu'elles
concernent la configuration du gestionnaire de transactions. Ce qu'il faut noter,
c'est que le *bean* du gestionnaire de transactions est appelé "txManager" et
qu'il est passé comme attribut à l'élément ``<tx:advice />``. Ce dernier
correspond au greffon (*advice*) spécialisé. Il est fourni par l'espace de nom XML
``http://www.springframework.org/schema/tx``. Dans notre exemple, on configure
deux stratégies *via* ce greffon :

* ligne 24, on indique que toutes les méthodes dont le nom commence par "get" appliquent
  une stratégie en lecture seule
* ligne 25, on indique que toutes les autres méthodes utilisent la stratégie
  par défaut.

À partir de la ligne 29, on déclare la configuration de l'aspect. Le greffon
doit être appliqué lors de l'appel à n'importe quelle méthode d'une classe
qui se trouve dans le package |ROOT_PKG|.service et dont le nom est suffixé
par "Service".

Cela signifie que si notre application contient la classe suivante :

.. code-block:: java

  package ROOT_PKG.service;
  
  public class UserService {
  
    public User getUser() {
      // ...
    }
    
    public void saveUser(User user) {
      // ...
    }
  }

Alors pour le *bean* créé à partir de cette classe, tout appel à ses méthodes
entraîne le commencement d'une nouvelle transaction et lorsque la méthode
retourne, la transaction associée est validée (*commit*).

.. note::

  Pour que cet exemple fonctionne, n'oubliez pas d'ajouter AspectJ au projet
  comme nous l'avons vu dans :ref:`l'exemple sur la programmation AOP <spring_aop_exemple>`.

Gestion déclarative du *rollback* pour les transactions
*******************************************************

Par défaut, une transaction est invalidée (*rollback*) uniquement si la méthode
transactionnelle échoue à cause d'une *unchecked* exception (une exception
héritant de RuntimeException_ ou une Error_). Dans tous les autres cas, la transaction
est validée (un *commit* est effectué). Donc si une méthode se termine par une
*checked* exception, Spring Transaction considère la transaction comme valide.

Si ce comportement par défaut ne convient pas, il est possible de modifier
la stratégie des transactions dans le contexte d'application grâce aux
attributs ``rollback-for`` et ``no-rollback-for`` dans le greffon.

.. code-block:: xml
  :caption: Configuration de la stratégie de *rollback*

  <!-- Configuration des transactions -->
  <tx:advice id="txAdvice" transaction-manager="txManager">
      <tx:attributes>
          <tx:method name="*" rollback-for="MonServiceException,DonneesInvalidesException"/>
      </tx:attributes>
  </tx:advice>

Avec la configuration ci-dessus, toutes les méthodes impactées par ce greffon
invalideront la transaction si elles se terminent par une exception dont
le nom est ``MonServiceException`` ou ``DonneesInvalidesException``.

Si on désire annuler une transaction pour n'importe quelle exception, alors
il suffit de configurer le greffon de la façon suivante :

.. code-block:: xml
  :caption: Configuration de la stratégie de *rollback*

  <!-- Configuration des transactions -->
  <tx:advice id="txAdvice" transaction-manager="txManager">
      <tx:attributes>
          <tx:method name="*" rollback-for="Throwable"/>
      </tx:attributes>
  </tx:advice>

En effet, Throwable_ est la classe mère de toutes les exceptions et de toutes
les erreurs.

.. note::

  L'attribut ``no-rollback-for`` est utilisé pour donner la liste des exceptions
  qui n'entraînent pas une invalidation de la transaction.

Utilisation de l'annotation @Transactional
******************************************

La configuration des transactions à partir des greffons et des aspects permet
une très grande souplesse tout en étant non intrusive dans
le code de l'application mais elle n'est nécessairement simple d'approche.

Avec Spring Transaction, il est également possible d'utiliser l'annotation
`@Transactional`_ sur les méthodes pour lesquelles on désire configurer une
délimitation transactionnelle.

.. code-block:: java

  package ROOT_PKG.service;

  import org.springframework.transaction.annotation.Transactional;
  
  public class UserService {

    @Transactional(readOnly=true)
    public User getUser() {
      // ...
    }
    
    @Transactional
    public void saveUser(User user) {
      // ...
    }
  }
  
L'annotation `@Transactional`_ supporte des propriétés afin de pouvoir configurer
le support de transaction de la même façon qu'avec un greffon en programmation
orientée aspect. Ainsi, l'attribut ``readOnly`` permet d'indiquer si la transaction
est en lecture seule (``false`` par défaut).

Pour activer le support des annotations, il faut ajouter l'élément ``<annotation-driven />``
de l'espace de nom XML ``http://www.springframework.org/schema/tx`` dans le
contexte d'application.

.. code-block:: xml
  :caption: Activation de la gestion des transactions par annotation

  <?xml version="1.0" encoding="UTF-8"?>
  <beans xmlns="http://www.springframework.org/schema/beans"
         xmlns:jee="http://www.springframework.org/schema/jee"
         xmlns:tx="http://www.springframework.org/schema/tx"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://www.springframework.org/schema/beans
                             http://www.springframework.org/schema/beans/spring-beans.xsd
                             http://www.springframework.org/schema/jee
                             http://www.springframework.org/schema/jee/spring-jee.xsd
                             http://www.springframework.org/schema/tx
                             http://www.springframework.org/schema/tx/spring-tx.xsd">

    <jee:jndi-lookup id="dataSource" jndi-name="nomdeladatasource"/>

    <bean id="txManager" class="org.springframework.transaction.jta.JtaTransactionManager" />

    <tx:annotation-driven transaction-manager="txManager"/>
    
  </beans>

.. todo::

  * notion de propagation
  * notion d'isolation

.. _ACID: https://fr.wikipedia.org/wiki/Propri%C3%A9t%C3%A9s_ACID

