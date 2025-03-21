import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unanimaux/components/disabledMagazine.dart';
import 'package:unanimaux/components/magazine_items.dart';
import 'package:unanimaux/components/show_add_magazine_dialog.dart';
import 'package:unanimaux/tool_lib.dart';
import 'package:flutter/material.dart';

class MagPage extends StatefulWidget {
  const MagPage({super.key});
  @override
  State<MagPage> createState() => _MagPageState();
}

class _MagPageState extends State<MagPage> {

  bool isAdmin = false; // Par défaut l'utilisateur n'est pas un admin
  bool isSubscriber = false; // Par défaut l'utilisateur n'est pas un abonné
  bool isLiked = false; // Par défaut chaque article n'est pas liké
  final currentUser = FirebaseAuth.instance.currentUser!; // Identifie le user pour savoir s'il a liké

//  @override
//  void initState() {
//    super.initState();
//    _checkUserRole();
//    isLiked = widget.likes.containe(currentUser.email);
//  }

  // Vérifie les rôles de l'utilisateur
//  Future<void> _checkUserRole() async {
//    bool adminStatus = await AdminTools.isUserAdmin();
//    bool subscriberStatus = await AdminTools.isUserSubscriber();
//    setState(() {
//      isAdmin = adminStatus;
//      isSubscriber = subscriberStatus;
//    });
//  }

  @override

  Widget build(BuildContext context) {
    return Stack( // Stack permet de superposer le bouton d'ajout de magazines et la liste de magazines
      children: [
        Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("mag").orderBy("mois").snapshots(), //Se connecte à notre BDD en fait une snapshot en triant les magazines par date
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){ //Récupère la réponse à la requête et stocke la réponse dans la QuerySnapshot
              if (snapshot.connectionState == ConnectionState.waiting){ //Si l'état de connexion = en attente, affiche un indicateur de chargement
                return CircularProgressIndicator(color: couleurSecondaire);
              }

              if (!snapshot.hasData){ //Si le snapshot ne contient aucune donnée
                return Text("Aucun magazine");
              }

              List<Map<String, dynamic>> mag = snapshot.data!.docs.map( // Créé la liste des magazines à partir du snapshot
                    (doc) => doc.data() as Map<String, dynamic>,
              ).toList();

              return ListView.builder(
                  itemCount: mag.length + 1, // Autant d'items que de magazines, +1 pour le "prochain numéro" grisé
                  itemBuilder: (context, index) {
                    // Magazine grisé "à venir"
                    if (index == mag.length) { // Si on est au dernier index, afficher le Tile désactivé
                      return disabledMagazine();
                    }
                    return MagazineItems( // Concernant la liste des magazines à afficher :
                      mag: mag[index],
                      isSubscriber: isSubscriber,
                      isAdmin: isAdmin,
                    );
                  }
              );
            },
          ),
        ),
        if (isAdmin)
          Positioned( // Positionne en bas à gauche
            bottom: 16,
            right: 16,
            child: FloatingActionButton( // Bouton d'ajout de magazine
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return addMagazineDialog(); // Appel le widget d'ajout de magazine dans une pop-up
                  },
                );
              },
              backgroundColor: couleurSecondaire,
              foregroundColor: Colors.white,
              child: Icon(Icons.add, size: 40,),
            ),
          )
      ],
    );
  }
}