import 'package:flutter/material.dart';

Widget KbuildTextBox(TextEditingController inputController, String labelText,
    Icon icon, int lines, TextInputType textInputType, bool isHidden) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
    child: TextField(
      maxLines: lines,
      controller: inputController,
      keyboardType: textInputType,
      obscureText: isHidden,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        icon: icon,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15)
        ),
      ),
    ),
  );
}

Widget kbuildSignupLogin(BuildContext context, String title, function) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.6,
    height: MediaQuery.of(context).size.height * 0.06,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black
      ),
      onPressed: function,
      child: Text(
        title,
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.025),
      ),
    ),
  );
}