import 'package:eshop/auth/sign_up.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/custom_widgets.dart';
import 'package:eshop/product_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductScreen()),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: $e')),
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
                  height: height * 0.2,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                          onChanged: (val) {
                            setState(() => email = val);
                          },
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
                          onChanged: (val) {
                            setState(() => password = val);
                          },
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
                            _login, width * 0.65, height * 0.06, 'Login')),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here?',
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
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Signup',
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
