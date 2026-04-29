import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const TextFieldInput({
    super.key,
    required this.controller,
    this.isPassword = false,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      cursorColor: Color.fromARGB(218, 226, 37, 24),
      obscureText: isPassword,
      keyboardType: keyboardType,

      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),

        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }
}
