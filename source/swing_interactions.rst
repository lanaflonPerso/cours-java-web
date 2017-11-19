Swing : les interactions
########################

Ce chapitre présente différents types d'interaction que l'on peut mettre
en place dans les applications graphiques basées sur Swing.

Les listeners
*************

Pour interagir avec l'utilisateur, chaque composant graphique peut intercepter
des événements (frappe d'une touche sur le clavier, clic souris...) et réagir
en conséquence. Pour associer un comportement à un événement, on ajoute un
écouteur d'événement (*listener*) au composant, c'est-à-dire un objet 
qui implémente l'interface EventListener_. Cette interface est simplement une 
:ref:`interface marqueur <interface_marqueur>` dont héritent toutes les interfaces
qui représentent des *listeners* pour des événements particuliers.

.. code-block:: java
  :linenos:

  package ROOT_PKG.gui;

  import java.awt.Dimension;
  import java.awt.event.KeyEvent;
  import java.awt.event.KeyListener;
  import java.awt.event.MouseEvent;
  import java.awt.event.MouseListener;
  import java.util.EventObject;

  import javax.swing.JComponent;
  import javax.swing.JEditorPane;
  import javax.swing.JFrame;
  import javax.swing.WindowConstants;

  public class ExempleListener extends JFrame {
    
    private class ExempleMouseListener implements MouseListener {

      @Override
      public void mouseClicked(MouseEvent e) {
        printEvent(e);
      }

      @Override
      public void mouseEntered(MouseEvent e) {
        printEvent(e);
      }

      @Override
      public void mouseExited(MouseEvent e) {
        printEvent(e);
      }

      @Override
      public void mousePressed(MouseEvent e) {
        printEvent(e);
      }

      @Override
      public void mouseReleased(MouseEvent e) {
        printEvent(e);
      }
      
    }
    
    private class ExempleKeyListener implements KeyListener {

      @Override
      public void keyPressed(KeyEvent e) {
        printEvent(e);
      }

      @Override
      public void keyReleased(KeyEvent e) {
        printEvent(e);
      }

      @Override
      public void keyTyped(KeyEvent e) {
        printEvent(e);
      }
      
    }
    
    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Exemple listener");
      JComponent component = new JEditorPane();
      component.setPreferredSize(new Dimension(300, 300));
      component.addMouseListener(new ExempleMouseListener());
      component.addKeyListener(new ExempleKeyListener());
      this.add(component);
      this.pack();
    }
    
    private void printEvent(EventObject e) {
      System.out.println(e);
    }
    
    public static void main(String[] args) {
      JFrame window = new ExempleListener();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

Dans l'exemple ci-dessus, l'application affiche un éditeur de texte sous la forme
d'un carré de 300 pixels sur 300 pixels. Aux lignes 72 et 73, on ajoute à ce composant 
une instance de MouseListener_ et une instance de KeyListener_ (les classes
implémentant ces interfaces sont déclarées sous la forme de classes internes). Ces
*listeners* se contentent d'afficher sur la sortie standard la représentation
sous forme de chaîne de caractères de chaque événement.

Chaque événement fournit des informations liées à son origine. Par exemple, un
MouseEvent_ indique si un bouton de la souris est pressé. Un KeyEvent_ indique
la touche du clavier qui est soit pressée soit relâchée. Un composant peut utiliser
ces informations pour modifier son état. Ainsi, la classe JEditorPane_, utilisée
dans l'exemple précédent, enregistre en interne un KeyListener_ pour savoir
si une touche a été pressée et en déduit le caractère qui doit être ajouté dans
l'éditeur.

Un *listener* couramment utilisé est le type ActionListener_. Ce *listener* 
écoute les événements de type ActionEvent_. Un ActionEvent_ représente
une interaction utilisateur simple. Il est associé à une commande qui est
un simple identifiant sous la forme d'une chaîne de caractères. Les boutons
acceptent des *listeners* de ce type.

.. code-block:: java
  :linenos:

  package ROOT_PKG.gui;

  import java.awt.GridBagConstraints;
  import java.awt.GridBagLayout;
  import java.awt.Insets;
  import java.awt.event.ActionEvent;
  import java.awt.event.ActionListener;

  import javax.swing.JButton;
  import javax.swing.JComboBox;
  import javax.swing.JComponent;
  import javax.swing.JFrame;
  import javax.swing.JLabel;
  import javax.swing.JPanel;
  import javax.swing.JTextArea;
  import javax.swing.JTextField;
  import javax.swing.WindowConstants;

  public class ExempleActionListener extends JFrame {
    
    private JComboBox<String> civilite;
    private JTextField nom;
    private JTextField prenom;
    private JTextArea adresse;

    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Exemple Listeners");
      this.getContentPane().setLayout(new GridBagLayout());
      
      int rowIndex = 0;
      civilite = new JComboBox<String>(new String[] {"Madame", "Monsieur"});
      nom = new JTextField();
      prenom = new JTextField();
      adresse = new JTextArea(10, 20);

      addRow(rowIndex++, "Civilité", civilite);
      addRow(rowIndex++, "Nom", nom);
      addRow(rowIndex++, "Prénom", prenom);
      addRow(rowIndex++, "Addresse", adresse);

      JButton okButton = new JButton("Ok");
      okButton.addActionListener(new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
          onOk();
        }
      });
      JButton cancelButton = new JButton("Annuler");
      cancelButton.addActionListener(new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
          onCancel();
        }
      });
      addButtons(rowIndex++, okButton, cancelButton);

      this.pack();
      this.setResizable(false);
    }
    
    private void onOk() {
      // On affiche le contenu du formulaire sur la sortie standard
      System.out.println(String.format("%1$s %2$s %3$s résidant au %4$s", 
                         civilite.getSelectedItem(), prenom.getText(), nom.getText(), adresse.getText()));
    }
    
    private void onCancel() {
      // on cache la fenêtre
      this.setVisible(false);
      // on supprime la fenêtre
      this.dispose();
    }

    private void addRow(int rowIndex, String titre, JComponent component) {
      GridBagConstraints cst = new GridBagConstraints();
      cst.fill = GridBagConstraints.HORIZONTAL;
      cst.anchor = GridBagConstraints.NORTH;
      cst.insets = new Insets(5, 20, 5, 20);
      cst.gridy = rowIndex;
      cst.gridx = 0;
      cst.weightx = .3;

      JLabel label = new JLabel(titre);
      label.setLabelFor(component);
      this.add(label, cst);

      cst.gridx = 1;
      cst.weightx = .7;
      this.add(component, cst);
    }

    private void addButtons(int rowIndex, JButton...buttons) {
      JPanel panel = new JPanel();
      for (JButton button : buttons) {
        panel.add(button);
      }
      GridBagConstraints cst = new GridBagConstraints();
      cst.insets = new Insets(5, 10, 0, 0);
      cst.fill = GridBagConstraints.HORIZONTAL;
      cst.gridy = rowIndex;
      cst.gridx = 0;
      cst.gridwidth = 2;
      this.add(panel, cst);
    }

    public static void main(String[] args) {
      JFrame window = new ExempleActionListener();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

Le code ci-dessus reprend l'application de saisie de formulaire qui utilisait
le GridBagLayout_ dans le :ref:`chapitre précédent <swingGridBagLayout>`. Entre les lignes 44 et 58, on crée les boutons de l'application
en ajoutant des instances de ActionListener_ sous la forme de classes anonymes. Lorsque
l'utilisateur clique sur le bouton *Ok* (respectivement *Annuler*), la méthode
privée *onOk* (respectivement *onCancel*) est appelée. La méthode *onOk* (lignes
64-68) affiche sur la sortie standard les informations récupérées des différentes
zones de saisie. La méthode *onCancel* (lignes 70-75) cache la fenêtre et appelle
la méthode dispose_ pour la détruire.

Les menus
*********

Les menus avec Swing sont principalement gérés par trois classes :

JMenuBar_
  Cette classe représente une barre de menu.

JMenu_
  Cette classe représente un menu.

JMenuItem_
  Cette classe représente une entrée cliquable dans un menu. Elle se comporte
  comme un JButton_.

De plus, il existe des sous classes de JMenuItem_ pour représenter des entrées
de menu plus complexes.

La classe JFrame_ est déjà capable de gérer en interne une instance de JMenuBar_. 
Il suffit d'appeler la méthode JFrame.setJMenuBar_ pour ajouter la barre de menu.

.. code-block:: java
  :linenos:

  package ROOT_PKG.gui;

  import javax.swing.ButtonGroup;
  import javax.swing.JCheckBoxMenuItem;
  import javax.swing.JFrame;
  import javax.swing.JMenu;
  import javax.swing.JMenuBar;
  import javax.swing.JMenuItem;
  import javax.swing.JRadioButtonMenuItem;
  import javax.swing.WindowConstants;

  public class ExempleMenu extends JFrame {
    
    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Exemple Menus");
      
      this.setJMenuBar(new JMenuBar());
      this.getJMenuBar().add(createMenuFichier());
      this.getJMenuBar().add(createMenuSpecial());
      this.setSize(500, 300);
    }

    private JMenu createMenuFichier() {
      JMenu menu = new JMenu("Fichier");
      menu.add(new JMenuItem("Nouveau"));
      JMenu subMenu = new JMenu("Importer");
      subMenu.add(new JMenuItem("Document simple"));
      subMenu.add(new JMenuItem("Document complexe"));
      menu.add(subMenu);
      menu.addSeparator();
      menu.add(new JMenuItem("Imprimer..."));
      menu.add(new JMenuItem("Aperçu impression..."));
      menu.addSeparator();
      menu.add(new JMenuItem("Fermer")).addActionListener(e -> this.dispose());;
      return menu;
    }
    
    private JMenu createMenuSpecial() {
      JMenu menu = new JMenu("Spécial");
      menu.add(new JCheckBoxMenuItem("Activer", false));
      
      menu.addSeparator();
      
      JRadioButtonMenuItem[] radioButtons = {new JRadioButtonMenuItem("Bleu", true), 
                                             new JRadioButtonMenuItem("Vert"), 
                                             new JRadioButtonMenuItem("Rouge")};
      ButtonGroup buttonGroup = new ButtonGroup();
      for (JRadioButtonMenuItem radioButton: radioButtons) {
        buttonGroup.add(radioButton);
        menu.add(radioButton);
      }
      return menu;
    }

    public static void main(String[] args) {
      JFrame window = new ExempleMenu();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

L'application ci-dessus crée une barre de menu avec un exemple pour chaque type
d'entrée. 

.. image:: images/swing/exemple_menus.png

Dans une application complète, il faudrait ajouter un ActionListener_
pour chaque entrée des menus. Dans cet exemple, seul le menu *Fermer* a un
ActionListener_ pour terminer l'application.

.. note::

  À la ligne 37, on enregistre un ActionListener_ en utilisant une lambda. En
  effet, même si cette interface ne possède pas l'annotation FunctionalInterface_,
  elle possède les caractéristiques nécessaires pour qu'on puisse lui substituer
  une lambda.

L'interface Action
******************

Dans une application, une même fonctionnalité peut souvent être déclenchée de
plusieurs façons par un utilisateur :

* en cliquant dans un menu
* en cliquant sur une icône dans la barre d'icônes
* en exécutant un raccourci clavier
* en cliquant sur un bouton dans une boite de dialogue

Swing permet de gérer ce phénomène grâce à l'interface Action_. Plutôt que d'ajouter
un *listener*, il est possible d'associer une action à une objet de type JMenuItem_ ou
JButton_. L'interface Action_ hérite de ActionListener_ pour pouvoir fournir un
comportement lorsque l'utilisateur clique sur un bouton. Mais l'interface Action_
permet également de définir un libellé, une icône, une description et un raccourci
clavier. Tous les composants associés s'adapteront en fonction de l'état de l'action.
Si une action est désactivée avec sa méthode setEnabled_ alors tous les boutons
associés apparaîtront grisés.

.. code-block:: java
  :linenos:
  
  package ROOT_PKG.gui;

  import java.awt.Desktop;
  import java.awt.event.ActionEvent;
  import java.awt.event.KeyEvent;
  import java.net.URI;

  import javax.swing.AbstractAction;
  import javax.swing.Action;
  import javax.swing.JButton;
  import javax.swing.JCheckBoxMenuItem;
  import javax.swing.JFrame;
  import javax.swing.JMenu;
  import javax.swing.JMenuBar;
  import javax.swing.JMenuItem;
  import javax.swing.JPanel;
  import javax.swing.KeyStroke;
  import javax.swing.UIManager;
  import javax.swing.WindowConstants;

  public class ExempleMenu extends JFrame {
    
    private Action exempleAction;

    private class ExempleAction extends AbstractAction {

      public ExempleAction() {
        super("Java", UIManager.getIcon("FileView.fileIcon"));
        putValue(SHORT_DESCRIPTION, "Cliquez pour en savoir plus sur Java");
        putValue(ACCELERATOR_KEY, KeyStroke.getKeyStroke(KeyEvent.VK_A, ActionEvent.CTRL_MASK));
      }
      
      @Override
      public void actionPerformed(ActionEvent e) {
        try {
          // on ouvre la page Web dans le navigateur par défaut
          Desktop.getDesktop().browse(new URI("https://fr.wikipedia.org/wiki/Java_(langage)"));
        } catch (Exception e) {
          e.printStackTrace();
        }
      }
      
    }
    
    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Exemple Menus");
      
      this.exempleAction = new ExempleAction();
      
      this.setJMenuBar(new JMenuBar());
      this.getJMenuBar().add(createMenu());

      JPanel panel = new JPanel();
      panel.add(new JButton(exempleAction));
      this.add(panel);

      this.setSize(500, 300);
    }

    private JMenu createMenu() {
      JMenu menu = new JMenu("Menu");
      menu.add(new JMenuItem(exempleAction));
      JCheckBoxMenuItem checkBox = new JCheckBoxMenuItem("Activer", true);
      checkBox.addActionListener(l -> exempleAction.setEnabled(checkBox.getState()));
      menu.add(checkBox);
      menu.addSeparator();
      menu.add(new JMenuItem("Fermer")).addActionListener(e -> this.dispose());;
      return menu;
    }
    
    public static void main(String[] args) {
      JFrame window = new ExempleMenu();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

Dans l'exemple ci-dessus, on déclare une action comme classe interne. Plutôt
que d'implémenter l'interface Action_, la classe interne *ExempleAction*
étend la classe abstraite AbstractAction_. Comme l'interface Action_ peut
être assez complexe à implémenter, cette classe abstraite fournit la plus grande
partie du code hormis l'implémentation de la méthode actionPerformed_ qui
correspond au traitement proprement dit.

L'action déclarée par notre application possède un nom, une description 
(pour afficher une bulle d'aide), une icône et un raccourci clavier 
(:kbd:`Ctrl+A`). La même instance de *ExempleAction* est associée à
une entrée dans le menu et au bouton dans la fenêtre. De plus, une autre entrée dans
le menu permet de désactiver l'action (ce qui aura pour conséquence de désactiver
le raccourci clavier et de griser le bouton et le menu associés).

Les boites de dialogue
**********************

Si vous souhaitez créer des boites de dialogues, Swing fournit la classe JDialog_.
Cette classe offre des fonctionnalités spécifiques pour ce type d'interface. Par
exemple JDialog_ permet de choisir si la boite de dialogue doit être modale
(c'est-à-dire si elle doit empêcher toute interaction avec la fenêtre parente) ou non
modale.

Swing fournit également la classe JOptionPane_ qui permet de créer rapidement
des boites de dialogue simples. Les méthodes fournies par la classe
JOptionPane_ sont bloquantes. Cela signifie que l'exécution s'arrête jusqu'à
ce que l'utilisateur ait choisi parmi les options de la boite de dialogue.

.. code-block:: java
  :linenos:
  
  package ROOT_PKG.gui;

  import java.util.Random;

  import javax.swing.JFrame;
  import javax.swing.JOptionPane;

  public class ExempleOptionPane extends JFrame {
    
    private static final String APP_TITLE = "Exemple OptionPane";

    public static void main(String[] args) {
      JOptionPane.showMessageDialog(null, "Bonjour", APP_TITLE, JOptionPane.PLAIN_MESSAGE);
      JOptionPane.showMessageDialog(null, "Ceci est un message", APP_TITLE, JOptionPane.INFORMATION_MESSAGE);
      JOptionPane.showMessageDialog(null, "Ceci est un avertissement", APP_TITLE, JOptionPane.WARNING_MESSAGE);
      JOptionPane.showMessageDialog(null, "Ceci est une erreur", APP_TITLE, JOptionPane.ERROR_MESSAGE);
      JOptionPane.showMessageDialog(null, "On passe à la suite ?", APP_TITLE, JOptionPane.QUESTION_MESSAGE);
      
      int jouer = JOptionPane.showConfirmDialog(null, "Voulez-vous jouer ?", APP_TITLE, JOptionPane.YES_NO_OPTION);
      if (jouer == JOptionPane.YES_OPTION) {
        Random random = new Random();
        do {
          int bonneResponse = random.nextInt(20) + 1;

          String reponse = JOptionPane.showInputDialog(null, "Donnez un nombre entre 1 et 20 :", 
                                                       APP_TITLE, JOptionPane.QUESTION_MESSAGE);

          if (reponse == null) {
            break;
          }
          
          try {
            int valeur = Integer.valueOf(reponse);
            if (valeur == bonneResponse) {
              JOptionPane.showMessageDialog(null, "Bravo vous avez gagné !", 
                                            APP_TITLE, JOptionPane.INFORMATION_MESSAGE);
            } else {
              JOptionPane.showMessageDialog(null, "Perdu ! La bonne réponse était " + bonneResponse + ".", 
                                            APP_TITLE, JOptionPane.WARNING_MESSAGE);
            }
          } catch (NumberFormatException nfe) {
            JOptionPane.showMessageDialog(null, "'" + reponse + "' n'est pas un nombre !", 
                                          APP_TITLE, JOptionPane.ERROR_MESSAGE);
          }
          
        } while (JOptionPane.showConfirmDialog(null, "Voulez-vous rejouer ?", 
                                               APP_TITLE, JOptionPane.YES_NO_OPTION) == JOptionPane.YES_OPTION);
        
        
        JOptionPane.showMessageDialog(null, "Au revoir...", APP_TITLE, JOptionPane.PLAIN_MESSAGE);
      }
    }
    
  }

Les boites de dialogues avancées
********************************

Swing fournit des classes pour des boites de dialogue évoluées. 

Boite de dialogue des fichiers
==============================

La classe JFileChooser_ permet de créer une boite de dialogue de sélection de 
fichiers et/ou de répertoires.

.. code-block:: java
  :linenos:
  
  package ROOT_PKG.gui;

  import java.io.IOException;

  import javax.swing.JEditorPane;
  import javax.swing.JFileChooser;
  import javax.swing.JFrame;
  import javax.swing.JMenu;
  import javax.swing.JMenuBar;
  import javax.swing.JMenuItem;
  import javax.swing.JOptionPane;
  import javax.swing.JScrollPane;
  import javax.swing.WindowConstants;
  import javax.swing.filechooser.FileNameExtensionFilter;

  public class EditeurTexte extends JFrame {
    
    private JEditorPane editor;

    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Simple éditeur de texte");
      
      this.setJMenuBar(new JMenuBar());
      this.getJMenuBar().add(createMenu());
      
      editor = new JEditorPane();
      editor.setEditable(false);
      this.add(new JScrollPane(editor));
      this.setSize(800, 600);;
    }
    
    private JMenu createMenu() {
      JMenu menu = new JMenu("Fichier");
      menu.add(new JMenuItem("Ouvrir...")).addActionListener(e -> this.open());;
      menu.addSeparator();
      menu.add(new JMenuItem("Fermer")).addActionListener(e -> this.dispose());;
      return menu;
    }
    
    private void open() {
      JFileChooser fileChooser = new JFileChooser();
      fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
      fileChooser.setMultiSelectionEnabled(false);
      fileChooser.addChoosableFileFilter(new FileNameExtensionFilter("Fichiers texte (txt, html, rtf)", 
                                                                     "txt", "html", "xhtml", "rtf"));
      int choix = fileChooser.showOpenDialog(this);
      if (choix == JFileChooser.APPROVE_OPTION) {
        try {
          editor.setPage(fileChooser.getSelectedFile().toURI().toString());
        } catch (IOException e) {
          e.printStackTrace();
          JOptionPane.showMessageDialog(this, "Une erreur est survenue :\n" + e.getMessage(), 
                                        "Erreur", JOptionPane.ERROR_MESSAGE);
        }
      }
    }

    public static void main(String[] args) {
      JFrame window = new EditeurTexte();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

La classe ci-dessus crée un éditeur de texte simple qui permet de choisir le fichier
que l'on veut consulter. La méthode *open* déclarée à partir de la ligne 43
utilise une instance de JFileChooser_ pour récupérer le fichier sélectionné
et donner son URL au composant JEditorPane_ qui l'affiche.

Boite de sélection de couleur
=============================

La classe JColorChooser_ affiche une boite de dialogue permettant de choisir une 
couleur.

.. code-block:: java
  :linenos:

  package ROOT_PKG.gui;

  import java.awt.Color;

  import javax.swing.JColorChooser;
  import javax.swing.JFrame;
  import javax.swing.JMenu;
  import javax.swing.JMenuBar;
  import javax.swing.JMenuItem;
  import javax.swing.JPanel;
  import javax.swing.WindowConstants;

  public class VisualiseurCouleur extends JFrame {
    
    private JPanel colorPanel;

    @Override
    protected void frameInit() {
      super.frameInit();
      this.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
      this.setTitle("Selecteur de couleur");
      
      this.setJMenuBar(new JMenuBar());
      this.getJMenuBar().add(createMenu());
      
      this.colorPanel = new JPanel();
      this.add(this.colorPanel);
      this.setSize(800, 600);;
    }
    
    private JMenu createMenu() {
      JMenu menu = new JMenu("Couleur");
      menu.add(new JMenuItem("Couleur de fond...")).addActionListener(e -> this.chooseColor());;
      menu.addSeparator();
      menu.add(new JMenuItem("Fermer")).addActionListener(e -> this.dispose());;
      return menu;
    }

    private void chooseColor() {
      Color newColor = JColorChooser.showDialog(this, "Choisissez la couleur de fond", 
                                                colorPanel.getBackground());
      this.colorPanel.setBackground(newColor);
    }

    public static void main(String[] args) {
      JFrame window = new VisualiseurCouleur();
      window.setLocationRelativeTo(null);
      window.setVisible(true);
    }
    
  }

L'application ci-dessus offre un menu pour changer la couleur de fond de la fenêtre.


.. _JFrame: https://docs.oracle.com/javase/8/docs/api/javax/swing/JFrame.html
.. _JButton: https://docs.oracle.com/javase/8/docs/api/javax/swing/JButton.html
.. _JMenuBar: https://docs.oracle.com/javase/8/docs/api/javax/swing/JMenuBar.html
.. _JMenu: https://docs.oracle.com/javase/8/docs/api/javax/swing/JMenu.html
.. _JMenuItem: https://docs.oracle.com/javase/8/docs/api/javax/swing/JMenuItem.html
.. _GridBagLayout: https://docs.oracle.com/javase/8/docs/api/java/awt/GridBagLayout.html
.. _JDialog: https://docs.oracle.com/javase/8/docs/api/javax/swing/JDialog.html
.. _JOptionPane: https://docs.oracle.com/javase/8/docs/api/javax/swing/JOptionPane.html
.. _JFileChooser: https://docs.oracle.com/javase/8/docs/api/javax/swing/JFileChooser.html
.. _JEditorPane: https://docs.oracle.com/javase/8/docs/api/javax/swing/JEditorPane.html
.. _JColorChooser: https://docs.oracle.com/javase/8/docs/api/javax/swing/JColorChooser.html
.. _KeyEvent: https://docs.oracle.com/javase/8/docs/api/java/awt/event/KeyEvent.html
.. _MouseEvent: https://docs.oracle.com/javase/8/docs/api/java/awt/event/MouseEvent.html
.. _EventListener: https://docs.oracle.com/javase/8/docs/api/java/util/EventListener.html
.. _MouseListener: https://docs.oracle.com/javase/8/docs/api/java/awt/event/MouseListener.html
.. _KeyListener: https://docs.oracle.com/javase/8/docs/api/java/awt/event/KeyListener.html
.. _ActionListener: https://docs.oracle.com/javase/8/docs/api/java/awt/event/ActionListener.html
.. _AbstractAction: https://docs.oracle.com/javase/8/docs/api/javax/swing/AbstractAction.html
.. _Action: https://docs.oracle.com/javase/8/docs/api/javax/swing/Action.html
.. _FunctionalInterface: https://docs.oracle.com/javase/8/docs/api/java/lang/FunctionalInterface.html
.. _dispose: https://docs.oracle.com/javase/8/docs/api/java/awt/Window.html#dispose--
.. _JFrame.setJMenuBar: https://docs.oracle.com/javase/8/docs/api/javax/swing/JFrame.html#setJMenuBar-javax.swing.JMenuBar-
.. _setEnabled: https://docs.oracle.com/javase/8/docs/api/java/awt/Component.html#setEnabled-boolean-
.. _actionPerformed: https://docs.oracle.com/javase/8/docs/api/java/awt/event/ActionListener.html#actionPerformed-java.awt.event.ActionEvent-
.. _ActionEvent: https://docs.oracle.com/javase/8/docs/api/java/awt/event/ActionEvent.html

