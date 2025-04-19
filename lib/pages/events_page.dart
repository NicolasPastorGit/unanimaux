import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unanimaux/tool_lib.dart';
import 'package:unanimaux/components/open_link_button.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  bool isAdmin = false; // Par défaut l'utilisateur n'est pas un admin

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  // Vérifie si l'utilisateur est un admin
  Future<void> _checkAdminStatus() async {
    bool adminStatus = await AdminTools.isUserAdmin();
    setState(() {
      isAdmin = adminStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(  // Stack permet de superposer le bouton d'ajout d'événements et la liste d'events
      children: [
        Center(
            child: StreamBuilder( //Le streambuilder remonte en temps reel l'évolution des events sur firebase
              stream: FirebaseFirestore.instance.collection("Events").orderBy("date").snapshots(), //Se connecte à notre BDD en fait une snapshot en triant les événements par date
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){ //Récupère la réponse à la requête et stocke la réponse dans la QuerySnapshot
                if (snapshot.connectionState == ConnectionState.waiting){ //Si l'état de connexion = en attente, affiche un indicateur de chargement
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData){ //Si le snapshot ne contient aucune donnée
                  return Text("Aucun événement");
                }

                List<dynamic> events = []; //Liste d'événements alimentée par le snapshot de la BDD
                snapshot.data!.docs.forEach((element) { //Pour chaque élément du snapshot (! précise que data n'est pas vide, on l'a vérifié)
                  events.add(element);
                });

                return ListView.builder(
                    itemCount: events.length + 1,
                    itemBuilder: (context, index){
                      // Événement grisé "à venir"
                      if (index == events.length) {
                        // Si on est au dernier index, afficher le Tile désactivé
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
                              "Événement à venir...",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Anton',
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              "Bientôt disponible...",
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            trailing: Icon(Icons.expand_more, color: Colors.white),
                          ),
                        );
                      }

                      // Afficher avant les tiles dynamiques
                      final event = events[index];
                      final Timestamp timestamp = event["date"];
                      final String date = DateFormat.yMMMMd('fr_FR').format(timestamp.toDate());
                      final String heure = DateFormat.Hm('fr_FR').format(timestamp.toDate());
                      final image = event["image"];
                      final resume = event["resume"];
                      final lieu = event["lieu"];
                      final link = event["link"];

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Espacement entre les items
                        decoration: BoxDecoration(
                          color: couleurPrincipale, // Couleur de fond
                          borderRadius: BorderRadius.circular(12), // Coins arrondis
                          boxShadow: [ // Effet d'ombre pour un rendu plus propre
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Supprime les marges inutiles
                          ),
                          tilePadding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6), // Ajoute un peu d'espace intérieur
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8), // Arrondit aussi l’image
                            child: Image.asset("assets/images/$image.png"),
                          ),
                          title: Text(
                            "$resume",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Anton',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            "$date",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins'
                            ),
                          ),
                          trailing: Icon(Icons.expand_more, color: Colors.white),
                          children: <Widget>[
                            Container(
                                color: Color(0xFFFFB35B),
                                child: ListTile(
                                    title:
                                    Row(children: [
                                      Text(
                                        "Thème de l'événement : ",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                      Text(
                                          "$resume",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Anton"
                                          )
                                      ),
                                    ],),
                                    subtitle: DefaultTextStyle(
                                      style: TextStyle(fontSize: 16, color: Colors.white), // Applique ce style à tous les enfants
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text(
                                                "Date : "
                                            ),
                                            Text(
                                                "$date",
                                                style: TextStyle(
                                                    fontFamily: "Anton"
                                                )
                                            ),
                                          ],
                                          ),
                                          Row(children: [
                                            Text(
                                                "Heure : "
                                            ),
                                            Text(
                                                "$heure",
                                                style: TextStyle(
                                                    fontFamily: "Anton"
                                                )
                                            ),
                                          ],
                                          ),
                                          Row(children: [
                                            Text("Lieu : "),
                                            Text("$lieu", style: TextStyle(fontFamily: "Anton")),
                                          ]),
                                          OpenLinkButton(textButton: "En savoir plus", url: link)
                                        ],
                                      ),
                                    )
                                )
                            )
                          ],
                        ),
                      );
                    }
                );
              },
            )
        ),
        if (isAdmin)
          Positioned( // Positionne en bas à gauche
            bottom: 16,
            right: 16,
            child: FloatingActionButton( // Bouton d'ajout d'événement
              onPressed: () {
                _showAddEventDialog(context); // Appelle la fonction de pop-up d'ajout d'événement
              },
              backgroundColor: couleurPrincipale,
              foregroundColor: Colors.white,
              child: Icon(Icons.add, size: 40,),
            ),
          )
      ],
    );
  }

  DateTime? selectedDate; // Déclare le champ de date à sélectionner

  // Fonction pour afficher une pop-up d'ajout d'événement
  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController imageController = TextEditingController(text: 'logo');
        TextEditingController lieuController = TextEditingController();
        TextEditingController resumeController = TextEditingController();
        TextEditingController linkController = TextEditingController();

        // Variables locales pour la date
        DateTime? dialogSelectedDate = selectedDate;

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Ajouter un événement"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text( // Set la date du jour par défaut
                        "Date choisie : ${dialogSelectedDate?.day ?? DateTime.now().day}/${dialogSelectedDate?.month ?? DateTime.now().month}/${dialogSelectedDate?.year ?? DateTime.now().year}",
                      ),
                      trailing: Icon(Icons.calendar_month),
                      onTap: () async {
                        final DateTime? date = await AdminTools.selectDate(context);
                        if (date != null) {
                          setState(() {
                            dialogSelectedDate = date; // Mise à jour de la date sélectionnée
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: lieuController,
                      decoration: InputDecoration(
                          labelText: "Lieu de l'événement",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: couleurPrincipale)
                          ),
                          labelStyle: TextStyle(color: Colors.grey)
                      ),
                      cursorColor: Colors.grey,
                    ),
                    TextField(
                      controller: resumeController,
                      decoration: InputDecoration(
                          labelText: "Résumé rapide",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: couleurPrincipale)
                          ),
                          labelStyle: TextStyle(color: Colors.grey)
                      ),
                      cursorColor: Colors.grey,
                    ),
                    TextField(
                      controller: imageController,
                      decoration: InputDecoration(
                          labelText: "Nom de l'image associée",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: couleurPrincipale)
                          ),
                          labelStyle: TextStyle(color: Colors.grey)
                      ),
                      cursorColor: Colors.grey,
                    ),
                    TextField(
                      controller: linkController,
                      decoration: InputDecoration(
                          labelText: "Lien d'information",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: couleurPrincipale)
                          ),
                          labelStyle: TextStyle(color: Colors.grey)
                      ),
                      cursorColor: Colors.grey,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "ANNULER",
                      style: TextStyle(
                          fontSize: 15,
                          color: couleurSecondaire,
                          fontFamily: "Anton"
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(couleurPrincipale)),
                    onPressed: () {
                      AdminTools.addEvent(
                        imageController.text,
                        lieuController.text,
                        resumeController.text,
                        linkController.text,
                        dialogSelectedDate!,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "AJOUTER",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: "Anton"
                      ),
                    ),
                  ),
                ],
              );
            }
        );
      },
    );
  }
}
