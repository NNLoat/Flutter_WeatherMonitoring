//import 'package:flutter/widgets.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
// import '/src/home/screens/home.dart';
import '/src/shared/utils.dart';

class MycustomLoginForm extends StatefulWidget {
  const MycustomLoginForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return MycustomLoginFormState();
  }
}

class MycustomLoginFormState extends State<MycustomLoginForm> {
  final _loginformKey = GlobalKey<FormState>();

  bool _obscureText = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _toggle1() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _logIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      developer.log(e.message.toString());
      Utils.showSnackBar(e.message);
    }
    Navigator.of(context).pop();

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _loginformKey,
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter email'),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                  return 'Please provide login credentials';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _toggle1();
                    },
                    icon: _obscureText
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  )),
              obscureText: _obscureText,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide login credentials';
                } else if (value.length < 6) {
                  return 'Password must be longer than 6 characters';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: MaterialButton(
                minWidth: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                color: Colors.indigoAccent[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                onPressed: () {
                  developer.log("Log in pressed");
                  if (_loginformKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logging in')));
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => Home()));
                    _logIn();
                    // Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ));
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Welcome Back! Log in to continue the services",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: const [MycustomLoginForm()],
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: const LoginWidget());
  }
}
