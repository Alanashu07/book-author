import 'dart:convert';
import 'package:book_author/Services/preferences.dart';
import 'package:book_author/Widgets/Buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../Constants/alerts.dart';
import '../../Style/app_style.dart';
import '../../Widgets/TextFields/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  bool securePassword = true;


  //Login Function for authentication
  Future<void> login() async {
    try{
      var url = Uri.parse("https://assessment.eltglobal.in/api/auth/login");
      var response = await http.post(url, body: {
        "username": userNameController.text,
        "password": passwordController.text
      });
        final data = jsonDecode(response.body);
        await Preferences.saveJWT(data['result']['access_token']);
        context.go('/home');
    } catch(e) {
      showSnackBar(content: 'Error: Wrong Password $e', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mq.height * 0.2,
            ),
            Image.asset('images/logo.png'),
            SizedBox(
              height: mq.height * 0.1,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(
                                color: userNameFocus.hasFocus
                                    ? AppStyle.mainColor
                                    : Colors.grey[700],
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            focusNode: userNameFocus,
                            controller: userNameController,
                            type: 'Username',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                                color: passwordFocus.hasFocus
                                    ? AppStyle.mainColor
                                    : Colors.grey[700],
                                fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CustomTextField(
                            focusNode: passwordFocus,
                            controller: passwordController,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  securePassword = !securePassword;
                                });
                              },
                              child: securePassword
                                  ? Image.asset('images/eye-off.png')
                                  : const Icon(Icons.visibility),
                            ),
                            hideText: securePassword,
                            type: 'Password',
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: CustomButton(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (passwordController.text.length >= 4) {
                      await login();
                    } else if (passwordController.text.length < 4) {
                      showAlert(
                          context: context,
                          title: 'Weak Password',
                          content:
                          'Password should be at least 4 characters long!');
                    } else {
                      showAlert(
                          context: context,
                          title: 'Password does not match',
                          content:
                          'Password and Confirm Password must be same!');
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: mq.height * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}
