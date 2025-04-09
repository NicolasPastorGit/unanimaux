import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final VoidCallback onNavigateToMagPage;

  const HomePage({
    super.key,
    required this.onNavigateToMagPage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 200,
            ),
            Text(
              "UNANIMAUX",
              style: TextStyle(
                  fontSize: 34,
                  fontFamily: "Anton"
              ),
            ),
            Text("Tous unis pour les animaux",
              style: TextStyle(
                  fontSize: 18
              ),
              textAlign: TextAlign.center,
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFFEA52D))
                ),
                onPressed: onNavigateToMagPage,
                label: Text(
                  "Nos magazines 2025",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "Anton"
                  ),
                ),
                icon: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 25,
                )
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color((0xFF03A698)))
              ),
              child: const Text(
                "Déconnexion",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "Anton"
                ),
              ),
            ),
          ],
        )
    );
  }
}