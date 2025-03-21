import 'package:file_picker/file_picker.dart';
import 'package:unanimaux/tool_lib.dart';
import 'package:flutter/material.dart';

class addMagazineDialog extends StatefulWidget {
  const addMagazineDialog({super.key});

  @override
  State<addMagazineDialog> createState() => addMagazineDialogState();
}

class addMagazineDialogState extends State<addMagazineDialog> {
  DateTime? selectedDate; //Déclare le champ de date à sélectionner
  String? selectedFilePath; // Variable pour stocker le chemin du fichier sélectionné
  String? selectedFileName; // Nom affiché du pdf sélectionné

  @override
  Widget build(BuildContext context) {
    // Déclarez les contrôleurs ici pour la boîte de dialogue
    TextEditingController imageController = TextEditingController(text: 'logo');
    TextEditingController resumeController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text("Ajouter un magazine"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text( // Set la date du jour par défaut
                  "Date choisie : ${selectedDate?.day ?? DateTime
                      .now()
                      .day}/${selectedDate?.month ?? DateTime
                      .now()
                      .month}/${selectedDate?.year ?? DateTime
                      .now()
                      .year}",
                ),
                trailing: Icon(Icons.calendar_month),
                onTap: () async {
                  final DateTime? date = await AdminTools.selectDate(context);
                  if (date != null) {
                    setState(() {
                      selectedDate = date; // Mettez à jour la date sélectionnée
                    });
                  }
                },
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
              SizedBox(height: 10),
              ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(couleurPrincipale)),
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );

                  if (result != null) {
                    setState(() {
                      selectedFilePath = result.files.single
                          .path; // Mettez à jour le chemin du fichier
                      selectedFileName = result.files.single
                          .name; // Mettez à jour le nom du fichier sélectionné
                    });
                  }
                },
                icon: Icon(Icons.attach_file, color: Colors.white),
                label: Text(
                  "Joindre un PDF",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: "Anton"
                  ),
                ),
              ),
              if (selectedFileName != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Fichier sélectionné: $selectedFileName",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
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
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(couleurPrincipale)),
              onPressed: () async {
                if (selectedFileName != null && selectedDate != null &&
                    selectedFilePath != null) {
                  String fileNameWithoutExtension = selectedFileName!.split('.')
                      .first; // Retire l'extension au nom du fichier
                  if (!mounted)
                    return; // Vérifie si le widget existe toujours avant d'utiliser `context`
                  // Uploader le fichier sur Firebase Storage
                  AdminTools.addMagazine(
                    imageController.text,
                    fileNameWithoutExtension, // Utilisez le chemin du fichier
                    resumeController.text,
                    selectedDate!,
                  );
                  Navigator.pop(context);
                }
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
      },
    );
  }
}