import 'package:chat_application/contans/app_png_logo.dart';
import 'package:chat_application/modal/user_data_modal.dart';
import 'package:chat_application/screens/home_view.dart';
import 'package:chat_application/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
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
                      }
                    }
                  }
                },
                child: const Text("Login"),
              ),
            ),
            hSpace(mHeight: 50),
            Row(
              children: [
                const Expanded(flex: 2, child: Divider()),
                wSpace(),
                const Expanded(flex: 1, child: Text("Or With")),
                const Expanded(flex: 2, child: Divider()),
              ],
            ),
            hSpace(mHeight: 50),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
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
                      hintText: "User First Name",
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
                      hintText: "User Last Name",
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
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
                    var mUserName = firstNameController.text.toString();
                    var mLastName = lastNameController.text.toString();
                    var mEmail = emailController.text.toString();
                    var mPhoneNo = phoneNoController.text.toString();
                    var mPassword = passwordController.text.toString();

                    var auth = FirebaseAuth.instance;

                    try {
                      UserCredential userCredential =
                          await auth.createUserWithEmailAndPassword(
                              email: mEmail, password: mPassword);

                      var userDataModal = UserDataModal(
                        uFirstName: mUserName,
                        uLastName: mLastName,
                        uEmail: mEmail,
                        uPhoneNumber: mPhoneNo,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeView(),
                        ),
                      );
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
