import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikeButton extends StatefulWidget {
  final String magazineId;
  final int likeNumber;
  LikeButton({super.key, required this.magazineId, required this.likeNumber});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false; // initialise la variable booléenne
  late String userMail; // Late signifie une variable pas encore initialisée mais non nulle

  @override

  // INITIALISATION //
  void initState() { // A l'initialisation
    super.initState(); // Initialise le StateFulWidget
    userMail = FirebaseAuth.instance.currentUser!.email ?? ""; // Remplit la variable userMail avec l'email du user, ou vide si pas de user
    checkIfLiked(); // Vérifie si l'utilisateur a déjà liké le magazine
  }

  // VERIFICATION DE L'ETAT DU LIKE //
  Future<void> checkIfLiked() async { // Vérifie si le magazine est déjà liké, Future est utilisé pour les opérations asynchrones, donc qui ne bloquent pas l'exécution du reste (en arrière plan)
    DocumentSnapshot magazineSnapshot = await FirebaseFirestore.instance // Récupère le snapshot du magazine actuel
        .collection('mag')
        .doc(widget.magazineId)
        .get();
    if(magazineSnapshot.exists) { // Si le snapshot est trouvé
      List<dynamic> likes = magazineSnapshot['likes'] ?? []; // Créé une liste à partir de tous les likes dans la bdd du magazine
      setState(() {
        isLiked = likes.contains(userMail); // Met isLiked à true si l'email du user actuel est dans la liste
      });
    }
  }

  // AJOUT D'UN LIKE //
  Future<void> addLikeToMag() async { // Ajoute le like au magazine
    if(userMail.isEmpty) { // Quitte si l'utilisateur n'est pas connecté
      print("Utilisateur non connecté");
      return;
    }

    final magazineRef = FirebaseFirestore.instance.collection("mag").doc(widget.magazineId); // Récupère le magazine liké
    DocumentSnapshot magazineSnapshot = await magazineRef.get();

    if(magazineSnapshot.exists) {
      List<dynamic> likes = List.from(magazineSnapshot["likes"] ?? [""]);
      if(isLiked) {
        likes.remove(userMail);
      } else {
        likes.add(userMail);
      }
      await magazineRef.update({'likes': likes}); // Met à jour la liste des likes dans la bdd du magazine
      setState(() {
        isLiked = !isLiked; // Inverse l'état du like pour ne pas avoir à le re-checker
      });
    }
  }

  // CONTENU DU BOUTTON //
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: addLikeToMag, // Appeler la fonction pour ajouter ou retirer le like
      icon: Icon(
        Icons.favorite, // Affiche l'icône en fonction du like
        color: isLiked ? Colors.white: Colors.red, // Couleur selon le statut du like,
      ),
      label: Text(
        "${widget.likeNumber}",
        style: TextStyle(color: isLiked ? Colors.white: Colors.black),),
      style: ElevatedButton.styleFrom(
          backgroundColor: isLiked ? Colors.red: Colors.white,
          padding: EdgeInsets.zero,
          minimumSize: Size(60, 40), // Réduit la taille minimale du bouton
      ),
    );
  }
}