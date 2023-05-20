import 'package:get/get.dart';

import '../controllers/maps_pegawai_controller.dart';

class MapsPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsPegawaiController>(
      () => MapsPegawaiController(),
    );
  }
}
