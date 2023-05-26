import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends StatefulWidget {
  DetailPresensiView({Key? key}) : super(key: key);

  @override
  State<DetailPresensiView> createState() => _DetailPresensiViewState();
}

class _DetailPresensiViewState extends State<DetailPresensiView> {
  final controller = Get.put(DetailPresensiController());

  Map<String, dynamic> data = Get.arguments;

  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    double lat = data["keluar"]?["lat"] != null
        ? data["keluar"]!["lat"]
        : data["masuk"]!["lat"];
    double long = data["keluar"]?["long"] != null
        ? data["keluar"]!["long"]
        : data["masuk"]!["long"];
    _setMarkers(data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL PRESENSI'),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMMEEEEd()
                          .format(DateTime.parse(data['date'])),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("jam : " +
                      DateFormat.jms()
                          .format(DateTime.parse(data['masuk']!['date']))),
                  Text(
                      "Posisi : ${data['masuk']!['lat']}, ${data['masuk']!['long']}"),
                  Text("Status : ${data['masuk']!['status']}"),
                  Text("Alamat : ${data['masuk']!['address']}"),
                  Text(
                      "Distance : ${data['masuk']!['distance'].toString().split(".").first} Meter"),
                  SizedBox(height: 20),
                  Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(data['keluar']?['date'] == null
                      ? "jam : -"
                      : "jam : " +
                          DateFormat.jms()
                              .format(DateTime.parse(data['keluar']!['date']))),
                  Text(data['keluar']?['lat'] == null &&
                          data['keluar']?['long'] == null
                      ? "Posisi : -"
                      : "Posisi : ${data['keluar']!['lat']}, ${data['keluar']!['long']}"),
                  Text(data['keluar']?['status'] == null
                      ? "Status : -"
                      : "Status : ${data['keluar']!['status']}"),
                  Text(data['keluar']?['address'] == null
                      ? "Alamat : -"
                      : "Alamat : ${data['keluar']!['address']}"),
                  Text(data['keluar']?['distance'] == null
                      ? "Distance : -"
                      : "Distance : ${data['keluar']!['distance'].toString().split(".").first} Meter"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              constraints: BoxConstraints(
                maxHeight: 250,
                maxWidth: double.infinity,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(lat, long),
                  zoom: 15,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setMarkers(Map<String, dynamic> data) {
    if (data["keluar"] != null) {
      _markers.add(
        Marker(
          anchor: Offset(0.1, 1),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          markerId: MarkerId("keluar"),
          position: LatLng(data["keluar"]["lat"], data["keluar"]["long"]),
          infoWindow: InfoWindow(
            title: "Keluar",
            snippet: data["keluar"]["address"],
          ),
        ),
      );
    }
    _markers.add(
      Marker(
        markerId: MarkerId("masuk"),
        position: LatLng(data["masuk"]["lat"], data["masuk"]["long"]),
        infoWindow: InfoWindow(
          title: "Masuk",
          snippet: data["masuk"]["address"],
        ),
      ),
    );
    setState(() {});
  }
}
