import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:infominds_app/pages/home_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Client client = http.Client();
  late AnimationController controller;

//_____________________________________________ FUNCTIONS _______________________________________________________________________________________________________________________________________________________________________________________

  void _route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _logger() async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: varEmail, password: varPassword)
        .then((value) {
      _route();
    });
  }

  void _routeRegistration() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const RegistrationPage()));
  }

//_____________________________________________ LOGIN_PAGE_DESIGN _______________________________________________________________________________________________________________________________________________________________________________

  var response;
  String varEmail = "";
  String varPassword = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            gradient: LinearGradient(colors: [
              (Color.fromARGB(255, 255, 255, 255)),
              (Color.fromARGB(255, 148, 216, 255))
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset(
                "lib/assets/logo.png",
                height: 150.0,
                width: 250.0,
              ),
              const SizedBox(height: 30),

              // Bentornato!
              const Text(
                'Welcome!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color.fromARGB(255, 19, 76, 97)),
              ),

              const SizedBox(height: 30),

              // email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                      onChanged: (value) {
                        setState(() => varEmail = value);
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                      onChanged: (value) {
                        setState(() => varPassword = value);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // sign in button
              Center(
                child: ElevatedButton(
                  onPressed: _logger,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 181, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // not a member?
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Not a member?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                    onPressed: _routeRegistration,
                    child: const Text(
                      'Register now!',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ])
            ]),
          ),
        ),
      ]),
    );
  }
}
