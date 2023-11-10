import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  void _registrate() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: varEmail, password: varPassword)
        .then(
      (value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
    ).onError(
      (error, stackTrace) {
        print("Error ${error.toString()}");
      },
    );
  }

  _routeLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  String varEmail = '';
  String varPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: IconButton(
        icon: const Icon(
          Icons.keyboard_backspace,
          color: Color.fromARGB(255, 6, 82, 133),
        ),
        iconSize: 50,
        onPressed: _routeLogin,
      ),
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.blue,
            gradient: LinearGradient(
                colors: [(Colors.white), (Color.fromARGB(255, 148, 216, 255))],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
        Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 10),
              Image.asset(
                "lib/assets/logo.png",
                height: 200.0,
                width: 400.0,
              ),
              const SizedBox(height: 10),

              // Benvenuto! esegui la registrazione
              const Text(
                'Welcome!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Color.fromARGB(255, 6, 82, 133)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Registration:",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 6, 82, 133),
                ),
              ),
              const SizedBox(height: 40),

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
                  onPressed: _registrate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 10),
                  ),
                  child: const Text(
                    'Registrate',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ]),
          ),
        ),
      ]),
    );
  }
}
