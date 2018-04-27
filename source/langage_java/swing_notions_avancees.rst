Swing : notions avancées
########################

Ce chapitre couvre quelques notions avancées pour la programmation d'applications
graphiques avec Swing

Principe du MVC
***************

Le MVC_ (modèle-vue-contrôleur) est un modèle de conception adapté pour le 
développement d'interface graphique. Le MVC_ découpe le traitement applicatif 
selon trois catégories :

Le modèle
  Il contient les données applicatives ainsi que les logiques de traitement 
  propres à l'application.
La vue
  Elle gère la représentation graphique des données et l'interface utilisateur
Le contrôleur
  Il est sollicité par les interactions de l'utilisateur ou les modifications 
  des données. Il assure la cohérence entre le modèle et la vue. 

Ce modèle se retrouve dans l'architecture des composants Swing. Ce modèle est
particulièrement important à comprendre pour les composants graphiques les plus complexes
comme JTable_, JList_ et JTree_.

Les interactions entre les trois éléments du modèles MVC_ sont réalisées en Swing
grâce à des *listeners*. Par exemple, la vue peut être prévenue par le modèle
que des données ont évolué et que la représentation graphique doit être
rafraîchie.

Pour des composants graphiques comme le JTable_, la vue et le contrôleur sont
très largement pris en charge par le composant Swing. Le développeur doit fournir
la partie modèle en implémentant une classe qui joue le rôle du modèle de données
(*data model*).

La classe JTable
****************

La classe JTable_ représente un tableau à deux dimensions (type tableur). Chaque
cellule peut afficher une information. À la création de ce composant, il est
possible de fournir une instance de TableModel_. Il s'agit d'une interface
qui fournit les informations nécessaires au composant pour s'afficher avec notamment
le nombre de lignes, le nombre de colonnes et le contenu de chaque cellule.
Comme l'interface TableModel_ peut s'avérer complexe à implémenter, la
classe abstraite AbstractTableModel_ fournit une partie de l'implémentation.

Si nous disposons de la classe *Individu* :

::

  package ROOT_PKG;

  public class Individu {
    
    private String nom;
    private String prenom;
    
    public Individu() {
    }
    
    public Individu(String prenom, String nom) {
      this.prenom = prenom;
      this.nom = nom;
    }
    
    public String getNom() {
      return nom;
    }
    
    public String getPrenom() {
      return prenom;
    }
    
    public void setNom(String nom) {
      this.nom = nom;
    }
    
    public void setPrenom(String prenom) {
      this.prenom = prenom;
    }
    
    @Override
    public String toString() {
      return "" + this.prenom + " " + this.nom;
    }
  }

Nous pouvons créer une application Swing qui va afficher une liste d'individus
à l'aide d'une JTable_. Dans notre application, il est possible de :

* ajouter des individus à la liste
* modifier le nom et le prénom de chaque individu
* mettre automatiquement en majuscule la première lettre du nom et du prénom de 
  chaque individu de la liste

Nous créons une implémentation de TableModel_ que nous appelons *IndividuTableModel* :

.. code-block:: java
  :linenos:

  package ROOT_PKG.gui;

  import java.util.ArrayList;
  import java.util.Arrays;
  import java.util.List;

  import javax.swing.table.AbstractTableModel;

  import ROOT_PKG.Individu;

  public class IndividuTableModel extends AbstractTableModel {
    
    private static final int COLONNE_NOM = 0;
    private static final int COLONNE_PRENOM = 1;
    
    private List<Individu> individus = new ArrayList<>();
    
    public IndividuTableModel(Individu ...individus) {
      this.individus.addAll(Arrays.asList(individus));
    }
    
    @Override
    public String getColumnName(int columnIndex) {
      switch (columnIndex) {
      case COLONNE_NOM:
        return "Nom";
      case COLONNE_PRENOM:
        return "Prénom";
      default:
        return "";
      }
    }

    @Override
    public int getColumnCount() {
      return 2;
    }

    @Override
    public int getRowCount() {
      return individus.size();
    }
    
    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
      return true;
    }
    
    @Override
    public void setValueAt(Object aValue, int rowIndex, int columnIndex) {
      switch (columnIndex) {
      case COLONNE_NOM:
        individus.get(rowIndex).setNom(aValue.toString());
        break;
      case COLONNE_PRENOM:
        individus.get(rowIndex).setPrenom(aValue.toString());
        break;
      }
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
      switch (columnIndex) {
      case COLONNE_NOM:
        return individus.get(rowIndex).getNom();
      case COLONNE_PRENOM:
        return individus.get(rowIndex).getPrenom();
      default:
        return "";
      }
    }
    
    public void addIndividu(Individu u) {
      this.individus.add(u);
      this.fireTableRowsInserted(this.individus.size()-1, this.individus.size()-1);
    }

    public void addIndividu() {
      this.addIndividu(new Individu());
    }
    
    public void fixMajuscule() {
      int rowIndex = 0;
      for (Individu individu : individus) {
        individu.setNom(fixMajuscule(individu.getNom(), rowIndex, COLONNE_NOM));
        individu.setPrenom(fixMajuscule(individu.getPrenom(), rowIndex, COLONNE_PRENOM));
        ++rowIndex;
      }
    }
    
    public List<Individu> getIndividus() {
      return individus;
    }
    
    private String fixMajuscule(String value, int rowIndex, int columnIndex) {
      if (value == null || value.length() == 0) {
        return value;
      }
      
      if (Character.isLowerCase(value.charAt(0))) {
        this.fireTableCellUpdated(rowIndex, columnIndex);
        return value.substring(0, 1).toUpperCase() + value.substring(1);
      }
      return value;
    }
    
  }

La classe *IndividuTableModel* hérite de AbstractTableModel_ qui implémente déjà
une bonne partie de l'interface TableModel_. Notre classe surcharge des méthodes
comme getColumnName_, getColumnCount_ et getRowCount_ pour fournir à la vue
les informations nécessaires pour connaître le nom de chaque colonne, leur nombre
et le nombre de lignes. Le modèle maintient en interne une liste d'instances
de *Indidivu*. La seule méthode que nous devons impérativement implémenter est
getValueAt_ (ligne 62). Elle permet à la vue de connaître la valeur d'une cellule
du tableau à afficher. Afin d'autoriser la modification du nom et du prénom
depuis la vue, nous devons également implémenter la méthode setValueAt_ (ligne 50)
afin que de traiter les informations qui nous seront fournies à travers la vue.

Le modèle fournit également ses propres méthodes pour modifier la liste des
individus. Ainsi les méthodes *addIndividu* (lignes 73 et 82) permettent d'ajouter
un individu à la liste. Quant à la méthode fixMajuscule (ligne 95), elle permet
de corriger, si nécessaire, la première lettre du nom et du prénom pour la passer
en majuscule. Ces méthodes modifient donc l'état du modèle. Lorsque le modèle
change, il doit en avertir la vue afin que celle-ci puisse rafraîchir les
données à l'écran. La classe abstraite AbstractTableModel_ fournit une gestion
de *listeners* spécialisés. Lorsqu'un objet implémentant TableModel_ est associé à un composant
JTable_, ce dernier enregistre plusieurs *listeners* auprès du modèle pour 
être prévenu des modifications éventuelles du modèle. Pour notifier de ces modifications
une classe qui hérite de AbstractTableModel_ doit appeler les méthodes 
fireTableCellUpdated_, fireTableDataChanged_, fireTableRowsDeleted_, fireTableRowsInserted_
fireTableRowsUpdated_ ou fireTableStructureChanged_ selon le type de modifications
qui ont eu lieu sur le modèle.

Pour notre implémentation, à la ligne 75, nous appelons la méthode fireTableRowsInserted_
pour signaler à la vue qu'une nouvelle ligne a été ajoutée et à la ligne 101,
nous appelons la méthode fireTableCellUpdated_ pour signaler que le contenu
d'une cellule a changé.

Enfin, la classe *IndividuTableur* représente la fenêtre de l'application contenant
le composant JTable_ :

.. code-block:: java
  :linenos:
  
  package ROOT_PKG.gui;

  import javax.swing.JFrame;
  import javax.swing.JMenu;
  import javax.swing.JMenuBar;
  import javax.swing.JMenuItem;
  import javax.swing.JScrollPane;
  import javax.swing.JTable;
  import javax.swing.WindowConstants;

  import ROOT_PKG.Individu;

  public class IndividuTableur extends JFrame {
    
    private IndividuTableModel individuModel;

    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Table des individus");
      
      this.setJMenuBar(new JMenuBar());
      this.getJMenuBar().add(createMenu());
      
      this.individuModel = new IndividuTableModel();
      this.add(new JScrollPane(new JTable(individuModel)));
      
      this.setSize(800, 600);
    }
    
    private JMenu createMenu() {
      JMenu menu = new JMenu("Individus");
      menu.add(new JMenuItem("Ajouter")).addActionListener(e -> this.individuModel.addIndividu());
      menu.add(new JMenuItem("Corriger Maj.")).addActionListener(e -> this.individuModel.fixMajuscule());
      menu.add(new JMenuItem("Imprimer")).addActionListener(e -> this.imprimer());
      menu.addSeparator();
      menu.add(new JMenuItem("Fermer")).addActionListener(e -> this.dispose());;
      return menu;
    }

    private void imprimer() {
      individuModel.getIndividus().forEach(System.out::println);
    }
    
    public void addIndividu(Individu u) {
      this.individuModel.addIndividu(u);
    }

    public static void main(String[] args) {
      IndividuTableur window = new IndividuTableur();
      
      window.addIndividu(new Individu("John", "Doe"));
      window.addIndividu(new Individu("Anabella", "Doe"));
      window.addIndividu(new Individu("jean", "dupond"));
      
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

À la ligne 26, nous créons l'instance de *IndividuTableModel* et nous l'associons
à une instance de JTable_. Aux lignes 34, 35 et 36, nous créons des entrées de menu
pour permettre à l'utilisateur d'interagir. Certaines des actions appellent des
méthodes du modèle qui le modifie et qui déclencherons un événement en direction
de la vue qui n'aura plus qu'à se rafraîchir.

Dans Swing, il existe d'autres composants de haut niveau qui reprennent le modèle
du MVC_ pour permettre de gérer des représentations complexes de données comme la
JList_ pour afficher une liste d'éléments ou le JTree_ pour gérer des représentations
arborescentes de données.

 

.. todo::

  * Principe du Worker thread

.. _MVC: https://fr.wikipedia.org/wiki/Mod%C3%A8le-vue-contr%C3%B4leur
.. _JTable: https://docs.oracle.com/javase/8/docs/api/javax/swing/JTable.html
.. _JTree: https://docs.oracle.com/javase/8/docs/api/javax/swing/JTree.html
.. _JList: https://docs.oracle.com/javase/8/docs/api/javax/swing/JList.html
.. _TableModel: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html
.. _AbstractTableModel: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html
.. _getColumnName: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html#getColumnName-int-
.. _getRowCount: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html#getRowCount--
.. _getColumnCount: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html#getRowCount--
.. _getValueAt: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html#getRowCount--
.. _setValueAt: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/TableModel.html#setValueAt-java.lang.Object-int-int-
.. _fireTableCellUpdated: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableCellUpdated-int-int-
.. _fireTableDataChanged: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableDataChanged--
.. _fireTableRowsDeleted: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableRowsDeleted-int-int-
.. _fireTableRowsInserted: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableRowsInserted-int-int-
.. _fireTableRowsUpdated: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableRowsUpdated-int-int-
.. _fireTableStructureChanged: https://docs.oracle.com/javase/8/docs/api/javax/swing/table/AbstractTableModel.html#fireTableStructureChanged--

