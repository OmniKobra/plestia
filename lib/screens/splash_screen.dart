// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/loading.dart';
import '../widgets/error.dart';
import '../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;
  late Future<void> _signIn;
  Future<void> signIn() {
    return auth.signInAnonymously().then((value) =>
        Navigator.pushReplacementNamed(context, RouteGenerator.homeScreen));
  }

  @override
  void initState() {
    super.initState();
    _signIn = signIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
                child: FutureBuilder(
                    future: _signIn,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingWidget();
                      }
                      if (snapshot.hasError) {
                        return MyErrorWidget(() {
                          setState(() {
                            _signIn = signIn();
                          });
                        });
                      }
                      return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: []);
                    }))));
  }
}
