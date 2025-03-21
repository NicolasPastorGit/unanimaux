import 'package:flutter/material.dart';
import 'package:unanimaux/tool_lib.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _formKey = GlobalKey<FormState>(); //Les GlobalKey permettent de remonter l'état actuel du formule (champs remplis ou non, RAZ, etc)

  final surnameController = TextEditingController(); //Controleurs permettant de remonter le contenu des champs du formulaire
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  String selectedSubject = "mag"; //Initialise une variable contenant le choix de sujet

  @override
  void dispose() { //Libère l'espace de stockage contenant le contenu de ces champs lorsque l'application passe en arrière-plan
    super.dispose();
    surnameController.dispose();
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Nom",
                  hintText: "Entrez votre nom"
              ),
              validator: (value){ //Valide ou non le contenu du formulaire, ici il faut que le champ ne soit pas vide
                if (value == null || value.isEmpty){
                  return "Champ obligatoire";
                }
                return null;
              },
              controller: surnameController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Prénom",
                  hintText: "Entrez votre prénom"
              ),
              validator: (value){
                if (value == null || value.isEmpty){
                  return "Champ obligatoire";
                }
                return null;
              },
              controller: nameController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "E-mail",
                  hintText: "Entrez votre e-mail"
              ),
              validator: (value){
                if (value == null || value.isEmpty){
                  return "Champ obligatoire";
                }
                return null;
              },
              controller: emailController,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: DropdownButtonFormField( //Boite à choix multiples
                  items: [
                    DropdownMenuItem(value: 'mag', child: Text("Magazine")),
                    DropdownMenuItem(value: 'event', child: Text("Événement")),
                    DropdownMenuItem(value: 'collab', child: Text("Partenariat"))
                  ],
                  value: selectedSubject, //La valeur est une variable contenant le choix
                  onChanged: (value) { //Sur un changement de choix, change la valeur de la variable
                    setState(() {
                      selectedSubject = value!;
                    });

                  }
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Champ obligatoire";
                  }
                  return null;
                  },
                controller: messageController, //Lie le contenu du champ au controlleur
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(couleurPrincipale)
                  ),
                  onPressed: (){
                    if (_formKey.currentState!.validate()){ //Si tout est valide et qu'on appuie sur le bouton, affiche une snackbar
                      final name = nameController.text; //Assigne le contenu du controlleur à une variable lors de la validation du formulaire
                      final surname = surnameController.text;
                      final email = emailController.text;
                      final message = messageController.text;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Envoi en cours..."))
                      );
                      FocusScope.of(context).requestFocus(FocusNode()); //Sur pression sur le bouton, ferme le clavier en remettant le focus sur l'écran

                      print("Envoi du message $message par $name $surname de $email.");
                      print("Sujet : $selectedSubject");
                    };
                  },
                  child: Text(
                    "Envoyer",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
            )
          ],
        )
      ),
    );
  }
}