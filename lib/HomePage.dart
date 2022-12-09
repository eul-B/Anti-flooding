import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/MyNaverMap.dart';
import 'package:flutter_application_2/MyPage.dart';
import 'package:flutter_application_2/api/notification.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Client;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 70, 0, 0),
                child: ButtonTheme(
                  height: 70,
                  minWidth: 70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.only(right: 20),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.refresh),
                    color: Colors.black,
                    iconSize: 50.0,
                    onPressed: () async {
                      // 정보 가져오기
                      var level = int.parse(await _getInfo());
                      var swit = await _getAuto();
                      var lat = double.parse(await _getaddrlat());
                      var lng = double.parse(await _getaddrlng());
                      // double lat = 37.5496;
                      // double lng = 127.0751;
                      lat = double.parse(lat.toStringAsFixed(4));
                      lng = double.parse(lng.toStringAsFixed(4));
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best);
                      var curLat = position.latitude;
                      var curLng = position.longitude;
                      curLat = double.parse(curLat.toStringAsFixed(4));
                      curLng = double.parse(curLng.toStringAsFixed(4));

                      double difLat = curLat - lat;
                      difLat = difLat.abs();
                      double difLng = curLng - lng;
                      difLng = difLng.abs();
                      String LL = curLat.toString();

                      if (level > 0) {
                        showNorification();
                        Fluttertoast.showToast(msg: '경고: 침수가 발생했습니다.');
                        if (difLng < 0.005 && difLng < 0.005) {
                          if (swit == "true") {
                            FlutterPhoneDirectCaller.callNumber('01056903123');
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: ButtonTheme(
                  height: 70,
                  minWidth: 70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(70),
                    side: BorderSide(color: Colors.black),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.only(right: 20),
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.account_circle),
                    color: Colors.black,
                    iconSize: 50.0,
                    onPressed: () async {
                      //addr 정보 가져오기
                      var address = await _getRequest();
                      print(address.runtimeType);
                      //자동구조요청 여부 가져오기
                      var switchValue = await _getAuto();
                      var swt = false;
                      if (switchValue == "on" || switchValue == "true") {
                        swt = true;
                      } else {
                        swt = false;
                      }
                      print(switchValue.runtimeType);
                      // Get.to(() => MyPage(), arguments: address);
                      Get.to(() => MyPage(), arguments: [address, swt]);
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(370, 150),
                backgroundColor: Colors.redAccent[200]),
            onPressed: () {
              FlutterPhoneDirectCaller.callNumber('01056903123');
            },
            icon: Icon(Icons.emergency, size: 70),
            label: Text(
              '구조 요청하기',
              style: TextStyle(fontFamily: 'NanumSquareNeo', fontSize: 35),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size(370, 150)),
            onPressed: () {
              Get.to(MyNaverMap());
            },
            icon: Icon(Icons.home, size: 70),
            label: Text(
              '대피소 확인하기',
              style: TextStyle(fontFamily: 'NanumSquareNeo', fontSize: 35),
            ),
          ),
        ],
      ),
    );
  }
}

_getRequest() async {
  String url = 'http://192.168.0.57:7579/Mobius/Phone/addr/la';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Accept': 'application/json',
      'X-M2M-RI': '12345',
      'X-M2M-Origin': 'App',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Map<String, dynamic> data = jsonDecode(response.body);
    // var address = data['m2m:cin']['con'];
    // print(address.runtimeType);
    return data['m2m:cin']['con'];
  } else {
    print('fail');
  }
}

_getInfo() async {
  String url = 'http://192.168.0.57:7579/Mobius/Home_gateway/level/la';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Accept': 'application/json',
      'X-M2M-RI': '12345',
      'X-M2M-Origin': 'App',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Map<String, dynamic> data = jsonDecode(response.body);

    // var address = data['m2m:cin']['con'];
    // print(address.runtimeType);
    return data['m2m:cin']['con'];
  } else {
    print('fail');
  }
}

_getAuto() async {
  String url = 'http://192.168.0.57:7579/Mobius/Phone/Auto/la';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Accept': 'application/json',
      'X-M2M-RI': '12345',
      'X-M2M-Origin': 'App',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['m2m:cin']['con'];
  } else {
    print('fail');
  }
}

_getaddrlat() async {
  String url = 'http://192.168.0.57:7579/Mobius/Home_gateway/gps_lat/la';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Accept': 'application/json',
      'X-M2M-RI': '12345',
      'X-M2M-Origin': 'App',
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['m2m:cin']['con'];
  } else {
    print('fail');
  }
}

_getaddrlng() async {
  String url = 'http://192.168.0.57:7579/Mobius/Home_gateway/gps_lon/la';

  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Accept': 'application/json',
      'X-M2M-RI': '12345',
      'X-M2M-Origin': 'App',
      'Content-Type': 'application/json?ty=4'
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    print(response.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['m2m:cin']['con'];
  } else {
    print('fail');
  }
}
