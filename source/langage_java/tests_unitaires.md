# Tests Unitaires #

Lorsque des débutants commencent à écrire des méthodes, ils les invoquent traditionnellement à partir de la classe main et ils vérifient le résultat à la main.
Ecrire du code de cette manière peut être répétitifs et des outils permettent de rendre l'écriture plus facile.
Dans les cas où nous connaissons la bonne réponse, la meilleure solution est d'écrire des tests unitaires.

```java
public static void main(String[] args) {
if (fibonacci(1) != 1) {
System.err.println("fibonacci(1) is incorrect");
}
if (fibonacci(2) != 1) {
System.err.println("fibonacci(2) is incorrect");
}
if (fibonacci(3) != 2) {
System.err.println("fibonacci(3) is incorrect");
}
}
```

Le code ci-dessus se comprend directement, mais il pourrait être raccourci et ne passe pas très bien à l'échelle si de nombreuses fonctionnalités viennent à être ajoutée.
En outre, les messages d'erreur fournissent une information très limitée.
L'utilisation d'une librairie de test unitaires permet de s'affranchir de ces problèmes.
**Junit** est un outil de test très répendu en Java (voir [http://junit.org](http://junit.org)).
Pour l'utiliser, nous avons besoin de créer une classe de test qui contient des méthodes de tests.

Si le nom de la class que vous souhaitez tester est  *Class*, le nom de votre classe de test sera *ClassTest* et héritera de la classe *junit.framework.TestCase* .
De la même manière, si votre classe *Class* contient une méthode appellée *method*, il devrait y avoir une méthode dans *TestClass* appellées *testMethod* annotée avec **@Test**.

Par exemple, en supposant que nous souhaitons tester le comportement de la classe Series suivante, qui propose de calculer entre autres une série des nombres de fibonacci:

```java
/**
* This class implements useful series helpers
*/
public class Series{
    /**
    * implements fibonacci number suites
    * @param l the index of the suite
    * @return the fibonacci number
    */
    public static long fibonacci(long l){
        if (l==1) return 1;
        else if(l==2) return 1;
        else return fibonacci(l-1) + fibonacci(l-2);
    }
}
```

voici la classe de test Junit correspondante:

```java
import junit.framework.TestCase;
import org.junit.Test;
  public class SeriesTest extends TestCase {

    @Test
    public void testFibonacci() {
        assertEquals(1, Series.fibonacci(1));
        assertEquals(1, Series.fibonacci(2));
        assertEquals(2, Series.fibonacci(3));
      }
}
```

```java
import java.util.List;

import junit.framework.TestCase;
import org.junit.runner.*;
import org.junit.Test;
import org.junit.runner.Result;
import org.junit.runner.JUnitCore;
import org.junit.runners.model.TestClass;
import org.junit.runner.notification.Failure;

public class SeriesTest  extends TestCase{

    @Test
    public void testFibonacci() {
        assertEquals(1, Series.fibonacci(1));
        assertEquals(1, Series.fibonacci(2));
        assertEquals(2, Series.fibonacci(3));
      }
}

// this is used to run junit tests in Jupyter.
// This is not necessary with BlueJ or any other IDE
Result result = JUnitCore.runClasses(SeriesTest.class);
List<Failure> failures = result.getFailures();
if(failures.size()==0){
    System.out.println("All good!");
}
else{
    for(Failure f : result.getFailures()) {
          System.out.println(f.getDescription());
          System.out.println(f.getMessage());
    }
}

```

Cet exemple utilise le mot clé *extends* qui indique que la nouvelle classe SeriesTest est basée sur une classe existante, TestCase, importée à partir du package *junit.framework*.

## Génération des tests par les environnements ##

De nombreux environnements de développement peuvent générer automatiquement des classes de teste et des méthodes de tests.

- Bluej permet de créer des classes de test en faisant un clic droit sur une classe.
- Eclipse/Netbeans/IntellijIDEA permettent également de créer des test unitaires à l'aide des menus.


## Méthodes d'assertion ##

Dans l'exemple ci-dessus, la méthode assertEquals est fournie par la classe TestCase.
Elle prend deux arguments et vérifie qu'ils sont égaux.
Si c'est bien le cas, rien ne se passe; sinon, elle affiche un message d'erreur détaillé.

Traditionnellement, le premier argument est la "*valeur attendue*", celle que l'on considère correcte, et le deuxième argument est la valeur réelle que nous souhaitons vérifier.
Lorsque les deux valeurs divergent, le test est en échec.

L'Utilisation d'assertEquals est plus concise qu'écrire votre propre condition *if* et ajouter votre message d'erreur dans System.out.println.
Junit fournit d'autres méthodes d'assertions, chaque méthode possédant des surcharges correspondant aux types primitifs disponibles en java

|Nom de la fonction | résultat |
|---|---|
|assertArrayEquals()| vérifie l'égalité de deux tableaux|
|assertEquals()| vérifie que deux types primitifs sont égaux |
|assertTrue() + assertFalse()| vérifie que la valeur est bien le boolean attendu|
|assertNull() + assertNotNull()|vérifie que l'objet est bien null (resp. non null)|
|assertSame() + assertNotSame()|vérifie que les deux variables font référence au même objet|


## Vérification des exceptions #

Deux techniques permettent de vérifier qu'une exception est bien levée lors de l'appel d'une méthodes.

```java
import java.util.List;
import static org.junit.Assert.*;
import junit.framework.TestCase;
import org.junit.runner.*;
import org.junit.Test;
import org.junit.runner.Result;
import org.junit.runner.JUnitCore;
import org.junit.runners.model.TestClass;
import org.junit.runner.notification.Failure;


public class SeriesTest extends TestCase {
 //ici le code contenu dans la méthode DOIT lever l'exception spécifiée.
 @Test(expected = IndexOutOfBoundsException.class)
 public void testIndexOutOfBoundsException() {
  ArrayList emptyList = new ArrayList();
  Object o = emptyList.get(0);
 }
 @Test
 public void testIndexOutOfBoundsException2() {
  try {
   ArrayList emptyList = new ArrayList();
   Object o = emptyList.get(0);
   fail("ne devrait pas atteindre cette ligne");
  } catch (IndexOutOfBoundsException e) {
   //all good
  }

 }
}

Result result = JUnitCore.runClasses(SeriesTest.class);
List<Failure> failures = result.getFailures();
if(failures.size()==0){
    System.out.println("All good!");
}
else{
    for(Failure f : result.getFailures()) {
          System.out.println(f.getDescription());
          System.out.println(f.getMessage());
    }
}

```

ici la technique 1 consiste à spécifier au niveau de la méthodes que l'exception doit être levée (voir testIndexOutOfBoundsException). La seconde technique est plus verbeuse, mais permet d'écrire plusieurs vérifications au sein d'un même test.

## Les Fixtures, ou préparation de l'environnement avant l'exécution ##

Parfois, la mise en place des tests peut être longue et nécessiter la création d'un bon nombre d'objet ou de resources.
Pour cela, Junit met à notre disposition un mécanisme  qui permet d'exécuter une portion de code soit

1. à chaque appel de la classe de test (@BeforeClass)
2. à chaque appel d'une méthode de test (@Before)

De la même manière, Junit permet de nettoyer l'environnement une fois que le test a été exécuté

1. après l'appel de la classe de test (@AfterClass)
2. après l'appel de chaque méthode de test (@After)

```java
import java.util.List;
import static org.junit.Assert.*;
import junit.framework.TestCase;
import org.junit.runner.*;
import org.junit.Test;
import org.junit.runner.Result;
import org.junit.runner.JUnitCore;
import org.junit.runners.model.TestClass;
import org.junit.runner.notification.Failure;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.After;
import org.junit.AfterClass;


public class JunitTestExample {


	private ArrayList testList;

		    @BeforeClass
		    public static void uneFoisParClasse() {
		        System.out.println("@BeforeClass: onceExecutedBeforeAll");
		    }

		    @Before
		    public void pourChaqueMethode() {
		        testList = new ArrayList();
		        System.out.println("@Before: executedBeforeEach");
		    }

		    @Test
		    public void collectionVide() {
		        assertTrue(testList.isEmpty());
		        System.out.println("@Test: EmptyArrayList");
			    }

	 	    @Test
		    public void collectionAvec1Element() {
		        testList.add("oneItem");
	        assertEquals(1, testList.size());
		        System.out.println("@Test: OneItemArrayList");
		    }
}


Result result = JUnitCore.runClasses(JunitTestExample.class);
List<Failure> failures = result.getFailures();
if(failures.size()==0){
    System.out.println("All good!");
}
else{
    for(Failure f : result.getFailures()) {
          System.out.println(f.getDescription());
          System.out.println(f.getMessage());
    }
}

```
