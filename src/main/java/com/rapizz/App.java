package com.rapizz;

import javax.swing.SwingUtilities;
import com.rapizz.ui.MainFrame;

public class App {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new MainFrame().setVisible(true));
    }
}
