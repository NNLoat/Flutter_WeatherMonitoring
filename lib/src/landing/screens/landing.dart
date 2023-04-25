import 'dart:ui';

import 'package:flutter/material.dart';
import '/src/registration/screens/registration.dart';
import '/src/login/screens/login.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }

    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: () => {onPressed()},
      color: Colors.indigoAccent[400],
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(40)),
      child: const Text(
        "Login",
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class RegistrationButton extends StatelessWidget {
  const RegistrationButton({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Registration()));
    }

    return MaterialButton(
      minWidth: double.infinity,
      height: 60,
      onPressed: () => {onPressed()},
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: const Text(
        "Registration",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return _LandingPageState();
  }
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Center(
            child: Material(
              child: Text(
                "Hello, There!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Material(
            child: Text(
              "Please login or sign up to continue",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/regist.webp'))),
          ),
          const LoginButton(),
          const RegistrationButton()
        ],
      ),
    ));
  }
}
