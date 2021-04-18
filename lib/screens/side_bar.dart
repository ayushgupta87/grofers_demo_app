import 'package:ayush_gupta/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Side_Bar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child : SafeArea(
        child: ListTile(
          title: Text('Logout'),
          trailing: Icon(Icons.cancel_outlined),
          onTap: () async {
            SharedPreferences sharedpreference =
            await SharedPreferences.getInstance();
            await sharedpreference.remove('access_token');
            await sharedpreference.remove('refresh_token');
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                ModalRoute.withName("/LoginPage"));
          },
        ),
      ),
    );
  }
}