import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/api/api.dart';
import 'package:flutter_application_2/model/user.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:http/http.dart' show Client;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var formKey = GlobalKey<FormState>();

  var userNameController = TextEditingController();
  var userIdController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  // var addressController = TextEditingController();

  checkUserEmail() async {
    try {
      var response = await http.post(Uri.parse(API.validateEmail),
          body: {'user_email': emailController.text.trim()});
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['existEmail'] == true) {
          Fluttertoast.showToast(
            msg: "Email is already in use. Please try another email",
          );
        } else {
          saveInfo();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  checkUserId() async {
    try {
      var response = await http.post(Uri.parse(API.validateId),
          body: {'user_id': userIdController.text.trim()});
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['existId'] == true) {
          Fluttertoast.showToast(
            msg: "Id is already in use. Please try another id",
          );
        } else {
          saveInfo();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async {
    User userModel = User(
      userIdController.text.trim(),
      userNameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
      // addressController.text.trim(),
    );

    try {
      var res =
          await http.post(Uri.parse(API.signup), body: userModel.toJson());
      if (res.statusCode == 200) {
        var resSignup = jsonDecode(res.body);
        if (resSignup['success'] == true) {
          Fluttertoast.showToast(msg: 'Signup successfully');
          _getRequest();
          _postRequest();
          setState(() {
            userIdController.clear();
            userNameController.clear();
            emailController.clear();
            passwordController.clear();
            // addressController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: 'Error occirred. Pease try again');
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  _getRequest() async {
    String url = 'http://10.0.1.11:7579/Mobius/level';

    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'X-M2M-RI': '12345',
        'X-M2M-Origin': 'SOrigin',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    } else {
      print('fail');
    }
  }

  _postRequest() async {
    String url = 'http://10.0.1.11:7579/Mobius';

    http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'X-M2M-RI': '12345',
          'X-M2M-Origin': 'App',
          'Content-Type': 'application/json;ty=2'
        },
        body: jsonEncode({
          "m2m:ae": {
            "rn": "Phone",
            "api": "0.2.481.2.0001.001.000111",
            "rr": true
          }
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('POST');
    } else {
      print('fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              SizedBox(
                height: 200.0,
              ),
              Form(
                key: formKey,
                child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey,
                    ),
                    child: Column(
                      children: [
                        id(),
                        password(),
                        name(),
                        email(),
                        // AddressText(),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    checkUserEmail();
                    checkUserId();
                  }
                },
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 120) +
                        EdgeInsets.only(top: 30),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightBlueAccent[200],
                      ),
                      child: Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              fontFamily: 'NanumSquareNeo',
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget name() => Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        height: 50,
        child: TextFormField(
          controller: userNameController,
          validator: (value) => value == "" ? "Please enter username" : null,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              labelText: 'Name',
              labelStyle: TextStyle(fontFamily: 'NanumSquareNeo')),
        ),
      );

  Widget id() => Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        height: 50,
        child: TextFormField(
          controller: userIdController,
          validator: (value) => value == "" ? "Please enter userid" : null,
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
          validator: (value) => value == "" ? "Please enter password" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelText: 'Password',
            labelStyle: TextStyle(fontFamily: 'NanumSquareNeo'),
          ),
          obscureText: true,
        ),
      );
  Widget email() => Container(
        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
        height: 50,
        child: TextFormField(
          controller: emailController,
          validator: (value) => value == "" ? "Please enter email" : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            labelText: 'email',
            labelStyle: TextStyle(fontFamily: 'NanumSquareNeo'),
          ),
        ),
      );
}
