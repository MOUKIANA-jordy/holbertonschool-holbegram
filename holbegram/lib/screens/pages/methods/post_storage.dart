import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    try {
      // Upload image to Cloudinary using StorageMethods
      StorageMethods storageMethods = StorageMethods();
      String postUrl = await storageMethods.uploadImageToStorage(
        true, // isPost
        'posts', // folder name
        image,
      );

      // Generate unique post ID
      String postId = const Uuid().v1();

      // Create post document in Firestore
      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'postUrl': postUrl,
        'postId': postId,
        'datePublished': DateTime.now(),
        'likes': [],
      });

      return 'Ok';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    try {
      // Delete post from Firestore
      await _firestore.collection('posts').doc(postId).delete();

      // Delete image from Cloudinary
      final String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/your-cloud-name/image/destroy";
      final String cloudinaryApiKey = "your-api-key";
      final String cloudinaryApiSecret = "your-api-secret";

      var uri = Uri.parse(cloudinaryUrl);
      var request = http.MultipartRequest('POST', uri);
      request.fields['public_id'] = publicId;
      request.fields['api_key'] = cloudinaryApiKey;
      request.fields['api_secret'] = cloudinaryApiSecret;

      await request.send();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
}
