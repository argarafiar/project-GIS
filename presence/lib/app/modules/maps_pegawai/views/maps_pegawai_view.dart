import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

import '../controllers/maps_pegawai_controller.dart';

// class MapsPegawaiView extends GetView<MapsPegawaiController> {
//   MapsPegawaiView({Key? key}) : super(key: key);
//   Map<String, dynamic> data = Get.arguments;
//   @override
//   Widget build(BuildContext context) {
//     //parsing data
//     double lat = data["keluar"]["lat"] ?? data["masuk"]["lat"];
//     double long = data["keluar"]["long"] ?? data["masuk"]["long"];
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(lat, long),
//               zoom: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class MapsPegawaiView extends StatefulWidget {
  MapsPegawaiView({super.key});
  Map<String, dynamic> data = Get.arguments;

  @override
  State<MapsPegawaiView> createState() => _MapsPegawaiViewState(data: data);
}

class _MapsPegawaiViewState extends State<MapsPegawaiView> {
  _MapsPegawaiViewState({required this.data});
  Map<String, dynamic> data;
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    double lat =
        data["keluar"] != null ? data["keluar"]["lat"] : data["masuk"]["lat"];
    double long =
        data["keluar"] != null ? data["keluar"]["long"] : data["masuk"]["long"];
    _setMarkers(data, lat, long);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, long),
              zoom: 15,
            ),
            markers: _markers,
          ),
          Positioned(
            bottom: 40,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text("Date : ${data["date"].substring(0, 10)}"),
                        Text(
                            "Masuk : ${data["masuk"]["date"].substring(11, 19)}"),
                        Text(
                            "Keluar : ${data["keluar"] == null ? "-" : data["keluar"]["date"].substring(11, 19)}"),
                        Text("Status masuk : ${data["masuk"]["status"]}"),
                        Text("Alamat masuk : ${data["masuk"]["address"]}"),
                        Text(
                            "Status keluar : ${data["keluar"] == null ? "-" : data["keluar"]["status"]}"),
                        Text(
                            "Alamat keluar : ${data["keluar"] == null ? "-" : data["keluar"]["address"]}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
                onPressed: () => Get.back(), icon: Icon(Icons.close)),
          )
        ],
      ),
    );
  }

  void _setMarkers(Map<String, dynamic> data, double lat, double long) {
    _markers.add(
      Marker(
        markerId: MarkerId(data["date"]),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(title: data["date"]),
        onTap: () {},
      ),
    );
    setState(() {});
  }
}
