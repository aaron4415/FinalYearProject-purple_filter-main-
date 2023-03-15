import 'package:flutter/material.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:http/http.dart' as http;

final _formKeySignUp = GlobalKey<FormState>();
final TextEditingController _controllerEmail = TextEditingController();
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerUsername = TextEditingController();

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
              }
              return null;
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
              }
              return null;
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
                }
                return null;
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
              if (_formKeySignUp.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      title: 'Error',
                      text: 'The password provided is too weak.',
                      loopAnimation: false,
                    );
                  } else if (e.code == 'email-already-in-use') {
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
              }
              FirebaseAuth.instance
                  .authStateChanges()
                  .listen((User? user) async {
                if (user != null) {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: 'Account was successfully created.',
                    autoCloseDuration: const Duration(seconds: 2),
                  );
                  const tempUrl =
                      "https://us-central1-airy-phalanx-323908.cloudfunctions.net/app/api/createUser";
                  final response = await http.post(Uri.parse(tempUrl), body: {
                    'uid': user.uid,
                    'username': _controllerUsername.text,
                    'email': _controllerEmail.text
                  });
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');
                }
              });
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
