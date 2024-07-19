import 'package:eshop/auth/sign_in.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/custom_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed up!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: sWhite,
        toolbarHeight: height * 0.01,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
        ),
        child: Container(
          height: height,
          decoration: BoxDecoration(color: sWhite),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  'e-Shop',
                  style: TextStyle(
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.bold,
                      color: cBlue),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * 0.02))),
                        height: height * 0.041,
                        child: TextFormField(
                          controller: _nameController,
                          cursorHeight: height * 0.02,
                          cursorColor: const Color(0xFF303F60),
                          decoration: InputDecoration(
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              hintText: 'Name',
                              border: InputBorder.none),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter Your Name' : null,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        height: height * 0.041,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * 0.02))),
                        child: TextFormField(
                          controller: _emailController,
                          cursorHeight: height * 0.02,
                          cursorColor: const Color(0xFF303F60),
                          decoration: InputDecoration(
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              hintText: 'Email',
                              border: InputBorder.none),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Container(
                        height: height * 0.041,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * 0.02))),
                        child: TextFormField(
                          controller: _passwordController,
                          cursorHeight: height * 0.02,
                          cursorColor: const Color(0xFF303F60),
                          decoration: InputDecoration(
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.01),
                              hintText: 'Password',
                              border: InputBorder.none),
                          validator: (val) => val!.length < 6
                              ? 'Enter a password 6+ chars long'
                              : null,
                          obscureText: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : customButton(
                            _signUp, width * 0.65, height * 0.06, 'Signup')),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: height * 0.02),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: cBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.02),
                      ),
                    )
                  ],
                ),
                SizedBox(height: height * 0.11),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
