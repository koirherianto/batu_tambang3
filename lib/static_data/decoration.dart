import 'package:flutter/material.dart';

class Decorations {
  static const Color greenColor = Color(0xFF00AF19);
  static const Color blueColor = Color(0xFF0000FF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color yellowColor = Color(0xFFFFFF00);
  static const Color orangeColor = Color(0xFFFFA500);
  static const Color titikHijau = Color(0xFF00AF19);

  static InputDecoration inputDecoration({required String title}) {
    return InputDecoration(
      labelText: title,
      labelStyle: TextStyle(
          fontFamily: 'Trueno',
          fontSize: 12.0,
          color: Colors.grey.withOpacity(0.5)),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: greenColor),
      ),
    );
  }

  static SizedBox submitButton({
    required String title,
    Color color = Decorations.greenColor,
    Color textColor = Colors.white,
  }) {
    return SizedBox(
      height: 50.0,
      child: Material(
        borderRadius: BorderRadius.circular(25.0),
        shadowColor: Colors.greenAccent,
        color: color,
        elevation: 7.0,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Trueno',
            ),
          ),
        ),
      ),
    );
  }
}
