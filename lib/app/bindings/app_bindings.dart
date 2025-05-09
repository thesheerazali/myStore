import 'package:get/get.dart';
import '../modules/home/view/favorites/controller/favorites_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController(), fenix: true);
  }
}
