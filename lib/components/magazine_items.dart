import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unanimaux/components/like_button.dart';
import 'package:unanimaux/tool_lib.dart';

// Génère des variables pour les contenus de chaque magazine
class MagazineItems extends StatelessWidget {
  final Map<String, dynamic> mag;
  final bool isSubscriber;
  final bool isAdmin;

  const MagazineItems({
    Key? key,
    required this.mag,
    required this.isSubscriber,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = mag["image"];
    final Timestamp timestampmensuel = mag["mois"]; // On utilise un champ timestamp (au 2 du mois pour prblèmes d'UTC) pour trier et titrer
    final String mois = DateFormat.yMMMM('fr_FR').format(timestampmensuel.toDate()).toUpperCase();
    final resume = mag["resume"];
    final String pdfPath = mag["pdf"]; // Chemin du PDF dans Firestore
    final magazineId = mag["id"];
    final likeNumber = mag["likes"].length;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Espacement entre les items
          decoration: BoxDecoration(
            color: couleurSecondaire, // Couleur de fond
            borderRadius: BorderRadius.circular(12), // Coins arrondis
            boxShadow: const [ // Effet d'ombre pour un rendu plus propre
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6), // Ajoute un peu d'espace intérieur
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Arrondit aussi l’image
              child: Image.asset("assets/images/$image.png"),
            ),
            title: Text(
              '$mois',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Anton',
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              "$resume",
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins'
              ),
            ),
            trailing: const Icon(Icons.article_rounded, color: Colors.white),
            onTap: () async {
              if(isSubscriber || isAdmin) {
                String downloadURL = await AdminTools
                    .getDownloadURL(
                    "magazine/$pdfPath.pdf"); // Récupère l'URL du fichier à afficher à partir de son nom

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SfPdfViewer.network(
                            downloadURL), // Charge le PDF depuis son URL Firestore
                  ),
                );
              } else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Accès réservé aux abonnés"))); }
            },
          ),
        ),
        Positioned( // Positionne en bas à droite les likes
            bottom: 0,
            right: 30,
            child: LikeButton(magazineId: magazineId, likeNumber: likeNumber)
        ),
      ],
    );
  }
}