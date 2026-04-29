import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_picker.dart' as utils;
import '../methods/auth_methods.dart';

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
  bool _isLoading = false;

  void selectImageFromGallery() async {
    Uint8List? image = await utils.pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void selectImageFromCamera() async {
    Uint8List? image = await utils.pickImage(ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  Future<void> signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethode().signUpUser(
      email: widget.email,
      username: widget.username,
      password: widget.password,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the selected image or default user icon
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: _image != null ? MemoryImage(_image!) : null,
                child: _image == null
                    ? Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.grey[700],
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              // Display username
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Camera icon button
                  Column(
                    children: [
                      IconButton(
                        onPressed: selectImageFromCamera,
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 50,
                          color: Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
                  // Gallery icon button
                  Column(
                    children: [
                      IconButton(
                        onPressed: selectImageFromGallery,
                        icon: const Icon(
                          Icons.photo_library,
                          size: 50,
                          color: Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Next button
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(218, 226, 37, 24),
                  ),
                  onPressed: _isLoading ? null : signUpUser,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
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
