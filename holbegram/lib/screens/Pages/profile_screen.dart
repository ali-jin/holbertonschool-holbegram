import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holbegram/methods/auth_methods.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String uid = '';
  String username = '';
  String profImage = '';
  int postCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        uid = user.uid;

        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            username = userData['username'] ?? 'User';
            profImage = userData['profImage'] ?? '';
          });
        }

        // Get post count
        QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: uid)
            .get();

        setState(() {
          postCount = postsSnapshot.docs.length;
        });
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  void logout() async {
    try {
      await AuthMethode().signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Information Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Picture
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: profImage.isNotEmpty ? null : Colors.red,
                  ),
                  child: profImage.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: profImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                ),

                const SizedBox(width: 20),

                // User Statistics
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(postCount.toString(), 'posts'),
                          _buildStatColumn(
                              followersCount.toString(), 'followers'),
                          _buildStatColumn(
                              followingCount.toString(), 'following'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Username
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                username,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Posts Grid
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No posts yet',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    String imageUrl = data['imageUrl'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
