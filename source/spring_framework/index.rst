
.. toctree::
   :caption: Spring Framework
   :maxdepth: 1

   /spring_framework/introduction
   /spring_framework/principe_ioc
   /spring_framework/application_context

/spring_framework/beans
/spring_framework/configuration_application_context
/spring_framework/gestion_ressources
/spring_framework/spel
/spring_framework/spring_test
/spring_framework/aop
/spring_framework/architecture_ntier



/spring_framework/introduction

* historique
* Spring vs Java EE
* notion module
* utilisation de Maven

/spring_framework/principe_ioc



/spring_framework/application_context

* Notion de container IoC
* BeanFactory
* ApplicationContext et XmlApplicationContext
* Première appli Spring
* Notion scope :  singleton et prototype (exemple avec Date)

* création par constructeur
* création par méthode statique
* création par factory

* types simples (conversion boolean, int, double, array, list, map)

* injection par construction
* injection par setter

* cycle de vie : méthode d'initialisation et méthode de destruction

* ApplicationContext en Java

/spring_framework/beans_annotation_driven

* déclaration dans le fichier d'application context <context:annotation-config/>
* @Autowired
* @Primary
* @Qualify
* JSR 330 utilisation des annotations standards @Inject, @Named
* Lifecycle callback : @PostConstruct @PreDestroy
* <context:component-scan
* @Component (annotation driven)

/spring_framework/configuration_application_context

* PropertyPlaceholderConfigurer

/spring_framework/gestion_ressources

* @Value


/spring_framework/spel
/spring_framework/spring_test
/spring_framework/aop
/spring_framework/architecture_ntier

