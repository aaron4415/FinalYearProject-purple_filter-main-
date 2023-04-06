import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';

final _formKeySignUp = GlobalKey<FormState>();
final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerUsername = TextEditingController();
_saveLogin() async {
  //實體化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //獲取 counter 為 null 則預設值設定為 0
  //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

  //寫入
  await prefs.setBool('logined', true);
}

_saveUserId(String uID) async {
  //實體化
  SharedPreferences prefs = await SharedPreferences.getInstance();

  //獲取 counter 為 null 則預設值設定為 0
  //_firstTimeToUse = (prefs.getBool('firstTime') ?? true);

  //寫入
  await prefs.setString('UID', uID);
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeySignUp,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            controller: _controllerUsername,
            onSaved: (email) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Username",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            controller: _controllerEmail,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              } else if (EmailValidator.validate(value) == false) {
                return "Please enter a valid email";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          TextFormField(
            textInputAction: TextInputAction.done,
            obscureText: true,
            controller: _controllerPassword,
            cursorColor: kPrimaryColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length <= 5) {
                return "Please enter at least 6 characters for your password";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Your password",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.lock),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm password is required';
                } else if (value.length <= 5) {
                  return "Please enter at least 6 characters for your password";
                } else if (value != _controllerPassword.text) {
                  return "Please enter same password";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "confirm password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('example.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  if (_formKeySignUp.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: ((context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }));
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _controllerEmail.text,
                        password: _controllerPassword.text,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        Navigator.of(context, rootNavigator: true).pop();
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: 'Error',
                          text: 'The password provided is too weak.',
                          loopAnimation: false,
                        );
                      } else if (e.code == 'email-already-in-use') {
                        Navigator.of(context, rootNavigator: true).pop();
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: 'Error',
                          text: 'The account already exists for that email.',
                          loopAnimation: false,
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) async {
                      if (user != null) {
                        print(user);
                        _saveLogin();
                        _saveUserId(user.uid);
                        const tempUrl =
                            "https://us-central1-fantahealth-1f00b.cloudfunctions.net/app/api/createUser";
                        final response =
                            await http.post(Uri.parse(tempUrl), body: {
                          'uid': user.uid,
                          'username': _controllerUsername.text,
                          'email': _controllerEmail.text
                        });
                        Navigator.of(context, rootNavigator: true);
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.success,
                          text: 'Account was successfully created and logined.',
                          onConfirmBtnTap: () {
                            FirebaseAuth.instance
                                .authStateChanges()
                                .listen((User? user) async {
                              if (user != null) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()),
                                );
                              }
                            });
                          },
                        );
                      }
                    });
                  }
                }
              } on SocketException catch (_) {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.warning,
                  text: "Please connect internet",
                );
              }
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
