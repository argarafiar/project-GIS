import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL PRESENSI'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
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
                    DateFormat.yMMMMEEEEd().format(DateTime.now()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("jam : " + DateFormat.jms().format(DateTime.now())),
                Text("Posisi : 14349374"),
                Text("Status : didalam area"),
                SizedBox(height: 20),
                Text(
                  "Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("jam : " + DateFormat.jms().format(DateTime.now())),
                Text("Posisi : 14349374"),
                Text("Status : didalam area"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
