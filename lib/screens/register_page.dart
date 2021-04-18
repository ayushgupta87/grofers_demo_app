import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ayush_gupta/models/network_info.dart';
import 'package:ayush_gupta/reuseable_widgets/reuseable.dart';
import 'package:ayush_gupta/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SingUpPage extends StatefulWidget {
  @override
  _SingUpPageState createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  bool _saving = false;

  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7cdc41),
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: GestureDetector(
            onTap: () {},
            child: Text(''),
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Create",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Account",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    ".",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: MediaQuery.of(context).size.height * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            KbuildTextBox(name, '* Enter your name', Icon(Icons.person), 1,
                TextInputType.name, false),
            KbuildTextBox(username, '* Enter username', Icon(Icons.person), 1,
                TextInputType.name, false),
            KbuildTextBox(password, '* Password', Icon(Icons.person), 1,
                TextInputType.visiblePassword, true),
            KbuildTextBox(confirmPassword, '* Confirm Password',
                Icon(Icons.person), 1, TextInputType.visiblePassword, true),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Center(
                child: kbuildSignupLogin(context, 'Sign Up', () async {

                  setState(() {
                    _saving=true;
                  });

                  var registerUser = await http.post(registerURI,
                  body: {
                    "name" : name.text,
                    "username" : username.text,
                    "password" : password.text,
                    "confirm_password" : confirmPassword.text
                  });

                  var content = await jsonDecode(registerUser.body)['message'];

                  if (registerUser.statusCode == 200){
                    setState(() {
                      _saving=false;
                    });
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                      return LoginPage();
                    }), (route) => false);
                    Fluttertoast.showToast(
                        msg: content.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 6,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    setState(() {
                      _saving=false;
                    });
                    Fluttertoast.showToast(
                        msg: content.toString(),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 6,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }


                })),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          ]),
        ),
      ),
    );
  }
}