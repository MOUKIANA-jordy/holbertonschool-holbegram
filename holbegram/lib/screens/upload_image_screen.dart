import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();

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
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Add a profile picture',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                const Text(
                  'Add a profile picture so your friends know it is you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _image != null
                      ? MemoryImage(_image!)
                      : const NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
                        ) as ImageProvider,
                ),

                const SizedBox(
                  height: 30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: selectImageFromCamera,
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                    ),

                    const SizedBox(
                      width: 40,
                    ),

                    IconButton(
                      onPressed: selectImageFromGallery,
                      icon: const Icon(
                        Icons.photo_library,
                        size: 40,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(
                          218,
                          226,
                          37,
                          24,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
