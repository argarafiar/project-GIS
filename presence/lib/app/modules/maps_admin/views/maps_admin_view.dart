import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../controllers/maps_admin_controller.dart';

class MapsAdminView extends StatefulWidget {
  MapsAdminView({super.key});
  List<Map<String, dynamic>> data = Get.arguments;

  @override
  State<MapsAdminView> createState() => _MapsAdminViewState(data: data);
}

class _MapsAdminViewState extends State<MapsAdminView> {
  _MapsAdminViewState({required this.data});
  final controller = Get.put(MapsAdminController());
  List<Map<String, dynamic>> data;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    print(data[data.length - 1]["position"]);
    _setMarkers(data);
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(data[data.length - 1]["position"]["lat"],
                data[data.length - 1]["position"]["long"]),
            zoom: 11,
          ),
          markers: _markers,
        ),
        Positioned(
          top: 40,
          left: 10,
          child:
              IconButton(onPressed: () => Get.back(), icon: Icon(Icons.close)),
        )
      ]),
    );
  }

  void _setMarkers(List<Map<String, dynamic>> data) {
    //filter data yang tidak memiliki atribut position
    data = data.where((element) => element["address"] != "").toList();

    //masukkan data ke dalam markers
    for (var i = 0; i < data.length; i++) {
      _markers.add(
        Marker(
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //   BitmapDescriptor.hueBlue,
          // ),
          markerId: MarkerId(data[i]["uid"]),
          position: LatLng(
            data[i]["position"]["lat"],
            data[i]["position"]["long"],
          ),
          infoWindow: InfoWindow(
            title: data[i]["nama"],
            snippet: data[i]["address"],
          ),
        ),
      );
      setState(() {});
    }
  }
}
