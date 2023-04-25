//import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '/src/shared/utils.dart';

class MycustomForm extends StatefulWidget {
  const MycustomForm({super.key});

  @override
  MycustomFormState createState() {
    return MycustomFormState();
  }
}

class MycustomFormState extends State<MycustomForm> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _obscureText2 = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _pass.dispose();
    _confirmPass.dispose();

    super.dispose();
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), password: _pass.text.trim());
    } on FirebaseAuthException catch (e) {
      developer.log(e.message.toString());
      Utils.showSnackBar(e.message);
    }
    // Navigator.popUntil(context, (route) => route);
    Navigator.of(context).pop();
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pop();
    }
  }

  void _toggle1() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Enter email'),
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !RegExp(r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                return 'Enter a correct email';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter Password',
                suffixIcon: IconButton(
                    onPressed: () {
                      _toggle1();
                    },
                    icon: _obscureText
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))),
            obscureText: _obscureText,
            controller: _pass,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Please use proper password';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Confirm password',
                suffixIcon: IconButton(
                    onPressed: () {
                      _toggle2();
                    },
                    icon: _obscureText2
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off))),
            obscureText: _obscureText2,
            controller: _confirmPass,
            validator: (value) {
              if (value == null || value.isEmpty || value != _pass.text) {
                return 'Confirm Password does not match';
              }
              return null;
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05),
            child: MaterialButton(
              minWidth: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              onPressed: () {
                //developer.log('password : ${_pass.text}');
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Information')));
                  signUp();
                }
              },
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: const Text(
                "Submit",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Already have an account? "),
              Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              )
            ],
          )
        ],
      ),
    );
  }
}

class Registration extends StatefulWidget {
  const Registration({super.key});

  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  State<StatefulWidget> createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.black,
          ),
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Material(
                      child: Text(
                        "Registration",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      child: Text(
                        "Create an account. It's free!",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: const [MycustomForm()],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
