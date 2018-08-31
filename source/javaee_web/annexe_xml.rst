.. _annexe_xml:

Annexe : XML
############

**L'Extensible Markup Language** (XML) est un langage de balisage
générique. Il permet de représenter des données de manière arborescente
(ou sous la forme d'un graphe en utilisant des références XML).

Le XML ne définit pas de balise mais simplement une façon de présenter
un document afin qu'il soit bien formé (**well-formed**). Le XML est
défini par la `recommandation du W3 <http://www.w3.org/TR/xml/>`__.

Structure du langage
********************

Le XML est composé par des nœuds (**XML Nodes**) reliés entre eux sous
une forme arborescente. Un nœud ne peut donc avoir au plus qu'un seul
nœud parent et, dans un document, un seul nœud n'a pas de parent : il
s'agit du nœud racine (**root node**).

Il existe différents types de nœuds XML :

**Element**
    Un élément sera représenté dans le document par une balise. Un nœud
    racine est obligatoirement de type élément. Seuls les nœuds de type
    élément peuvent avoir des fils (*i.e.* être parent d'un autre nœud)
**Attribute**
    Un attribut permet d'associer une valeur à un élément
**Text**
    Un simple fragment de texte
**Processing instruction**
    Une portion contenant des instructions traitables par une
    application et délimitée par ``<? ?>``

Structure du document
*********************

Un document XML est un document texte qui peut optionnellement commencer
par le prologue suivant :

.. code-block:: xml

    <?xml version='1.0' encoding='UTF-8'?>

On précise ainsi la version du langage XML et l'encodage du document.

Un élément est représenté par une balise. Attention en XML, une balise
doit obligatoirement être fermée !

.. code-block:: xml
    :caption: Un balise sans corps
    
    <myelement/>

.. code-block:: xml
    :caption: Un balise avec un corps

    <myelement></myelement>

Un attribut est positionné sur la balise ouvrante représentant
l'élément.

.. code-block:: xml
    :caption: Un balise avec attribut

    <myelement myattr="value"/>

En XML, un attribut a obligatoirement une valeur (qui peut être une
chaîne de caractères vide) et cette dernière est obligatoirement
délimitée par **'** ou **"**.

En XML, les caractères & ' " < > sont des caractères réservés et doivent
être échappés par les entités XML &amp; &apos; &quot; &lt; &gt;.

Il est possible de définir tout ou partie d'un nœud texte comme une
section **CDATA** protégée dans laquelle il n'est plus nécessaire
d'échapper les caractères spéciaux.

.. code-block:: xml
    :caption: Section CDATA

    <myelement>
      je dois échapper les caractères &amp; &apos; &quot; &lt; &gt;
      <![CDATA[Je ne dois pas échapper les caractères & ' " < > dans cette section]]>
    </myelement>

Un document XML qui respecte les règles de structure du langage et d'un
document est dit **bien formé** (well-formed).

Exercice
********

.. admonition:: XML bien formé
    :class: hint

    Les exemples de documents XML ci-dessous sont-ils bien formés ? Et si
    non, pourquoi.

    .. code-block:: text

        <cours>
          <intitulé>Web services</intitulé>
          <enseignant>D. Gayerie</enseignant>
        </cours>

    .. code-block:: text

        <?xml version="1.0" encoding="utf-8"?>
        <cours>
          <code id="I4WS">
          <intitulé>Web services</intitulé>
          <enseignant>D. Gayerie</enseignant>
        </cours>

    .. code-block:: text

        <cours>
          <intitulé>Génie logiciel</intitulé>
        </cours>
        <cours>
          <intitulé>Web services</intitulé>
        </cours>

    .. code-block:: text

        <test>
          <question>Ce document est-il valide ?</question>
          <exemple>
          <![CDATA[
          <document></DOCUMENT>
          ]]>
          </exemple>
        </test>

Espaces de noms XML
*******************

Un élément ou un attribut d'un document XML peut être associé à un
espace de nom. Un espace de nom XML (**XML namespace**) est identifié
par une URI. Un espace de nom est déclaré grâce à l'attribut ``xmlns``.

.. code-block:: xml
    :caption: Déclaration d'un espace de nom XML

    <programme xmlns="http://formation.fr/syllabus">
      <cours code="I4GL">
        <intitulé>Génie logiciel</intitulé>
      </cours>
      <cours code="I4WS">
        <intitulé>Web services</intitulé>
      </cours>
    </programme>

Un espace de nom XML s'applique à l'élément portant l'attribut ``xmlns``
**et** à tous les éléments fils.

Il est possible de mélanger dans un même document XML des éléments
appartenant à des espaces de noms différents.

.. code-block:: xml
    :caption: Document XML contenant plusieurs espaces de nom

    <html xmlns="http://www.w3.org/1999/xhtml">
      <body>
        <h1>Exemple MathML</h1>
        <math xmlns="http://www.w3.org/1998/Math/MathML">
          <mrow>
            <mroot>
              <mrow><mi>b</mi></mrow>
              <mrow><mn>3</mn></mrow>
            </mroot>
          </mrow>
        </math>
      </body>
    </html>

Afin de résoudre les cas ambigus, un espace de nom peut être identifié
par un préfixe.

.. code-block:: xml
    :caption: Document XML contenant plusieurs espaces de nom avec un préfixe

    <h:html xmlns:h="http://www.w3.org/1999/xhtml"
            xmlns:ma="http://www.w3.org/1998/Math/MathML">
      <h:body>
        <h:h1>Exemple MathML</h:h1>
        <ma:math>
          <ma:mrow>
            <ma:mroot>
              <ma:mrow><ma:mi>b</ma:mi></ma:mrow>
              <ma:mrow><ma:mn>3</ma:mn></ma:mrow>
            </ma:mroot>
          </ma:mrow>
        </ma:math>
      </h:body>
    </h:html>

L'espace de nom sans préfixe est appelé l'espace de nom par défaut
(**default XML namespace**).

Ainsi, un élément XML est défini par :

Son nom
    Le nom apparaît dans la balise du document.
    Exemple : body
Son espace de nom
    L'espace de nom est donné par l'attribut xmlns de l'élément, un
    préfixe ou est hérité de l'élément parent.
    Exemple : http://www.w3.org/1999/xhtml
Son nom qualifié (qualified name ou QName)
    L'association de l'espace de nom et du nom de l'élement. Il s'agit
    en fait du nom complet de l'élement.
    Exemple : {http://www.w3.org/1999/xhtml}:body

Schémas XML
***********

Un document XML est **valide** (valid) si le *QName* et l'ordre des
éléments sont conformes à un document de validation.

Un **schéma XML** (XSD) permet d'écrire un document de validation au
format XML.

.. code-block:: xml
    :caption: Exemple de schéma XML

    <?xml version="1.0" encoding="UTF-8"?>
    <schema xmlns="http://www.w3.org/2001/XMLSchema"
            xmlns:tns="http://formation.fr/syllabus" 
            targetNamespace="http://formation.fr/syllabus"
            elementFormDefault="qualified">
      <element name="programme">
        <complexType>
          <sequence>
            <element name="cours" type="tns:typeCours" 
             maxOccurs="unbounded" minOccurs="0"/>
          </sequence>
        </complexType>
      </element>
      <complexType name="typeCours">
        <sequence>
          <element name="intitulé" type="string" 
           maxOccurs="1" minOccurs="1"/>
        </sequence>
        <attribute name="code" type="string"/>
      </complexType>
    </schema>

Pour aller plus loin...
***********************

XML
    http://www.w3schools.com/xml/
XML namespace
    http://www.w3schools.com/xml/xml_namespaces.asp
XML schema
    http://www.w3schools.com/schema/

