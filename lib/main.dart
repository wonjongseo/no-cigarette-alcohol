import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_setting.dart';
import 'screens/setting_screen.dart';
import 'services/home_widget_service.dart';

//group.com.wonjongseo.no-cigarette-alcohol
//com.wonjongseo.no-cigarette-alcohol
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserSettingAdapter());

  await Hive.openBox<UserSetting>('userBox');
  await HomeWidgetService.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: '금연/금주 위젯', home: SettingScreen());
  }
}
