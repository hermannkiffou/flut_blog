import 'package:firebase_auth/firebase_auth.dart';
import 'package:flut_blog/blog.dart';
import 'package:flut_blog/inscription.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String message = "";
  bool loading = false;

  Future<void> connexion() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        final connectUser = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        if (connectUser != null) {
          emailController.clear();
          passwordController.clear();
          Navigator.pushNamed(context, BlogPage.id);
        } else {
          setState(() {
            message = "Adresse email ou mot de passe incorrecte";
          });
        }
      }
    } catch (error) {
      setState(() {
        message = "Echec de la connexion. verifier vos coordonnées";
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    emailController.text = '@';
    super.initState();
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
                'CONNEXION',
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
                  decoration: InputDecoration(hintText: "Email"),
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
                      return "Veillez renseigner votre Mot de passe";
                    } else {
                      return null;
                    }
                  }),
              loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        connexion();
                      },
                      child: Text("Se connecter"),
                    ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Inscription.id),
                child: Text("Je n'ai pas de compte"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
