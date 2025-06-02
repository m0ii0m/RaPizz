package com.rapizz.model;

import java.math.BigDecimal;

public class Pizza {
    private int id;
    private String nom;
    private BigDecimal prixBase;

    public Pizza(int id, String nom, BigDecimal prixBase) {
        this.id = id;
        this.nom = nom;
        this.prixBase = prixBase;
    }

    public int getId() { return id; }
    public String getNom() { return nom; }
    public BigDecimal getPrixBase() { return prixBase; }

    @Override
    public String toString() {
        return nom + " (" + prixBase + " €)";
    }
}
