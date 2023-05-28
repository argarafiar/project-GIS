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
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          'DETAIL PRESENSI',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange.shade100,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  SizedBox(height: 4),
                  Divider(thickness: 2),
                  SizedBox(height: 8),
                  Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text("jam"),
                      SizedBox(width: 34,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(DateFormat.jms()
                              .format(DateTime.parse(data['masuk']!['date'])))
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "Posisi"),
                      SizedBox(width: 20,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text("${data['masuk']!['lat']}, ${data['masuk']!['long']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Status"),
                      SizedBox(width: 17,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text("${data['masuk']!['status']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Alamat"),
                      SizedBox(width: 13,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text("${data['masuk']!['address']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                          "Jarak"),
                      SizedBox(width: 22,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text("${data['masuk']!['distance'].toString().split(".").first} Meter"),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 2),
                  SizedBox(height: 5),
                  Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text("jam"),
                      SizedBox(width: 34,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(data['keluar']?['date'] == null
                          ? "-"
                          :
                              DateFormat.jms()
                                  .format(DateTime.parse(data['keluar']!['date']))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Posisi"),
                      SizedBox(width: 20,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(data['keluar']?['lat'] == null &&
                              data['keluar']?['long'] == null
                          ? "-"
                          : "${data['keluar']!['lat']}, ${data['keluar']!['long']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Status"),
                      SizedBox(width: 17,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(data['keluar']?['status'] == null
                          ? "-"
                          : "${data['keluar']!['status']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Alamat"),
                      SizedBox(width: 13,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(data['keluar']?['address'] == null
                          ? "-"
                          : "${data['keluar']!['address']}"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Jarak"),
                      SizedBox(width: 22,),
                      Text(": "),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6 -1,
                        child: Text(data['keluar']?['distance'] == null
                          ? "-"
                          : "${data['keluar']!['distance'].toString().split(".").first} Meter"),
                      ),
                    ],
                  ),
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
                borderRadius: BorderRadius.circular(100),
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
