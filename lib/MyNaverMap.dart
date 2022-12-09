import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:geolocator/geolocator.dart';

class MyNaverMap extends StatefulWidget {
  const MyNaverMap({super.key});

  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NaverMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(37.55101639929881, 127.07569717233763)),
        onMapCreated: _onMapCreated,
        locationButtonEnable: true,
        markers: [
          Marker(
            markerId: 'gunjadongservicecenter',
            position: LatLng(37.55548, 127.07535),
          ),
          Marker(
            markerId: 'gunjahall',
            position: LatLng(37.54965, 127.0737),
          ),
          Marker(
            markerId: 'ilsungapt',
            position: LatLng(37.5513, 127.072592),
          ),
          Marker(
            markerId: 'megabox',
            position: LatLng(37.55579, 127.07838),
          ),
          Marker(
            markerId: 'underpass',
            position: LatLng(37.543143, 127.075149),
          ),
          // Marker(
          //   markerId: 'DeayangAI',
          //   position: LatLng(37.5508, 127.0754),
          // ),
          // Marker(
          //   markerId: 'DeayangAI2',
          //   position: LatLng(37.5513, 127.0754),
          // ),
        ],
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }
}
