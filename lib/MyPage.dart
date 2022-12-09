import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/SetMyPage.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/model/user.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //const MyPage({super.key});

  String name = 'User';

  var addr = Get.arguments[0];
  var switchValue = Get.arguments[1];

  // var switchValue = Get.arguments['switch'];

  TextEditingController _AddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: Icon(
            Icons.account_circle_rounded,
            size: 80,
          ),
        ),
        Center(
          child: Padding(
              child: Text(
                'Name: ' + name,
                style: TextStyle(fontFamily: 'NanumSquareNeo', fontSize: 15),
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 50)),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Address',
                style: TextStyle(fontFamily: 'NanumSquareNeo'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('$addr',
                  style: TextStyle(fontFamily: 'NanumSquareNeo', fontSize: 23)),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Text(
                '자동 구조 요청',
                style: TextStyle(fontFamily: 'NanumSquareNeo', fontSize: 15),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(150, 50, 20, 20),
              child: Switch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    _postSwitch();
                  });
                },
                activeTrackColor: Colors.lightBlueAccent,
                activeColor: Colors.blue,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(250, 20, 20, 0),
          child: ElevatedButton(
            onPressed: () async {
              addr = await Get.to(() => SetMyPage());
            },
            style: ElevatedButton.styleFrom(
                minimumSize: Size(100, 50),
                backgroundColor: Colors.lightBlueAccent[200]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Edit'), Icon(Icons.edit)],
            ),
          ),
        ),
      ]),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(); //주소 찾기 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              isDense: false,
            ),
            controller: _AddressController,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: ((context) => RemediKopo()),
      ),
    );

    _AddressController.text =
        '${model.zonecode!} ${model.address!} ${model.buildingName!}';
  }

  _postSwitch() async {
    String url = 'http://192.168.0.57:7579/Mobius/Phone/Auto';

    http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'X-M2M-RI': '12345',
          'X-M2M-Origin': 'App',
          'Content-Type': 'application/json;ty=4'
        },
        body: jsonEncode({
          "m2m:cin": {'con': switchValue}
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('POST');
    } else {
      print('fail');
    }
  }
}
