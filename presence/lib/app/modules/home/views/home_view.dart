import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:presence/app/controllers/page_index_controller.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
// import '../../all_pegawai/controllers/all_pegawai_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final pageC = Get.find<PageIndexController>();
  final controller = Get.put(HomeController());
  String isUser = "";

  void initState() {
    // TODO: implement initState
    controller.getUserRole().then((value) {
      setState(() {
        isUser = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                String defaultProfile =
                    "https://ui-avatars.com/api/?name=${user["nama"]}";
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      // padding: EdgeInsets.all(20),
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 75,
                                height: 75,
                                color: Colors.grey[200],
                                child: Image.network(
                                  user["profile"] != null
                                      ? user["profile"]
                                      : defaultProfile,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Welcome ",
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/icon text.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 200,
                                  child: Text(user["address"] != null
                                      ? user["address"].toString()
                                      : "Belum ada lokasi"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamAllPegawai(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasData) {
                                List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                    data = snapshot.data!.docs;
                                if (user['role'] == 'admin') {
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Total Pegawai :",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          (data.length - 1).toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            user['job'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          user['nama'],
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          user['nip'],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else {
                                return Center(child: Text("No Data"));
                              }
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        if (user['role'] == 'admin')
                          AdminScreen(controller: controller)
                        else
                          PegawaiScreen(controller: controller)
                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text("No Data"));
              }
            },
          ),
        ),

        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(
                icon: isUser == 'admin' ? Icons.map : Icons.fingerprint,
                title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changPage(i, isUser),
        ));
  }
}

class PegawaiScreen extends StatelessWidget {
  const PegawaiScreen({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamTodayPresence(),
              builder: (context, snapToday) {
                if (snapToday.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                Map<String, dynamic>? dataToday = snapToday.data?.data();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Masuk"),
                        Text(dataToday?["masuk"] == null
                          ? "-"
                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['masuk']['date']))}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 2,
                      height: 30,
                      color: Colors.black,
                    ),
                    Column(
                      children: [
                        Text("Keluar"),
                        Text(dataToday?["keluar"] == null
                          ? "-"
                          : "${DateFormat.jms().format(DateTime.parse(dataToday!['keluar']['date']))}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "last 5 days",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/all-presensi'),
              child: Text(
                "See All",
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamLastPresence(),
            builder: (context, snapPresence) {
              if (snapPresence.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapPresence.data?.docs.length == 0 ||
                  snapPresence.data == null)
                return SizedBox(
                    height: 150,
                    child: Center(child: Text("belum ada history presensi")));

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapPresence.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapPresence.data!.docs[index].data();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () => Get.toNamed(
                          '/detail-presensi',
                          arguments: data,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Masuk",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(data["masuk"]?["date"] == null
                                    ? "-"
                                    : "${DateFormat.jms().format(DateTime.parse(data["masuk"]!["date"]))}"),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Keluar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(data["keluar"]?["date"] == null
                                    ? "-"
                                    : "${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}"),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                      ),
                    ),
                  );
                },
              );
            }),
      ],
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: controller.getPresence(snapshot.data!.docs[index]["uid"]),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map<String, dynamic> presenceToday =
                    snap.data!.docs.isEmpty ? {} : snap.data!.docs[0].data();
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
                      Get.snackbar("Kesalahan", "Tidak ada data presensi");
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("Nama"),
                            const SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6 -4,
                              child: Text(": ${snapshot.data!.docs[index]["nama"]}"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text("Job"),
                            const SizedBox(
                              width: 44,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6 -4,
                              child: Text(": ${snapshot.data!.docs[index]["job"]}")
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text("Address"),
                            SizedBox(
                              width: 16,),
                            Text(": "),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6 -11,
                              child: Text("${snapshot.data!.docs[index]["address"] == "" ? "-" : snapshot.data!.docs[index]["address"]}"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text("Presence"),
                            SizedBox(
                              width: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6 -4,
                              child: Text(": ${presenceToday.isEmpty || presenceToday['date'].substring(0, 10) != today ? "Belum Absen" : "Sudah Absen"}")
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
