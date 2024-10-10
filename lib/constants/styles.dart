import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  // Текстовые стили
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textColor,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
    color: AppColors.textColor,
  );

  static const TextStyle captionText = TextStyle(
    fontSize: 14,
    color: AppColors.textLightColor,
  );

  // Стиль кнопок
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: AppColors.primaryColor,
    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Стиль полей ввода
  static InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textLightColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
