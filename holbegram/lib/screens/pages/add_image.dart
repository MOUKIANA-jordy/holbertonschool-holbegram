import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../home.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  final TextEditingController captionController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _image;
  bool _isLoading = false;

  Future<void> selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes =
          await pickedFile.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes =
          await pickedFile.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> uploadPost() async {
    final userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    final user = userProvider.getUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
        ),
      );
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }

    if (captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a caption'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String result = await PostStorage().uploadPost(
      captionController.text.trim(),
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (result == 'Ok') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post uploaded successfully'),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
        ),
      );
    }
  }

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(
            fontFamily: 'Billabong',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              GestureDetector(
                onTap: selectImageFromGallery,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20),
                          child: Image.memory(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Add a photo',
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: selectImageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    label: const Text(
                      'Camera',
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  ElevatedButton.icon(
                    onPressed: selectImageFromGallery,
                    icon: const Icon(
                      Icons.photo_library,
                    ),
                    label: const Text(
                      'Gallery',
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              TextField(
                controller: captionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : uploadPost,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(
                      const Color.fromARGB(
                        218,
                        226,
                        37,
                        24,
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
