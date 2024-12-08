import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final List<String> supportedLanguages;
  const LanguageSelectionDialog({Key? key, required this.supportedLanguages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Выберите язык'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: supportedLanguages.map((lang) {
          return ListTile(
            title: Text(lang),
            onTap: () {
              Navigator.pop(context, lang);
            },
          );
        }).toList(),
      ),
    );
  }
}
