import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:no_cigarette_alcohol/core/utils/snackbar_helper.dart';
import 'package:no_cigarette_alcohol/models/user_setting.dart';
import 'package:no_cigarette_alcohol/models/user_setting_history.dart';
import 'package:no_cigarette_alcohol/screens/home/home_screen.dart';
import 'package:no_cigarette_alcohol/services/home_widget_service.dart';
import 'package:no_cigarette_alcohol/services/savings_service.dart';

enum CurrencyType {
  won("₩"),
  enn("¥"),
  dol("\$");

  final String label;
  const CurrencyType(this.label);
}

class UserSettingController extends GetxController {
  static UserSettingController get to => Get.find<UserSettingController>();

  final userSetting = Rxn<UserSetting>();
  final box = Hive.box<UserSetting>('userBox');

  late TextEditingController cigDayTec;
  late TextEditingController cigPriceTec;
  late Rx<CurrencyType> cigCurrenct;
  late TextEditingController alcDayTec;
  late TextEditingController alcPriceTec;
  late Rx<CurrencyType> alcCurrenct;

  @override
  void onInit() {
    _loadUserSetting();

    cigDayTec = TextEditingController();
    cigPriceTec = TextEditingController();
    cigCurrenct = CurrencyType.won.obs;
    alcDayTec = TextEditingController();
    alcPriceTec = TextEditingController();
    alcCurrenct = CurrencyType.won.obs;

    final s = userSetting.value;
    if (s != null) {
      alcDayTec.text = s.alcDay.toString();
      alcPriceTec.text = s.alcPrice.toString();
      cigDayTec.text = s.cigDay.toString();
      cigPriceTec.text = s.cigPrice.toString();
    }

    super.onInit();
  }

  @override
  void onReady() {
    userSetting.refresh(); // Rx 강제 업데이트
    super.onReady();
  }

  @override
  void onClose() {
    cigDayTec.dispose();
    cigPriceTec.dispose();
    alcDayTec.dispose();
    alcPriceTec.dispose();
    super.onClose();
  }

  void _loadUserSetting() {
    if (box.isNotEmpty) {
      userSetting.value = box.get(0);
    }
  }

  void onChangeCurrency(bool isAlc, CurrencyType? type) {
    if (type == null) return;
    if (isAlc) {
      alcCurrenct.value = type;
    } else {
      cigCurrenct.value = type;
    }
  }

  /// ✅ 금액/주기 저장 + 이력 추가 + HomeWidget 갱신
  Future<void> save() async {
    try {
      final now = DateTime.now();
      final cigPrice = double.tryParse(cigPriceTec.text) ?? 0;
      final alcPrice = double.tryParse(alcPriceTec.text) ?? 0;
      final cigDay = (int.tryParse(cigDayTec.text) ?? 1).clamp(1, 999);
      final alcDay = (int.tryParse(alcDayTec.text) ?? 1).clamp(1, 999);

      final historyBox = Hive.box<UserSettingHistory>('historyBox');

      // 🔹 기존 히스토리 닫기
      if (historyBox.isNotEmpty) {
        final last = historyBox.values.last;
        if (last.endDate == null) {
          last.endDate = now;
          await last.save();
        }
      }

      // 🔹 새 이력 추가
      final newHistory = UserSettingHistory(
        startDate: now,
        cigPrice: cigPrice,
        alcPrice: alcPrice,
        cigCurrency: cigCurrenct.value.label,
        alcCurrency: alcCurrenct.value.label,
        cigDay: cigDay,
        alcDay: alcDay,
      );
      await historyBox.add(newHistory);

      // 🔹 현재 설정 갱신 (userBox)
      final data = UserSetting(
        startDate: newHistory.startDate,
        cigPrice: cigPrice,
        alcPrice: alcPrice,
        cigCurrency: newHistory.cigCurrency,
        alcCurrency: newHistory.alcCurrency,
        cigDay: cigDay,
        alcDay: alcDay,
      );

      await box.clear();
      await box.add(data);
      userSetting.value = data;

      // ✅ 이력 전체 기반 절약 금액 재계산
      final histories = historyBox.values.toList();
      final r = SavingsService.compute(histories);

      // ✅ Home Widget에 최신 합계 저장
      await HomeWidgetService.instance.init();
      await HomeWidgetService.instance.saveCalculatedResult(
        days: r.days,
        cigTotal: r.cigTotal,
        alcTotal: r.alcTotal,
        sumTotal: r.total,
        cigCurrency: r.cigCurrency,
        alcCurrency: r.alcCurrency,
      );

      Get.offAllNamed(HomeScreen.name);
    } catch (e, st) {
      debugPrint('save() error: $e\n$st');
      SnackBarHelper.showErrorSnackBar("$e");
    }
  }
}
