import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user connected'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 32,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(
              child: Text(
                'Error ${userSnapshot.error}',
              ),
            );
          }

          if (userSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!userSnapshot.hasData ||
              !userSnapshot.data!.exists) {
            return const Center(
              child: Text('User not found'),
            );
          }

          final userData =
              userSnapshot.data!.data() as Map<String, dynamic>;

          final List<dynamic> saved =
              userData['saved'] ?? [];

          if (saved.isEmpty) {
            return const Center(
              child: Text(
                'No favorite posts yet',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .snapshots(),
            builder: (context, postSnapshot) {
              if (postSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Error ${postSnapshot.error}',
                  ),
                );
              }

              if (postSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final posts = postSnapshot.data!.docs.where(
                (doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;

                  final String postId =
                      data['postId'] ?? doc.id;

                  return saved.contains(postId);
                },
              ).toList();

              if (posts.isEmpty) {
                return const Center(
                  child: Text(
                    'No favorite posts yet',
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(4),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final data =
                      posts[index].data()
                          as Map<String, dynamic>;

                  final String postUrl =
                      data['postUrl'] ?? '';

                  if (postUrl.isEmpty) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image,
                      ),
                    );
                  }

                  return Image.network(
                    postUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.broken_image,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
