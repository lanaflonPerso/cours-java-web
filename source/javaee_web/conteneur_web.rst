Le conteneur Web
################

Nous avons vu au chapitre précédent que les servlets sont des composants
Web qui permettent de répondre à des requêtes utilisateurs. Ces servlets
sont packagées dans une application Web qui est elle-même déployée dans
un serveur d'application Java EE. Cependant, nous n'avons pas eu à
écrire de lignes de code telles que :

::

    MaServlet servlet = new MaServlet();

C'est-à-dire que nous n'avons pas eu à instancier nos servlets et
pourtant, elles ont bien été créées et utilisées pour générer les
réponses dynamiques.

Un serveur Java EE fournit un **conteneur Web** (parfois appelé
conteneur de servlets). Un conteneur a la charge d'instancier,
d'initialiser et de détruire les servlets d'une application. C'est
également le conteneur qui fournit une instance de HttpServletRequest et
de HttpServletResponse pour chaque requête.

Nous allons voir en détail la gestion du cycle de vie des servlets par
le conteneur Web et les conséquences que cela a sur la façon de
développer une application Web.

Cycle de vie des servlets
*************************

Le conteneur Web gère le cycle de vie des servlets : la création,
l'initialisation et la destruction. À chacune de ces étapes, une
instance de servlet est informée par un appel à une méthode déclarée
dans l'interface Servlet_ et qui peut être redéfinie pour chaque servlet.

::

    public void init(ServletConfig config) throws ServletException {
      // appelée au moment de l'initialisation de la servlet
    }

    public void destroy() {
      // appelée avant la suppression de la servlet du conteneur
    }

De plus la servlet sera prévenue de sa création par un appel à son
constructeur. Cela a une conséquence importante pour l'implémentation
d'une servlet : **une servlet doit obligatoirement avoir un constructeur
sans paramètre**.

.. note::

    En Java, une classe qui ne déclare pas de constructeur dispose néanmoins
    d'un constructeur par défaut. Il s'agit d'un constructeur sans
    paramètre. Ainsi :

    ::

        public class MaClasse {

        }

    est équivalent à :

    ::

        public class MaClasse {
            public MaClasse() {
                super();
            }
        }

Lors de l'appel à la méthode ``init(ServletConfig)``, le conteneur passe
en paramètre une instance de ServletConfig_ 
qui permet, entre-autres, à la servlet de récupérer des paramètres
d'initialisation. Notez que la méthode ``init(ServletConfig)`` autorise
l'implémentation à jeter une ``ServletException``. Si cela se produit,
le conteneur considère que la servlet n'a pas pu s'initialiser
correctement et elle ne sera pas déployée dans le conteneur : elle ne
sera donc pas accessible !

Dans une servlet, il est préférable de redéfinir la méthode :

::

    public void init() throws ServletException {
    }

Cette méthode est définie dans la classe parente de HttpServlet_ et
si on désire accéder à l'objet ``ServletConfig``, il est possible de le
faire avec la méthode ``getServletConfig()``.


Exercice
********

.. admonition:: Comprendre le cycle de vie d'une servlet
    :class: hint

    **Objectif**
        Déployer une servlet qui trace les différentes étapes de son cycle
        de vie.
    **Modèle Maven du projet à télécharger**
        :download:`webapp-template.zip <assets/templates/webapp-template.zip>`
    **Mise en place du projet**
        Éditer le fichier pom.xml du template et modifier la balise
        artifactId pour spécifier le nom de votre projet.
    **Intégration du projet dans Eclipse**
        L'intégration du projet dans Eclipse suit la même procédure que
        celle vue dans :ref:`maven_eclipse_import`

    Pour cet exercice, vous allez déployer une servlet de log dont voici le
    code source :

    ::

        import java.io.IOException;

        import javax.servlet.ServletException;
        import javax.servlet.annotation.WebServlet;
        import javax.servlet.http.HttpServlet;
        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpServletResponse;

        @WebServlet("/log")
        public class LogServlet extends HttpServlet {

            private static final long serialVersionUID = 7446985734933559486L;

            @Override
            public void init() throws ServletException {
                System.out.println("################################# init " + getServletName());
            }

            @Override
            public void destroy() {
                System.out.println("################################# destroy " + getServletName());
            }

            @Override
            protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                resp.setCharacterEncoding("utf-8");
                resp.setContentType("text/plain");
                resp.getWriter().write(getServletName() + " called successfully");
            }

        }

    Vérifier dans les logs du serveur (onglet Console sous Eclipse)
    l'apparition des messages de log produits par la servlet lorsque vous
    faites les opérations suivantes :

    -  Lancement du serveur d'application
    -  Sollicitation de la servlet avec une requête HTTP depuis un
       navigateur Web (une ou plusieurs fois)
    -  Arrêt du serveur d'application (ou suppression de l'application du
       serveur en cours d'exécution)

    N'hésitez pas à tester plusieurs combinaisons possibles de ces actions.

    Que pouvez-vous en déduire concernant la façon dont un conteneur Web
    gère la création, l'initialisation et la suppression d'une servlet ?

    **Variation**
        Si maintenant vous modifiez l'annotation ``@WebServlet`` de la façon
        suivante :

        ::

            @WebServlet(urlPatterns = "/log", loadOnStartup = 0)

        Refaites l'exercice en essayant de constater si cela produit un
        changement dans le cycle de vie de la servlet.


Servlet et programmation concurrente
************************************

Avec l'exercice précédent, nous avons mis en lumière le fait que le
conteneur Web ne crée qu'une seule instance de chaque servlet. En fait,
le conteneur est libre d'adopter la stratégie qui lui paraît la
meilleure. Nous avons également constater que nous pouvons changer le
moment où le conteneur instanciera une servlet grâce à l'attribut
``loadOnStartup`` (cette option est disponible également dans le fichier
de déploiement web.xml avec la balise ``<load-on-startup>``).

En tant que développeur de servlet, il faut donc **toujours** garder à
l'esprit qu'une même instance de servlet sera utilisée pour servir
plusieurs requêtes HTTP, y compris des requêtes simultanées. Cela
introduit dans le développement de servlet, le problème de la
programmation concurrente. Tout changement de l'état interne d'une
servlet peut entraîner un bug potentiel pour des requêtes qui sont
traitées en parallèle.

Pour éviter tout problème, il faut s'assurer que les modifications des
attributs d'une servlet sont sûres dans un contexte d'exécution
concurrent. Il faut également s'assurer que les objets manipulés par la
servlet et qui ne sont pas explicitement créés pour une requête, peuvent
être utilisés dans un environnement concurrent (**thread-safe**).
Nous verrons que la problèmatique de programmation concurrente est
récurrente dans le développement d'application Java EE.

Exercice
********

.. admonition:: Servlet et programmation concurrente
    :class: hint

    **Objectif**
        Comprendre les risques de bug dans un contexte d'exécution
        concurrent.

    Plusieurs implémentations de servlet sont proposées ci-dessous. Toutes
    posent un problème d'exécution dans un environnement concurrent (elles
    ne sont pas thread-safe). Cherchez d'où provient le problème et quelles
    solutions proposeriez-vous pour le corriger.

    .. code-block:: java
        :caption: Cas 1 : la servlet de calcul

        import java.io.IOException;

        import javax.servlet.ServletException;
        import javax.servlet.http.HttpServlet;
        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpServletResponse;

        public class SumServlet extends HttpServlet {

            private static final long serialVersionUID = -7059227478134291799L;

            private int total;

            @Override
            protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                total = 0;
                for (String value : req.getParameterValues("value")) {
                    total += Integer.parseInt(value);
                }
                resp.setCharacterEncoding("UTF-8");
                resp.setContentType("text/plain");
                resp.getWriter().write("The total is " + total);
            }
        }

    .. code-block:: java
        :caption: Cas 2 : la servlet de temps

        import java.io.IOException;
        import java.text.DateFormat;
        import java.util.Date;

        import javax.servlet.ServletException;
        import javax.servlet.http.HttpServlet;
        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpServletResponse;

        public class TimeServlet extends HttpServlet {

            private static final long serialVersionUID = 7446985734933559486L;
            private final DateFormat dateInstance = DateFormat.getDateInstance(DateFormat.LONG);

            @Override
            protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                resp.setCharacterEncoding("UTF-8");
                resp.setContentType("text/plain");
                resp.getWriter().write(dateInstance.format(new Date()));
            }

        }

    .. code-block:: java
        :caption: Cas 3 : la servlet d'inscription d'un utilisateur

        import java.io.IOException;

        import javax.servlet.ServletException;
        import javax.servlet.http.HttpServlet;
        import javax.servlet.http.HttpServletRequest;
        import javax.servlet.http.HttpServletResponse;

        public class SubscriptionServlet extends HttpServlet {

            private static final long serialVersionUID = 7446985734933559486L;

            private HttpServletRequest firstStepRequest;

            @Override
            protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
                if ("first".equals(req.getParameter("step"))) {
                    this.firstStepRequest = req;
                    generateSecondStepPage(resp);
                }
                else {
                    String name = firstStepRequest.getParameter("name");
                    String age = firstStepRequest.getParameter("age");
                    String address = req.getParameter("address");
                    String city = req.getParameter("city");
                    createSubscription(name, age, address, city);
                    generateSubscriptionSuccessPage(resp);
                }
            }

            private void generateSecondStepPage(HttpServletResponse resp) throws IOException {
                // ...
            }

            private void generateSubscriptionSuccessPage(HttpServletResponse resp) 
            throws IOException {
                // ...
            }

            private void createSubscription(String name, String age, String address, String city) {
                // ...
            }
        }

.. _Servlet: https://docs.oracle.com/javaee/7/api/javax/servlet/Servlet.html
.. _ServletConfig: https://docs.oracle.com/javaee/7/api/javax/servlet/ServletConfig.html
.. _HttpServlet: https://docs.oracle.com/javaee/7/api/javax/servlet/http/HttpServlet.html

