import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Holbegram',
          style: TextStyle(
            fontFamily: 'Billabong',
          ),
        ),
        actions: const [
          Row(
            children: [
              Icon(Icons.add),
              Icon(Icons.favorite),
            ],
          ),
        ],
      ),
      body: Posts(),
    );
  }
}

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index].data();
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsetsGeometry.lerp(
                    const EdgeInsets.all(8),
                    const EdgeInsets.all(8),
                    10,
                  ),
                  height: 540,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                data['profImage'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(data['username']),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_horiz),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Post Deleted'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Text(data['caption']),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Image.network(
                          data['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
