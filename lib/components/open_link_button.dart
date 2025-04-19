import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unanimaux/tool_lib.dart';

// Composant permettant d'afficher un bouton qui ouvre un lien lors du clic

class OpenLinkButton extends StatelessWidget {
  final String textButton; // En variable le texte du bouton
  final String url; // En variable l'url à ouvrir lors du clic
  const OpenLinkButton({super.key, required this.textButton, required this.url});

  // Fonction pour ouvrir l'url
  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url); // Modifie l'url pour la rendre utilisable
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Ouvre le lien via une application externe
    } catch (e) {
      debugPrint("Impossible d'ouvrir le lien $url : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        minimumSize: Size(120, 30), // Réduit la taille minimale du bouton
        backgroundColor: couleurSecondaire,
      ),
      child: Text("$textButton",
        style: TextStyle(
            color: Colors.white,
            fontFamily: "Anton"
        ),
      ),
    );
  }
}
