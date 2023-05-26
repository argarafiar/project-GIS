import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changPage(int i, String role) async {
    pageIndex.value = i;

    switch (i) {
      case 1:
        if (role == 'admin') {
          //ambil semua data pegawai kecuali admin
          List<Map<String, dynamic>> data = await firestore
              .collection("pegawai")
              .where("role", isEqualTo: "pegawai")
              .get()
              .then((value) => value.docs.map((e) => e.data()).toList());

          // print(data);

          // filter data pegawai yang sudah pernah absen
          // List<Map<String, dynamic>> dataPegawai = [];
          // for (var i = 0; i < data.length; i++) {
          //   String uid = data[i]["uid"];
          //   QuerySnapshot<Map<String, dynamic>> snapPresence = await firestore
          //       .collection("pegawai")
          //       .doc(uid)
          //       .collection("presence")
          //       .get();

          //   if (snapPresence.docs.length > 0) {
          //     dataPegawai.add(data[i]);
          //   }
          // }

          Get.toNamed('/maps-admin', arguments: data);
        } else {
          print("ABSEN");
          Map<String, dynamic> dataRes = await determinePosition();
          if (dataRes["error"]) {
            Get.snackbar("Terjadi Kesalahan", dataRes["message"]);
          } else {
            Position position = dataRes["position"];
            List<Placemark> placemarks = await placemarkFromCoordinates(
                position.latitude, position.longitude);
            String address =
                "${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].subAdministrativeArea}";
            await updatePosition(position, address);

            //initial kantor
            double distance = Geolocator.distanceBetween(
                -7.2755247, 112.7933863, position.latitude, position.longitude);

            //presensi
            await presensi(position, address, distance);
          }
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresence =
        await firestore.collection("pegawai").doc(uid).collection("presence");
    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar area";
    if (distance <= 200) {
      status = "Di dalam area";
    }

    if (snapPresence.docs.length == 0) {
      //belum pernah absen
      await Get.defaultDialog(
          title: "Validasi Absen",
          middleText: "Apakah kamu yakin akan absen masuk?",
          actions: [
            OutlinedButton(onPressed: () => Get.back(), child: Text("batal")),
            ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set({
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil", "kamu telah mengisi daftar hadir");
                },
                child: Text("iya")),
          ]);
    } else {
      //sudah pernah absen
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();
      if (todayDoc.exists) {
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          Get.snackbar(
              "Peringatan", "Kamu telah absen masuk dan keluar hari ini");
        } else {
          await Get.defaultDialog(
              title: "Validasi Absen",
              middleText: "Apakah kamu yakin akan absen keluar?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("batal")),
                ElevatedButton(
                    onPressed: () async {
                      await colPresence.doc(todayDocID).update({
                        "keluar": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "address": address,
                          "status": status,
                          "distance": distance,
                        }
                      });
                      Get.back();
                      Get.snackbar(
                          "Berhasil", "kamu telah berhasil absen keluar");
                    },
                    child: Text("iya")),
              ]);
        }
      } else {
        await Get.defaultDialog(
            title: "Validasi Absen",
            middleText: "Apakah kamu yakin akan absen masuk?",
            actions: [
              OutlinedButton(onPressed: () => Get.back(), child: Text("batal")),
              ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "kamu telah mengisi daftar hadir");
                  },
                  child: Text("iya")),
            ]);
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   //tampilkan pesan error agar bisa di cek di logcat
    //   return Future.error('Location services are disabled.');
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message":
              "Izin lokasi tidak di tolak, silahkan aktifkan di pengaturan",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Settingan lokasi tidak diizinkan, silahkan aktifkan di pengaturan",
        "error": true,
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return {
        "position": position,
        "message": "success",
        "error": false,
      };
    } catch (e) {
      print(e);
      return {
        "message": "Terjadi kesalahan, silahkan coba lagi",
        "error": true,
      };
    }
  }

  Map<String, dynamic> getUser() {
    var user =
        firestore.collection("pegawai").doc(auth.currentUser!.uid).snapshots();
    return user as Map<String, dynamic>;
  }

  Future<String> getUserRole() async {
    String uid = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection("pegawai").doc(uid).get();

    print("role: ${doc.data()!["role"]}");

    return doc.data()!["role"];
  }
}
