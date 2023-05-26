import 'package:get/get.dart';

import '../controllers/maps_admin_controller.dart';

class MapsAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapsAdminController>(
      () => MapsAdminController(),
    );
  }
}
