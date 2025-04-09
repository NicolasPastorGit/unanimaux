import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:unanimaux/pages/contact_page.dart';
import 'package:unanimaux/pages/events_page.dart';
import 'package:unanimaux/pages/home_page.dart';
import 'package:unanimaux/pages/login_page.dart';
import 'package:unanimaux/pages/mag_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:unanimaux/tool_lib.dart';

void main() async {
  await initializeDateFormatting('fr_FR', null); // Initialise le format de dates françaises

  WidgetsFlutterBinding.ensureInitialized(); //Vérifie que toutes les dépendances (surtout firebase) sont initialisées avant de lancer la suite du code

  await Firebase.initializeApp( //Détermine sur quelle plateforme/OS est lancée l'app (pour la BDD firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate( // Défini l'appCheck de Firebase pour sécuriser le dialogue API
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Scaffold(
                appBar: AppBar(
                  title: [
                    Text("Accueil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Anton')),
                    Text("Nos magazines", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Anton')),
                    Text("Nos événéments", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Anton')),
                    Text("Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Anton'))
                  ][_currentIndex],
                  backgroundColor: _currentIndex == 2 ? couleurSecondaire : couleurPrincipale,
                ),
                body: [
                  HomePage(
                      onNavigateToMagPage: () => setCurrentIndex(1)
                  ),
                  MagPage(),
                  EventsPage(),
                  ContactPage()
                ][_currentIndex],
                bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    onTap: (index) => setCurrentIndex(index),
                    selectedItemColor: couleurPrincipale,
                    iconSize: 35,
                    elevation: 10,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Accueil',
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.auto_stories_sharp),
                          label: 'Magazines'
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month),
                          label: 'Événements'
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.chat),
                          label: 'Contact'
                      )
                    ]
                ),
              );
            }
            else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator()
              );
            }
            return LoginPage();
          },
        )
    );
  }
}
