import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AllPegawaiController extends GetxController {
  //TODO: Implement AllPegawaiController

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //ambil seluruh data pegawai dengan future
  Future<QuerySnapshot<Map<String, dynamic>>> getAllPegawai() async {
    return await firestore.collection("pegawai").get();
  }

  //ambil data presensi pegawai dengan future
  Future<QuerySnapshot<Map<String, dynamic>>> getPresence(String uid) async {
    var data = await firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .get();

    print(data.docs.toString());

    if (data.docs.isNotEmpty) {
      return data;
    } else {
      return data;
    }
  }
}
