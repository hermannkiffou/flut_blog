import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flut_blog/service/blogService.dart';
import 'package:flutter/material.dart';

class BlogController extends StatelessWidget {
  final BlogService blogService = BlogService();

  @override
  String getBlogId(String id) {
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: blogService.getBlogStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documents = snapshot.data?.docs;
          return ListView.builder(
            itemCount: documents?.length,
            // ignore: dead_code
            itemBuilder: (context, index) {
              final data = documents?[index].data() as Map<String, dynamic>;
              print(data);

              print(documents?[index].id);
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                        width: 2,
                        color: Colors.orange,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Code : ${data['blogID']}",
                        ),
                        Text(
                          'Title : ${data['title']}',
                        ),
                        Text(
                          'Title : ${data['content']}',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                var del = blogService
                                    .deleteBlog(documents?[index].id);
                                if (del) {
                                  print("Utilisateur supprimé avec succès !");
                                } else {
                                  print(
                                      "Echec de la suppression de l'utilisateur");
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            IconButton(
                              onPressed: () {
                                getBlogId(documents![index].id);
                              },
                              icon: const Icon(
                                Icons.edit,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
