import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> data = snapshot.data!.docs;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 540,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: data.map((post) {
                  String profImage = post['profImage'];
                  String username = post['username'];
                  String caption = post['caption'];
                  String postUrl = post['postUrl'];

                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(profImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(username),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {
                                const SnackBar(
                                  content: Text('Post Deleted'),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Text(caption),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              image: NetworkImage(postUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
