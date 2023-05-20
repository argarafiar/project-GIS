import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/all_pegawai_controller.dart';

class AllPegawaiView extends GetView<AllPegawaiController> {
  const AllPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AllPegawaiView'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPegawaiController>(
        builder: (controller) => FutureBuilder(
          future: controller.getAllPegawai(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data == null || snapshot.data?.docs.length == 0) {
              return Center(
                child: Text("Belum ada pegawai"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return GetBuilder<AllPegawaiController>(
                  builder: (controller) => FutureBuilder(
                    future: controller
                        .getPresence(snapshot.data!.docs[index]["uid"]),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      Map<String, dynamic> presenceToday =
                          snap.data!.docs.isEmpty
                              ? {}
                              : snap.data!.docs[0].data();
                      //ambil tanggalnya saja dari datetime
                      String today = DateTime.now().toIso8601String();
                      today = today.substring(0, 10);
                      return InkWell(
                        onTap: () {
                          // print(presenceToday.toString());
                          try {
                            Get.toNamed(Routes.MAPS_PEGAWAI,
                                arguments: snap.data!.docs[0].data());
                          } catch (e) {
                            Get.snackbar(
                                "Kesalahan", "Tidak ada data presensi");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          color: Colors.grey[200],
                          child: Column(
                            children: [
                              Text(
                                  "Nama : ${snapshot.data!.docs[index]["nama"]}"),
                              Text(
                                  "Job : ${snapshot.data!.docs[index]["job"]}"),
                              Text(
                                  "Address : ${snapshot.data!.docs[index]["address"]}"),
                              Text(
                                  "Presence : ${presenceToday.isEmpty || presenceToday['date'].substring(0, 10) != today ? "Belum Absen" : "Sudah Absen"}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
