import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'frame.dart';

/* Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'purple_filter',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const AuthAppPage(),
    );
  }
} */

class AuthAppPage extends StatefulWidget {
  const AuthAppPage({super.key});

  @override
  State<AuthAppPage> createState() => _AuthAppPageState();
}

class _AuthAppPageState extends State<AuthAppPage> {
  // Default placeholder text.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AuthPage'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextField(
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    labelText: "Password",
                  ),
                ),
                ElevatedButton(
                  child: const Text("submit"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                    // createUserWithEmailAndPassword(
                    // email: 'kinglaam00@gmail.com', password: '1234567abc');
                  },
                ),
              ]),
        ));
  }
}
