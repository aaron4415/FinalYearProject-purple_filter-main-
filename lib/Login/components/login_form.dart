import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/Signup/signup_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '/splashScreen.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  // Default placeholder text.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

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

  Future<UserCredential> signInWithGoogle() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controllerEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            validator: (String? controllerEmail) {
              if (controllerEmail == null || controllerEmail.isEmpty) {
                return 'Email is required';
              } else if (EmailValidator.validate(controllerEmail) == false) {
                return "Please enter a valid email";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              controller: _controllerPassword,
              cursorColor: kPrimaryColor,
              validator: (String? controllerPassword) {
                if (controllerPassword == null || controllerPassword.isEmpty) {
                  return 'password is required';
                } else if (controllerPassword.length <= 5) {
                  return "Please enter at least 6 characters for your password";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup('example.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    if (_formKey.currentState!.validate()) {
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
                            .signInWithEmailAndPassword(
                                email: _controllerEmail.text,
                                password: _controllerPassword.text);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          Navigator.of(context, rootNavigator: true).pop();
                          print("not found");
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Error when trying to login',
                            text: "Your email or passward is wrong.",
                            loopAnimation: false,
                          );
                        } else if (e.code == 'wrong-password') {
                          Navigator.of(context, rootNavigator: true).pop();
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Error when trying to login',
                            text: "Your email or passward is wrong.",
                            loopAnimation: false,
                          );
                        }
                      }

                      FirebaseAuth.instance
                          .authStateChanges()
                          .listen((User? user) async {
                        if (user != null) {
                          _saveLogin();
                          _saveUserId(user.uid);
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SplashScreenPage()),
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
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
          const SizedBox(height: defaultPadding),
          OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () {
                signInWithGoogle();

                FirebaseAuth.instance
                    .authStateChanges()
                    .listen((User? user) async {
                  if (user != null) {
                    _saveLogin();
                    _saveUserId(user.uid);
                    const tempUrl =
                        "https://us-central1-fantahealth-1f00b.cloudfunctions.net/app/api/createUser";
                    final response = await http.post(Uri.parse(tempUrl), body: {
                      'uid': user.uid,
                      'username': user.displayName,
                      'email': user.email
                    });

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SplashScreenPage()),
                    );
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset("assets/icons/google-plus.svg",
                        height: height / 17,
                        width: width / 17,
                        fit: BoxFit.scaleDown),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
