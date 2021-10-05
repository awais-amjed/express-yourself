import 'package:dismiss_keyboard_on_tap/dismiss_keyboard_on_tap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group/model/constants.dart';
import 'package:group/view/splash_screen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const ExpressYourself());
}

class ExpressYourself extends StatelessWidget {
  const ExpressYourself({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return DismissKeyboardOnTap(
          child: GetMaterialApp(
            theme: ThemeData(
              colorScheme: ThemeData().colorScheme.copyWith(
                    primary: K.mainColor,
                  ),
              fontFamily: 'LuxoraGrotesk',
            ),
            home: const SplashScreen(),
            builder: EasyLoading.init(),
          ),
        );
      },
    );
  }
}
