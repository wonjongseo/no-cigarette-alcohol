import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:no_cigarette_alcohol/controllers/user_setting_controller.dart';
import 'package:no_cigarette_alcohol/core/constants/app_constart.dart';
import 'package:no_cigarette_alcohol/core/repository/setting_repository.dart';
import 'package:no_cigarette_alcohol/core/utils/app_translations.dart';

import 'package:no_cigarette_alcohol/screens/home/home_screen.dart';
import 'package:no_cigarette_alcohol/screens/splash/splash_screen.dart';
import 'package:no_cigarette_alcohol/screens/user_setting/setting_screen.dart';

import 'models/user_setting.dart';
import 'models/user_setting_history.dart';
import 'services/home_widget_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 초기화 + 어댑터 등록
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserSettingAdapter()); // typeId: 0
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(UserSettingHistoryAdapter()); // typeId: 1
  }

  // 박스 오픈 (존재/중복 체크)
  if (!Hive.isBoxOpen(AppConstant.settingModelBox)) {
    await Hive.openBox(AppConstant.settingModelBox); // 일반 키-값 설정용(Repository)
  }
  if (!Hive.isBoxOpen('userBox')) {
    await Hive.openBox<UserSetting>('userBox'); // 현재 설정 1개 보관
  }
  if (!Hive.isBoxOpen('historyBox')) {
    await Hive.openBox<UserSettingHistory>(
      'historyBox',
    ); // 이력 누적 보관 ✅ (GENERIC 고침)
  }

  // 레포지토리/위젯 초기화
  SettingRepository.init();
  await HomeWidgetService.instance.init(); // AppGroup 세팅은 runApp 이전에!

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  String systemLanguage = '';
  bool isDarkMode = false;

  void _loadUserPrefs() {
    // 언어
    systemLanguage =
        SettingRepository.getString(AppConstant.settingLanguageKey) ??
        (Get.deviceLocale == null ? "ko-KR" : Get.deviceLocale.toString());

    // 다크모드 (저장값 우선, 없으면 시스템)
    final savedDark = SettingRepository.getBool(AppConstant.isDarkModeKey);
    if (savedDark != null) {
      isDarkMode = savedDark;
    } else {
      // ThemeMode.system 은 실행 컨텍스트에서 판단되므로 fallback만 둡니다.
      isDarkMode =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUserPrefs();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quit Mate',

      // 라우팅
      getPages: [
        GetPage(name: SplashScreen.name, page: () => SplashScreen()),
        GetPage(name: HomeScreen.name, page: () => HomeScreen()),
        GetPage(name: UserSettingScreen.name, page: () => UserSettingScreen()),
      ],
      initialRoute: SplashScreen.name,

      // 전역 바인딩 (UserSettingController 영구 등록)
      initialBinding: BindingsBuilder.put(
        () => UserSettingController(),
        permanent: true,
      ),

      // 로케일/번역
      fallbackLocale: const Locale('ko', 'KR'),
      locale: _toLocale(systemLanguage),
      translations: AppTranslations(),

      // 테마 (선택 사항)
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
      ),
    );
  }

  /// "ko-KR" 같은 문자열을 Locale로 변환
  Locale _toLocale(String code) {
    final parts = code.split(RegExp('[-_]'));
    if (parts.length == 1) return Locale(parts[0]);
    return Locale(parts[0], parts[1]);
  }
}
