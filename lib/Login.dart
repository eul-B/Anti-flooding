import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/api/notification.dart';
import 'package:flutter_application_2/model/user.dart';
import 'package:flutter_application_2/signup.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var formKey = GlobalKey<FormState>();
  var idController = TextEditingController();
  var passwordController = TextEditingController();
  userLogin() async {
    try {
      var res = await http.post(Uri.parse(API.login), body: {
        'user_id': idController.text.trim(),
        'user_password': passwordController.text.trim()
      });
      if (res.statusCode == 200) {
        var resLogin = jsonDecode(res.body);
        if (resLogin['success'] == true) {
          Get.to(HomePage());
          Fluttertoast.showToast(msg: 'Login successfully');
          User userInfo = User.fromJson(resLogin['userData']);
          setState(() {
            idController.clear();
            passwordController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: 'Please check your id and password');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      id(),
                      password(),
                    ],
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  //login 구현 버전 =
                  // onTap: () {
                  //   if (formKey.currentState!.validate()) {
                  //     userLogin();
                  //   }
                  // },
                  // child: Container(
                  //   child: Padding(
                  //     padding: EdgeInsets.fromLTRB(70, 20, 20, 0),
                  //     child: Container(
                  //       padding: EdgeInsets.all(15),
                  //       decoration: BoxDecoration(
                  //         color: Colors.lightBlueAccent[200],
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               'Login  ',
                  //               style: TextStyle(
                  //                   fontFamily: 'NanumSquareNeo',
                  //                   color: Colors.white),
                  //             ),
                  //             Icon(
                  //               Icons.login,
                  //               color: Colors.white,
                  //             )
                  //           ]),
                  //     ),
                  //   ),
                  // ),
                  //login 구현 버전 끝

                  //login 구현x 버전
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(70, 20, 20, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => HomePage());
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          backgroundColor: Colors.lightBlueAccent[200]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Login'), Icon(Icons.login)],
                      ),
                    ),
                  ),
                  //login 구현x 버전 끝
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 70, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Get.to(() => Signup());
                      showNorification();
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: Colors.lightBlueAccent[200]),
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontFamily: 'NanimSquareNeo'),
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget id() => Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        height: 50,
        child: TextFormField(
          controller: idController,
          validator: (value) => value == "" ? "Please enter user id" : null,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelText: 'Id',
              labelStyle: TextStyle(fontFamily: 'NanumSquareNeo')),
        ),
      );

  Widget password() => Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        height: 50,
        child: TextFormField(
          controller: passwordController,
          validator: (value) =>
              value == "" ? "Please enter user password" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelText: 'Password',
          ),
          obscureText: true,
        ),
      );
}
