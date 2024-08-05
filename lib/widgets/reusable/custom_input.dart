import 'package:flutter/material.dart';

class ReusableInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final String? Function(String?) validator;

  ReusableInput({
    required this.controller,
    required this.labelText,
    required this.icon,
    required this.obscureText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}


