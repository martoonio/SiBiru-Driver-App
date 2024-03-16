// ignore_for_file: body_might_complete_normally_catch_error

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sibiru_driver/pages/home_page.dart';
import '../methods/common_methods.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CommonMethods cMethods = CommonMethods();

  bool _passwordVisible = false;

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailTextEditingController.text.contains("@")) {
      cMethods.displaySnackBar("please write valid email.", context);
    } else if (passwordTextEditingController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "your password must be atleast 6 or more characters.", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("shuttleData")
          .child(userFirebase.uid);

      Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => const HomePage()));
    } else {
      cMethods.displaySnackBar("Error Occured, can't Sign In.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
            backgroundColor: kPrimaryColor,
            elevation: 0,
            title: Text(
              "RideWave",
              style: GoogleFonts.roboto(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),

              Image.asset(
                "images/cover.png",
                width: 220,
              ),

              const SizedBox(
                height: 30,
              ),

              Text(
                "As a Rider",
                style: TextStyle(
                  fontSize: 26,
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //text fields + button
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  key: _formKey,
                  children: [
                    TextFormField(
                      controller: emailTextEditingController,
                      style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50)
                      ],
                      decoration: InputDecoration(
                      hintText: "Enter Your Email",
                      hintStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: kSecondaryColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                        color: Colors.white),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    TextFormField(
                      obscureText: !_passwordVisible,
                      controller: passwordTextEditingController,
                      style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                      inputFormatters: [
                                  LengthLimitingTextInputFormatter(50)
                                ],
                                decoration: InputDecoration(
                                  hintText: "Enter Your Password",
                                  hintStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
                                  filled: true,
                                  fillColor: kSecondaryColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                        color: Colors.white),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.key,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                                ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ForgotPassword()));
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                )),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF054C67),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                        color: Colors.white,
                                        width: 3),
                                  ),
                                  minimumSize: Size(200, 50),
                                ),
                      child: Text("Login",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )
                      ),
                    ),
                  ],
                ),
              ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Doesn't have an account? ",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             const SignUpScreen()));
                                  },
                                  child: Text(
                                    "Register!",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  )),
                            ],
                          ),
            ],
          ),
        ),
      ),
    );
  }
}
