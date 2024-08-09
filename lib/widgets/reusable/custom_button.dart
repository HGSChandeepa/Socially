import 'package:flutter/material.dart';
import 'package:socially/utils/app_constants/colors.dart';

class ReusableButton extends StatelessWidget {
  final String text;
  final double width;
  final VoidCallback onPressed;

  ReusableButton({
    required this.text,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradientColor1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: mainWhiteColor,
          ),
        ),
      ),
    );
  }
}
