import 'package:flutter/material.dart';
import 'package:oqyul/constants/styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;

  CustomTextField({
    required this.label,
    this.obscureText = false,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: AppStyles.inputDecoration(label),
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
