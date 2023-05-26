import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    yield* firestore.collection("pegawai").doc(uid).snapshots();
  }

  Future<String> getUserRole() async {
    String uid = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection("pegawai").doc(uid).get();

    print("role: ${doc.data()!["role"]}");

    return doc.data()!["role"];
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLastPresence() async* {
    String uid = auth.currentUser!.uid;

    //ambil data presensi 5 hari terakhir
    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .orderBy("date", descending: true)
        .limit(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser!.uid;

    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("pegawai")
        .doc(uid)
        .collection("presence")
        .doc(todayID)
        .snapshots();
  }

  //ambil data semua pegawai
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPegawai() async* {
    yield* firestore.collection("pegawai").snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPegawai() async {
    //ambil semua pegawai kecuali admin
    return await firestore
        .collection("pegawai")
        .where("role", isNotEqualTo: "admin")
        .get();
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
