import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// LIBRAIRIE GENERIQUE POUR GESTION DES OUTILS ET FONCTIONS

// Couleurs du projet
const Color couleurPrincipale = Color(0xFFFEA52D);
const Color couleurSecondaire = Color(0xFF03A698);

// Classe des options administrateur
class AdminTools {

  // Ajoute un magazine au firestore
  static Future<void> addMagazine(String image, String pdf, String resume, DateTime selectedDate) async {
    try {
      await FirebaseFirestore.instance.collection("mag").add({
        "pdf": pdf,
        "resume": resume,
        "image": image,
        "mois": selectedDate,
        "likes": []
      });
    } catch (e) {
      // Si une erreur se produit, on la gère ici
      print("Erreur lors de l'ajout du magazine : $e");
      throw Exception("Erreur lors de l'ajout du magazine");
    }
    return;
  }

  // Ajoute un événement au firestore
  static Future<void> addEvent(String image, String lieu, String resume, String link, DateTime selectedDate) async {
    try {
      await FirebaseFirestore.instance.collection("Events").add({
        "lieu": lieu,
        "resume": resume,
        "image": image,
        "link": link,
        "date": selectedDate
      });
    } catch (e) {
      // Si une erreur se produit, on la gère ici
      print("Erreur lors de l'ajout de l'événement : $e");
      throw Exception("Erreur lors de l'ajout de l'événement");
    }
    return;
  }

  //Détermine l'URL du magazine dans le drive Firebase à partir de son nom
  static Future<String> getDownloadURL(String filePath) async {
    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(filePath);
    return await fileRef.getDownloadURL();
  }

  // Affiche une date picker pour choisir le mois du magazine
  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    return picked;
  }

  static Future<String> uploadPdfToFirebase(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref("magazine/$fileName")
          .putFile(file);

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Erreur lors de l'upload : $e");
      return "";
    }
  }

  static Future<String> getUserRole(String uid) async { // Get le role de l'utilisateur actuel
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.get('role'); // 'admin' ou 'subscriber'
      }
    } catch (e) {
      print('Erreur lors de la récupération du rôle : $e');
    }
    return 'user'; // Retourne null si aucune information de rôle n'est trouvée
  }

  // Vérifie si l'utilisateur est un administrateur
  static Future<bool> isUserAdmin() async {
    String? role = await getUserRole(FirebaseAuth.instance.currentUser!.uid);
    return role == 'admin';
  }

  // Vérifie si l'utilisateur est un abonné
  static Future<bool> isUserSubscriber() async {
    String? role = await getUserRole(FirebaseAuth.instance.currentUser!.uid);
    return role == 'subscriber';
  }
}