import 'package:flutter/material.dart';

// Définition des couleurs principales et secondaires
const Color couleurPrincipale = Color(0xFFFEA52D); // Couleur principale (orange)
const Color couleurSecondaire = Color(0xFF03A698); // Couleur secondaire (turquoise)

// Personnalisation des polices
const String fontFamilyDefault = 'Poppins';

// Fonction pour créer le thème principal
ThemeData appTheme() {
  return ThemeData(
    // Utilisation de colorScheme pour définir les couleurs principales et secondaires
    colorScheme: ColorScheme.light(
      primary: couleurPrincipale, // Couleur principale
      secondary: couleurSecondaire, // Couleur secondaire
      surface: Colors.white, // Remplace 'background' par 'surface'
      error: Colors.red,
      onPrimary: Colors.white, // Couleur du texte sur le primaire (comme les boutons)
      onSecondary: Colors.white, // Couleur du texte sur le secondaire
      onSurface: Colors.black, // Couleur du texte sur surface (fond)
      onError: Colors.white,
      brightness: Brightness.light,
    ),

    // Police par défaut
    fontFamily: fontFamilyDefault,

    // Style des boutons élevés (ElevatedButton)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: couleurPrincipale, // Utiliser backgroundColor au lieu de primary
        foregroundColor: Colors.white, // Utiliser foregroundColor pour la couleur du texte
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Coins arrondis
        ),
      ),
    ),

    // Personnalisation des champs de texte (TextFormField)
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        color: couleurPrincipale, // Couleur du label
        fontWeight: FontWeight.bold, // Gras pour les labels
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: couleurPrincipale), // Bordure au focus
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // Bordure désactivée
      ),
    ),

    // Définition de la couleur des AppBars
    appBarTheme: AppBarTheme(
      backgroundColor: couleurPrincipale, // Couleur de fond de l'AppBar
      titleTextStyle: TextStyle(
        color: Colors.white, // Couleur du texte du titre
        fontSize: 20, // Taille du titre
        fontWeight: FontWeight.bold, // Gras
      ),
    ),

    // Personnalisation des boutons dans les DatePickers
    buttonTheme: ButtonThemeData(
      buttonColor: couleurPrincipale, // Couleur des boutons dans DatePicker
      textTheme: ButtonTextTheme.primary, // Couleur du texte du bouton
    ),
  );
}
