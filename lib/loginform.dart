// ignore_for_file: must_be_immutable, avoid_print, prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable

import 'package:admin_app/constants.dart';
import 'package:admin_app/main.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'widgets/textfield.dart';

TextEditingController nameController = TextEditingController();
TextEditingController passController = TextEditingController();

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    devH = MediaQuery.of(context).size.height;
    devW = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
          ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: devH * 0.1,
                ),
                SizedBox(
                  height: devH * 0.2,
                  width: devW * 0.5,
                  child: Image.asset('assets/logo.png'),
                ),
                Text('K-AIO Admin', style: kSubHeading),
                Padding(
                  padding: EdgeInsets.only(
                      top: devH * 0.05, left: devW * 0.05, right: devW * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Welcome Back!',
                          style: kHeading,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: devW * 0.03),
                        child: Text(
                          'Login Id',
                          style: kSubHeading,
                        ),
                      ),
                      TextInput(hintText: 'User Name', controller: nameController),
                      Padding(
                        padding: EdgeInsets.only(left: devW * 0.03),
                        child: Text(
                          'Password',
                          style: kSubHeading,
                        ),
                      ),
                      ObscureTextInput(hintText: 'Password', controller: passController),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Theme.of(context).primaryColor)),
                            onPressed: () {
                              if (nameController.text == 'admin' &&
                                  passController.text == 'admin123') {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (_) => MainPage()));
                              } else {
                                print('Wrong Password');
                                Alert(
                                  context: context,
                                  title: 'Wrong Password',
                                  desc: 'You\'ve entered wrong credentials.',
                                ).show();
                              }
                            },
                            child: Text('Log In')),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
