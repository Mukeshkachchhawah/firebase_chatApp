import 'package:chat_application/firebase_provider/firebase_provider.dart';
import 'package:chat_application/screens/home/home_view.dart';
import 'package:chat_application/utils/app_png_logo.dart';
import 'package:chat_application/utils/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var loginFormKey = GlobalKey<FormState>();
  var registerFormKey = GlobalKey<FormState>();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPassController = TextEditingController();
  var phoneNoController = TextEditingController();

  bool isCheckPassword = false; // only password
  bool isConformPassword = false; // conform password check

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              hSpace(mHeight: 100),
              Image.asset(
                AppPngLogo.chatLogo,
                scale: 4,
              ),
              hSpace(mHeight: 30),
              const TabBar(
                tabs: [
                  Tab(text: 'Login User'),
                  Tab(text: 'Register User'),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: [
                    userLogin(context),
                    userRegister(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userLogin(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            hSpace(),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: textStyleFonts14(context),
                labelText: "Email",
                labelStyle: textStyleFonts14(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            hSpace(),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: const TextStyle(fontSize: 14),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(isCheckPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isCheckPassword = !isCheckPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: !isCheckPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            hSpace(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(onTap: () {}, child: const Text("Forgot Password")),
              ],
            ),
            hSpace(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (loginFormKey.currentState!.validate()) {
                    String mEmail = emailController.text.toString();
                    String mPassword = passwordController.text.toString();
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: mEmail, password: mPassword);
                      var sp = await SharedPreferences.getInstance();
                      sp.setBool(SplashViewState.LOGIN_KEY, true);

                      // Show success snack bar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("User logged in successfully.")),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == "user-not-found") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No user found for that email.")),
                        );
                      } else if (e.code == "wrong-password") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Wrong password provided.")),
                        );
                      } else {
                        // Show generic error snack bar for other exceptions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login failed: ${e.message}")),
                        );
                      }
                    } catch (e) {
                      // show generic error snack bar for non Firebase Exception
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("An error occurred : ${e.toString()}")));
                    }
                  }
                },
                child: const Text("Login"),
              ),
            ),
            hSpace(mHeight: 50),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  User? user = await FirebaseProvider.signInWithGoogle();
                  if (user != null) {
                    // Navigate to Home Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeView(),
                      ),
                    );
                  }
                },
                label: const Text("Login with Google"),
                icon: Image.asset(
                  AppPngLogo.google,
                  scale: 19,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userRegister(BuildContext context) {
    return Form(
      key: registerFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            hSpace(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      hintText: "First Name",
                      hintStyle: textStyleFonts14(context),
                      labelText: "First Name",
                      labelStyle: textStyleFonts14(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                ),
                wSpace(),
                Expanded(
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      hintStyle: textStyleFonts14(context),
                      labelText: "Last Name",
                      labelStyle: textStyleFonts14(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            hSpace(),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: textStyleFonts14(context),
                labelText: "Email",
                labelStyle: textStyleFonts14(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            hSpace(),
            TextFormField(
              controller: phoneNoController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: textStyleFonts14(context),
                labelText: "Phone Number",
                labelStyle: textStyleFonts14(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            hSpace(),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: textStyleFonts14(context),
                labelText: "Password",
                labelStyle: textStyleFonts14(context),
                suffixIcon: IconButton(
                  icon: Icon(isCheckPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isCheckPassword = !isCheckPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: !isCheckPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            hSpace(),
            TextFormField(
              controller: confirmPassController,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                hintStyle: const TextStyle(fontSize: 14),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isConformPassword = !isConformPassword;
                    });
                  },
                  icon: Icon(isConformPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: !isConformPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            hSpace(),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (registerFormKey.currentState!.validate()) {
                    try {
                      FirebaseProvider.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          firstNameValue: firstNameController.text.trim(),
                          lastNameValue: lastNameController.text.trim(),
                          phoneValue: phoneNoController.text.trim());

                      registerFormKey.currentState!.reset();

                      firstNameController.clear();
                      lastNameController.clear();
                      emailController.clear();
                      phoneNoController.clear();
                      passwordController.clear();
                      confirmPassController.clear();
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('The password provided is too weak.')),
                        );
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'The account already exists for that email.')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('An error occurred. Please try again.')),
                      );
                    }
                  }
                },
                child: const Text("Register"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
