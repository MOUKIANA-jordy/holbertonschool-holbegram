import 'package:flutter/material.dart';

class AddImage extends StatelessWidget {
  const AddImage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Add Image',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Billabong',
          ),
        ),
      ),
    );
  }
}
