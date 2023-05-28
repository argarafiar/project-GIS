import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/adminhome_controller.dart';

class AdminhomeView extends GetView<AdminhomeController> {
  const AdminhomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text('AdminhomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminhomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
