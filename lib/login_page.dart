import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/home.dart';
import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/provider/globalProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  String _userName = "";
  String _userPass = "";

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _userName,
        password: _userPass,
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Save the token in the global provider
        Provider.of<GlobalProvider>(context, listen: false).saveToken(user.uid);
        // Save the current user in the global provider
        Provider.of<GlobalProvider>(context, listen: false).setCurrentUser(UserModel(email: user.email!, username:'uncle'));

        // Authentication successful, navigate to home page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      // Handle authentication errors
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to login. Please try again.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              const Text(
                "Тавтай морил",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                child: Column(
                  children: [
                    SizedBox(
                      width: 500,
                      child: TextFormField(
                        onChanged: (value) {
                          _userName = value;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Нэрээ оруулна уу",
                          label: Text("Нэр:"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Хоосон байж болохгүй";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: TextFormField(
                        onChanged: (value) {
                          _userPass = value;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Нууц үг оруул",
                          label: Text("Нууц үг"),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Хоосон байж болохгүй";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Material(
                      borderRadius: BorderRadius.circular(32.0),
                      color: Colors.deepPurple,
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => _signInWithEmailAndPassword(context),
                        child: AnimatedContainer(
                          color: Colors.transparent,
                          duration: const Duration(seconds: 1),
                          height: 50,
                          width: 150,
                          alignment: Alignment.center,
                          child: const Text(
                            "Нэвтрэх",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
