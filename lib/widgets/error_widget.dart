import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;

  ErrorDisplayWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ошибка: $message',
        style: TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
