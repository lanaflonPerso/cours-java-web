Les exceptions
##############

La gestion des cas d'erreur représente un travail important dans la programmation.
Les sources d'erreur peuvent être nombreuses dans un programme. Il peut s'agir :

* d'une défaillance physique ou logiciel de l'environnement d'exécution. Par
  exemple une erreur survient lors de l'accès à un fichier ou à la mémoire.
* d'un état atteint par un objet qui ne correspond pas à un cas prévu. Par
  exemple si une opération demande à positionner une valeur négative alors
  que cela n'est normalement pas permis par la spécification du logiciel.
* d'une erreur de programmation. Par exemple, un appel à une méthode est réalisé
  sur une variable dont la valeur est **null**.
* et bien d'autres cas encore...

La robustesse d'une application est souvent comprise comme sa capacité à continuer
à rendre un service acceptable dans un environnement dégradé, c'est-à-dire quand 
toutes les conditions attendues normalement ne sont pas satisfaites.

En Java, la gestion des erreurs se confond avec la gestion des cas exceptionnels.
On utilise alors le mécanisme des exceptions.

Qu'est-ce qu'une exception ?
****************************

Une exception est une classe Java qui représente un état particulier et qui
hérite directement ou indirectement de la classe Exception_. Par convention, le 
nom de la classe doit permettre de comprendre le type d'exception et doit
se terminer par Exception.

Exemple de classes d'exception fournies par l'API standard :

NullPointerException_
  Signale qu'une référence **null** est utilisée pour invoquer une méthode
  ou accéder à un attribut.

NumberFormatException_
  Signale qu'il n'est pas possible de convertir une chaîne de caractères en nombre
  car la chaîne de caractère ne correspond pas à un nombre valide.

IndexOutOfBoundsException_
  Signale que l'on tente d'accéder à un indice de tableau en dehors des valeurs
  permises.

Pour créer sa propre exception, il suffit de créer une classe héritant
de la classe java.lang.Exception_.

::

  package ROOT_PKG;
  
  public class FinDuMondeException extends Exception {
  
    public FinDuMondeException() {
      super();
    }

    public FinDuMondeException(String message) {
      super(message);
    }
  }

.. note::

  La classe Exception_ fournit plusieurs constructeurs que l'on peut ou non
  appeler depuis la classe fille.

Une exception étant un objet, elle possède son propre état et peut ainsi stocker
des informations utiles sur le contexte d'exécution.

::

  package ROOT_PKG;
  import java.time.Instant;
  
  public class FinDuMondeException extends Exception {
  
    private Instant date = Instant.now();

    public FinDuMondeException() {
      super("La fin du monde est survenue le " + Instant.now());
    }

    public Instant getDate() {
      return date;
    }
  }


Signaler une exception
**********************

Dans les langages de programmation qui ne supportent pas le mécanisme des
exceptions, on utilise généralement un code retour ou une valeur booléenne 
pour savoir si une fonction ou une méthode s'est déroulée correctement.
Cette mécanique se révèle assez fastidieuse dans son implémentation car cela
signifie qu'un développeur doit tester dans son programme toutes les valeurs
retournées par les fonctions ou les méthodes appelées

Les exceptions permettent d'isoler le code responsable du traitement de l'erreur.
Cela permet d'améliorer la lisibilité du code source.

Lorsqu'un programme détecte un état exceptionnel, il peut le signaler en *jetant*
une exception grâce au mot-clé **throw**.

::

  if(isPlanDiaboliqueReussi()) {
    throw new FinDuMondeException();
  }

.. note::

  La classe Exception_ implémente l'interface Throwable_. Le mot-clé **throw**
  peut en fait être utilisé avec n'importe quelle instance qui implémente 
  l'interface Throwable_.
  
Jeter une exception signifie que le flot d'exécution normal de la méthode
est interrompu jusqu'au point de traitement de l'exception. Si aucun point
de traitement n'est trouvé, le programme s'interrompt.

Traiter une exception
*********************

Pour traiter une exception, il faut d'abord délimiter un bloc de code avec le
mot-clé **try**. Ce bloc de code correspond au flot d'exécution pour lequel
on souhaite éventuellement modifier le comportement du programme si une
exception est jetée. Le bloc **try** peut être suivi d'un ou plusieurs
blocs **catch** pour intercepter une exception d'un type particulier.



Remontée d'une exception
************************

mot-clé throws


Hiérarchie applicative d'exception
**********************************


Exception cause
***************


Les erreurs (Error)
*******************


Checked exception et unchecked exception
****************************************



.. _java.lang.Exception: https://docs.oracle.com/javase/8/docs/api/java/lang/Exception.html
.. _Throwable: https://docs.oracle.com/javase/8/docs/api/java/lang/Throwable.html
.. _Exception: https://docs.oracle.com/javase/8/docs/api/java/lang/Exception.html
.. _NullPointerException: https://docs.oracle.com/javase/8/docs/api/java/lang/NullPointerException.html
.. _NumberFormatException: https://docs.oracle.com/javase/8/docs/api/java/lang/NumberFormatException.html
.. _IndexOutOfBoundsException: https://docs.oracle.com/javase/8/docs/api/java/lang/IndexOutOfBoundsException.html
