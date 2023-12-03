import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandluppen_web/ui/auth/login_screen.dart';
import 'package:tandluppen_web/ui/home/home_screen.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _auth.authStateChanges().first,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else if (snapshot.hasError) {
            return const Icon(Icons.error_outline);
          } else {
            return const LoginScreen();
          }
        });
  }
}
