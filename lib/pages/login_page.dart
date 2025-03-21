import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unanimaux/tool_lib.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController(); // Set un controller pour récupérer le contenu de l'email
  final passwordController = TextEditingController(); // Set un controller pour récupérer le contenu du mot de passe

  Future<void> login() async {
    try { // Tente un login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Récupération de l'UID de l'utilisateur
      String uid = userCredential.user!.uid;

      // Accès à Firestore pour récupérer le rôle de l'utilisateur
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role']; // Récupération du rôle

        if (role == "admin") {
          print("L'utilisateur est un administrateur");
          // Ici, tu peux rediriger vers une page admin ou activer certaines fonctionnalités
        }
        else if (role == "subscriber") {
          print("L'utilisateur est un abonné");
        }
        else {
          print("L'utilisateur est un simple utilisateur");
        }
      }
      else {
        print("Erreur : L'utilisateur n'a pas de rôle défini.");
      }
    }
    catch (e) {
      print("Erreur de connexion : $e");
    }
  }

  Future<void> register() async {
    try { // Tente de créer l'utilisateur
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // L'utilisateur est automatiquement ajouté à la BDD avec un role user par défaut
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': emailController.text,
        'role': 'user', // Par défaut, tous les nouveaux utilisateurs sont des users
      });
    }
    catch (e) { // Si erreur dans la création de l'utilisateur, print une erreur
      print("Erreur d'inscription : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // AppBar spécifique à la page
        backgroundColor: couleurPrincipale,
        title: const Text("Connexion", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Anton'))
      ),
      body: Center( // Centre tous les éléments de la page
        child: Padding( // Espace tous les éléments de la page
          padding: const EdgeInsets.all(32.0), // Choix de l'espacement
          child: Form( // Formulaire
            child: Column( // Tous les éléments en colonne
              children: [
                TextFormField( // Texte à remplir
                  decoration: InputDecoration(hintText: "Email"), // Prérempli pour indiquer le type de champ
                  controller: emailController, // Le contenu se range dans le controller
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Mot de passe"),
                  controller: passwordController,
                ),
                SizedBox(height: 20), // Ajoute un espace de 20 pixels
                ElevatedButton(
                  onPressed: () { // Sur clic sur le bouton
                    if (emailController.text.isNotEmpty && passwordController.text.length > 6) { // Si le champ email n'est pas vide et que le password fait plus de 6 char
                      login(); // Appelle la fonction permettant de se login
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(couleurPrincipale)
                  ),
                  child: const Text(
                    "Connexion",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Anton"
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () { // Sur clic sur le bouton
                    if (emailController.text.isNotEmpty && passwordController.text.length > 6) { // Si le champ email n'est pas vide et que le password fait plus de 6 char
                      register(); // Appelle la fonction permettant de créer un compte
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Color((0xFF03A698)))
                  ),
                  child: const Text(
                    "Inscription",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Anton"
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}