Spring DAO
##########

DAO (*Data Access Object*) est responsabilité qui est souvent utiliser dans
les applications d'entreprise. Dans le code source d'une application, on peut
trouver des classes nommées ``UserDao``, ``ProducDao``... Ce suffixe "Dao" dénote
que la classe a pour responsabilité d'accéder au système d'information pour lire
ou modifier des données. Comme la plupart des applications d'entreprise stockent
leurs données dans une base de données, les classes DAO sont donc les classes
qui contiennent le code qui permet d'échanger des informations avec la base de données.
En Java, selon la technologie utilisée, il peut s'agir des classes qui utilisent
l'API JDBC ou JPA par exemple.

Spring DAO reprend ce principe d'architecture en cherchant à simplifier l'intégration
et l'implémentation des interactions avec les bases de données.

L'annotation @Repository
************************





.. todo::

  * annotation @Repository
  * utilisation du jdbcTemplate (hiérarchie des exceptions)
  * injection de l'EntityManager (@PersistenceContext)
  * gestion de la datasource dans le container ou locale
