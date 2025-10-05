import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:no_cigarette_alcohol/controllers/user_setting_controller.dart';
import 'package:no_cigarette_alcohol/screens/home/home_screen.dart';
import 'package:no_cigarette_alcohol/screens/user_setting/setting_screen.dart';

class SplashScreen extends StatelessWidget {
  static String name = '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserSettingController.to;
    ever(controller.userSetting, (_) {
      if (controller.userSetting.value == null) {
        Get.offAllNamed(UserSettingScreen.name);
      } else {
        Get.offAllNamed(HomeScreen.name);
      }
    });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: size.width * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/appstore.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
