import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/HomePage.dart';
import 'package:flutter_application_2/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;

class SetMyPage extends StatefulWidget {
  @override
  State<SetMyPage> createState() => _SetMyPageState();
}

class _SetMyPageState extends State<SetMyPage> {
  //const MyPage({super.key});
  var switchValue = false;
  TextEditingController _AddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 70,
        ),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('asset/account_circle.jpg'),
          ),
        ),
        AddressText(),
        Padding(
          padding: const EdgeInsets.only(left: 300),
          child: TextButton(
              onPressed: () {
                _postRequest();
                Get.offAll(HomePage());
              },
              child: Text('Save')),
        ),
      ]),
    );
  }

  Widget AddressText() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(); // 카카오 주소 API
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주소 입력', style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
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
    _postRequest();
  }

  _postRequest() async {
    String url = 'http://192.168.0.57:7579/Mobius/Phone/addr';

    http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'X-M2M-RI': '12345',
          'X-M2M-Origin': 'App',
          'Content-Type': 'application/json;ty=4'
        },
        body: jsonEncode({
          "m2m:cin": {'con': _AddressController.text}
        }));
    if (response.statusCode == 200 || response.statusCode == 201) {
      Fluttertoast.showToast(msg: '주소가 성공적으로 저장되었습니다.');
    } else {
      Fluttertoast.showToast(msg: 'error');
    }
  }
}
