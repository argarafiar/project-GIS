import 'package:get/get.dart';

import '../controllers/all_pegawai_controller.dart';

class AllPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllPegawaiController>(
      () => AllPegawaiController(),
    );
  }
}
