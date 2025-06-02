package com.rapizz.ui;

import javax.swing.*;
import com.rapizz.ui.panels.*;

public class MainFrame extends JFrame {
    public MainFrame() {
        super("RaPizz");
        setSize(800, 600);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        JTabbedPane tabs = new JTabbedPane();
        tabs.addTab("Menu", new MenuPanel());
        tabs.addTab("Commande", new CommandePanel());
        tabs.addTab("Statistiques", new StatsPanel());
        add(tabs);
    }
}
