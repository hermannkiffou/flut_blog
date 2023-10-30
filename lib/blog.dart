import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatefulWidget {
  static const String id = "blogpage";

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String message = "";
  bool loading = false;
  String userId = "";
  String userEmail = "";

  @override
  void initState() {
    // TODO: implement initState
    var currentUser = auth.currentUser;
    if (currentUser != null) {
      setState(() {
        userId = currentUser.uid;
        userEmail = currentUser.email!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("Bienvenue "), Text(userEmail)],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Déconnexion", style: TextStyle(color: Colors.white)))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
                child: Text(
              "List de Mes blogs",
              style: TextStyle(
                fontSize: 30,
              ),
            )),
            StreamBuilder(
              stream: _firestore
                  .collection('blog')
                  .where('user', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Erreur de chargement des données !"),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                QuerySnapshot data = snapshot.requireData as QuerySnapshot;
                return Expanded(
                  child: ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        Map item = data.docs[index].data() as Map;
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.article),
                            title: item['title'],
                            subtitle: item['content'],
                            trailing: Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    print(
                                        "Edit $index - id: ${item['documentID']}");
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                  onPressed: () {
                                    print(
                                        "Delete $index  - id: ${item['documentID']}");
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          titleController.clear();
          contentController.clear();
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Ajouez Un blog"),
                  content: blogForm(),
                  actions: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler"),
                    ),
                    loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              addBlog();
                              setState(() {
                                loading = false;
                              });
                            },
                            child: const Text("Ajouter"),
                          ),
                  ],
                );
              });
        },
        label: const Text("Ajouter un blog"),
      ),
    );
  }

  Future<void> addBlog() async {
    setState(() {
      loading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var blog = _firestore.collection('blog').add({
          'title': titleController.text,
          'content': contentController.text,
          'user': userId,
        });
        if (blog != null) {
          setState(() {
            message = "Blog ajouté avec succès";
          });
          Navigator.pop(context);
        } else {
          setState(() {
            message = "Blog non ajouté";
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        message = "Echec l'enregistrement: ${e.code}";
      });
    }
    setState(() {
      loading = false;
    });
  }

  blogForm() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.2,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Titre du blog"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veillez renseigner un titre";
                    } else {
                      return null;
                    }
                  }),
              TextFormField(
                  maxLines: 30,
                  controller: contentController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: "Contenu"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Veillez renseigner Le contenue de votre blog";
                    } else {
                      return null;
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
