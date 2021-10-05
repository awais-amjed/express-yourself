import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  late String userName;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    String? userName = GetStorage().read('userName') as String?;

    if (userName != null) {
      this.userName = userName;
    }
  }
}
