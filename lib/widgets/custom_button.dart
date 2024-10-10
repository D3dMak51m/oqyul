import 'package:flutter/material.dart';
import 'package:oqyul/constants/styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style ?? AppStyles.primaryButton,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
