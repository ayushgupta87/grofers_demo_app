import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ayush_gupta/models/network_info.dart';
import 'package:ayush_gupta/reuseable_widgets/reuseable.dart';
import 'package:ayush_gupta/screens/products_page.dart';
import 'package:ayush_gupta/screens/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool buttonClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: GestureDetector(
            onTap: () {},
            child: Text(''),
          ),
        ),
      ),
      backgroundColor: Color(0xff7cdc41),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Text(
                "Hello !",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "There",
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
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            KbuildTextBox(username, 'Enter username', Icon(Icons.person), 1,
                TextInputType.name, false),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            KbuildTextBox(password, 'Enter password', Icon(Icons.vpn_key), 1,
                TextInputType.visiblePassword, true),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: buttonClicked == false
                        ? () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgetUsername();
                            }));
                          }
                        : null,
                    child: Text('Forget Username ?')),
                TextButton(
                    onPressed: buttonClicked == false
                        ? () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ForgetPassword();
                            }));
                          }
                        : null,
                    child: Text('Forget Password ?')),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
                child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.black),
                onPressed: buttonClicked == false
                    ? () async {
                        final SharedPreferences sharedPreference =
                            await SharedPreferences.getInstance();

                        if (username.text == '') {
                          kshowDialogue('Alert', 'Enter username to continue')
                              .showAlertDialoge(context);
                        } else if (password.text == '') {
                          kshowDialogue('Alert', 'Enter password to continue')
                              .showAlertDialoge(context);
                        } else {
                          setState(() {
                            buttonClicked = true;
                          });
                          try {
                            var sendLoginRequest = await http
                                .post(loginURI, body: {
                              "username": username.text,
                              "password": password.text
                            }).timeout(Duration(seconds: 20));

                            if (sendLoginRequest.statusCode != 200) {
                              String errorContent =
                              jsonDecode(sendLoginRequest.body)['message'];
                              kshowDialogue('Error', errorContent)
                                  .showAlertDialoge(context);
                            }

                            if (sendLoginRequest.statusCode == 200) {
                              String accessToken = await jsonDecode(
                                  sendLoginRequest.body)['access_token'];
                              String refreshToken = await jsonDecode(
                                  sendLoginRequest.body)['refresh_token'];

                              sharedPreference.setString(
                                  'access_token',
                                  jsonDecode(
                                      sendLoginRequest.body)['access_token']);
                              sharedPreference.setString(
                                  'refresh_token',
                                  jsonDecode(
                                      sendLoginRequest.body)['refresh_token']);

                              var user = await http.get(currentUserURI,
                                  headers: {
                                    HttpHeaders.authorizationHeader:
                                    'Bearer $accessToken'
                                  }).timeout(Duration(seconds: 10));

                              var userIs =
                              await jsonDecode(user.body)['user'];

                              if (user.statusCode == 200) {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                      return ProductsPage();
                                    }), (route) => false);
                              }
                            }

                            setState(() {
                              buttonClicked = false;
                            });
                          } on TimeoutException catch (e) {
                            print('Socket Exception $e');
                            kshowDialogue('Error',
                                'Connectivity Error, Request timeout')
                                .showAlertDialoge(context);
                            setState(() {
                              buttonClicked = false;
                            });
                          } on SocketException catch (e) {
                            print('Socket Exception $e');
                            Fluttertoast.showToast(
                                msg: "Connectivity Error",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 6,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 24.0);
                            setState(() {
                              buttonClicked = false;
                            });
                          }
                        }
                      }
                    : null,
                child: buttonClicked == false
                    ? Text(
                        'Login',
                        style: TextStyle(
                            color: Color(0xff7cdc41),
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025),
                      )
                    : CupertinoActivityIndicator(),
              ),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('New to Grofers? '),
                TextButton(
                  onPressed: buttonClicked == false ? () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SingUpPage();
                    }));
                  } : null,
                  child: Text('Register Now !'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ForgetUsername extends StatefulWidget {
  @override
  _ForgetUsernameState createState() => _ForgetUsernameState();
}

class _ForgetUsernameState extends State<ForgetUsername> {
  TextEditingController sourcePassword = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7cdc41),
      appBar: AppBar(
        title: Text('Recover Username'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                KbuildTextBox(
                    emailAddress,
                    'Enter registered email address',
                    Icon(Icons.alternate_email),
                    1,
                    TextInputType.emailAddress,
                    false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                kbuildSignupLogin(context, 'Recover', () async {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController sourcePassword = TextEditingController();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController username = TextEditingController();
  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7cdc41),
      appBar: AppBar(
        title: Text('Recover Password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                KbuildTextBox(username, 'Enter username', Icon(Icons.person), 1,
                    TextInputType.name, false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                KbuildTextBox(
                    emailAddress,
                    'Enter registered email address',
                    Icon(Icons.alternate_email),
                    1,
                    TextInputType.emailAddress,
                    false),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                kbuildSignupLogin(context, 'Recover', () async {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
