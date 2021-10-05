import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group/controller/user_controller.dart';
import 'package:group/model/constants.dart';
import 'package:group/view/user_details_page.dart';
import 'package:sizer/sizer.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..animationStyle = EasyLoadingAnimationStyle.scale
      ..indicatorType = EasyLoadingIndicatorType.squareCircle;
    String? userName = GetStorage().read('userName') as String?;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 90.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10.h),
          Center(
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              onFinished: () {
                if (userName == null) {
                  Get.offAll(() => const UserDetailsPage());
                } else {
                  Get.put(UserController(), tag: 'user');
                  Get.offAll(() => HomeScreen());
                }
              },
              animatedTexts: [
                TypewriterAnimatedText(
                  'Express Yourself',
                  textStyle: TextStyle(
                    fontSize: 30.sp,
                    fontFamily: GoogleFonts.concertOne().fontFamily,
                    color: Colors.white,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: K.splashBackground,
    );
  }
}
