import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
import 'package:presence/app/modules/profile/controllers/profile_controller.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  final pageC = Get.find<PageIndexController>();
  final controller = Get.put(ProfileController());
  String isUser = "";

  @override
  void initState() {
    controller.getUserRole().then((value) {
      setState(() {
        isUser = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.fixedCircle,
      backgroundColor: Colors.orange,
      items: [
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(
            icon: isUser == 'admin' ? Icons.map : Icons.fingerprint,
            title: 'Add'),
        TabItem(icon: Icons.people, title: 'Profile'),
      ],
      initialActiveIndex: pageC.pageIndex.value,
      onTap: (int i) => pageC.changPage(i, isUser),
    );
  }
}
