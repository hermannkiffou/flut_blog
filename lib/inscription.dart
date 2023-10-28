import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_blog/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Inscription extends StatefulWidget {
  static const String id = "inscription";

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String message = "";
  bool loading = false;

  Future<void> createUser() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if (newUser != null) {
          // Navigator.pushNamed(context, Contacts.id);
          setState(() {
            message = "Utilisateur créé avec succes";
          });
          Navigator.pushNamed(context, HomePage.id);
        } else {
          setState(() {
            message = "Echec ! Ce compte existe deja !";
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "email-already-in-use") {
        setState(() {
          message = "Utilisateur exist deja ";
        });
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'INSCRIPTION',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Adresse Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veillez renseigner votre email";
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Mot de passe",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vous devez renseigner le mot de passe";
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Confiremation de Mot de passe",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vous devez confirmer le mot de passe!";
                    } else {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return "Mot de passe et confirmation non identique";
                      } else {
                        return null;
                      }
                    }
                  }),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        createUser();
                      },
                      child: Text("S'inscrire"),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, HomePage.id),
                child: Text("J'ai déjà un compte"),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
