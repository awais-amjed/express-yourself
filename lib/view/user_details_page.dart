import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group/controller/user_controller.dart';
import 'package:group/model/constants.dart';
import 'package:group/view/home_screen.dart';
import 'package:sizer/sizer.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  String name = 'Anonymous';

  late final AnimationController _iconController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _iconAnimation = CurvedAnimation(
    parent: _iconController,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iconController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'We respect your privacy so all your data is stored only on your device.'
              "If you still don't want to share your information just continue as anonymous.",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ScaleTransition(
            scale: _iconAnimation,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/person-logo.png',
                      fit: BoxFit.cover,
                      width: 140,
                      height: 140,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Do you want to use your name?'),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              maxLength: 20,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Enter name',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              onChanged: (value) {
                name = value;
              },
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: 50.w,
            child: TextButton(
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(K.mainColor),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15))),
              onPressed: () async {
                GetStorage().write('userName', name);
                Get.put(UserController(), tag: 'user');
                Get.to(HomeScreen());
              },
            ),
          ),
        ],
      ),
    );
  }
}
