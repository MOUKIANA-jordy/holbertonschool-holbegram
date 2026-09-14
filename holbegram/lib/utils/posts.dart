import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../screens/pages/methods/post_storage.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  Future<void> toggleSave(
    String postId,
    bool isSaved,
  ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final DocumentReference userReference =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

    if (isSaved) {
      await userReference.update({
        'saved': FieldValue.arrayRemove([postId]),
      });
    } else {
      await userReference.update({
        'saved': FieldValue.arrayUnion([postId]),
      });
    }

    if (!mounted) {
      return;
    }

    await Provider.of<UserProvider>(
      context,
      listen: false,
    ).refreshUser();

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(
      context,
    );

    final currentUser = userProvider.getUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error ${snapshot.error}',
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data!.docs;

        if (data.isEmpty) {
          return const Center(
            child: Text('No posts yet'),
          );
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final postData =
                data[index].data()
                    as Map<String, dynamic>;

            final String postId =
                postData['postId'] ?? data[index].id;

            final String publicId =
                postData['publicId'] ?? '';

            final String username =
                postData['username'] ??
                currentUser?.username ??
                '';

            final String caption =
                postData['caption'] ?? '';

            final String profileImage =
                postData['profImage'] ?? '';

            final String postUrl =
                postData['postUrl'] ?? '';

            final bool isSaved =
                currentUser?.saved.contains(postId) ??
                false;

            return Container(
              margin: const EdgeInsets.all(8),
              height: 540,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(25),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                Colors.grey.shade300,
                            image:
                                profileImage.isNotEmpty
                                    ? DecorationImage(
                                        image:
                                            NetworkImage(
                                          profileImage,
                                        ),
                                        fit:
                                            BoxFit.cover,
                                      )
                                    : null,
                          ),
                          child:
                              profileImage.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                    )
                                  : null,
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Text(
                          username,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          icon: const Icon(
                            Icons.more_horiz,
                          ),
                          onPressed: () async {
                            try {
                              await PostStorage()
                                  .deletePost(
                                postId,
                                publicId,
                              );

                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Post Deleted',
                                  ),
                                ),
                              );
                            } catch (error) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Text(
                      caption,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Center(
                    child: Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          25,
                        ),
                        color:
                            Colors.grey.shade200,
                        image: postUrl.isNotEmpty
                            ? DecorationImage(
                                image:
                                    NetworkImage(
                                  postUrl,
                                ),
                                fit:
                                    BoxFit.cover,
                              )
                            : null,
                      ),
                      child: postUrl.isEmpty
                          ? const Icon(
                              Icons.image,
                              size: 80,
                            )
                          : null,
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.comment_outlined,
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.send_outlined,
                          ),
                        ),

                        const Spacer(),

                        IconButton(
                          onPressed: () async {
                            await toggleSave(
                              postId,
                              isSaved,
                            );
                          },
                          icon: Icon(
                            isSaved
                                ? Icons.bookmark
                                : Icons
                                    .bookmark_border,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
