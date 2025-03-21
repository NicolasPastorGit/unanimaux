import 'package:flutter/material.dart';

class disabledMagazine extends StatelessWidget {
  const disabledMagazine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey, // Couleur grisée pour montrer qu'il est désactivé
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6), // Ajoute un peu d'espace intérieur
        leading: Icon(Icons.event_busy, color: Colors.white, size: 38),
        title: Text(
          "Prochain numéro à venir...",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Anton',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          "Suivez nous sur Instagram pour être tenu au courant !",
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: Icon(Icons.article_rounded, color: Colors.white),
      ),
    );
  }
}