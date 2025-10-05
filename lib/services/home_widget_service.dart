import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:no_cigarette_alcohol/core/utils/app_translations.dart';
import 'package:no_cigarette_alcohol/models/user_setting.dart';
// (이력 기반 계산이면) import 'user_setting_history.dart' + SavingsService.compute(histories)

class HWIds {
  static const appGroupId = 'group.com.wonjongseo.no-cigarette-alcohol';
  static const iOSWidgetKind = 'MyHomeWidget';
}

class HomeWidgetService {
  HomeWidgetService._();
  static final instance = HomeWidgetService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await HomeWidget.setAppGroupId(HWIds.appGroupId);
    _initialized = true;
  }

  /// 단순 강제 리프레시
  Future<void> updateOnly() async {
    await HomeWidget.updateWidget(
      iOSName: HWIds.iOSWidgetKind,
      // androidName: 'YourAndroidWidgetClass', // 안드로이드 위젯 클래스명으로 교체
    );
  }

  /// ✅ 현재 UserSetting(또는 히스토리 합산 결과)로 계산해서 위젯에 내려보냄
  Future<void> saveCalculatedResult({
    required int days,
    required double cigTotal,
    required double alcTotal,
    double? sumTotal,
    required String cigCurrency,
    required String alcCurrency,
  }) async {
    // 라벨
    await HomeWidget.saveWidgetData<String>("cig", AppString.cigratette.tr);
    await HomeWidget.saveWidgetData<String>("alc", AppString.alcohol.tr);
    await HomeWidget.saveWidgetData<String>("day", AppString.days.tr);
    await HomeWidget.saveWidgetData<String>("sum", AppString.sum.tr);

    // 값
    await HomeWidget.saveWidgetData<int>('days', days);
    await HomeWidget.saveWidgetData<double>('cig_total', cigTotal);
    await HomeWidget.saveWidgetData<double>('alc_total', alcTotal);

    // 합계 키 정리(통화 다르면 이전 값 제거)
    if (sumTotal != null) {
      await HomeWidget.saveWidgetData<double>('sum_total', sumTotal);
    } else {
      await HomeWidget.saveWidgetData<double?>('sum_total', null); // 키 제거
    }

    await HomeWidget.saveWidgetData<String>('cig_currency', cigCurrency);
    await HomeWidget.saveWidgetData<String>('alc_currency', alcCurrency);

    await HomeWidget.updateWidget(iOSName: HWIds.iOSWidgetKind);
  }

  /// 기존 단가/시작일 방식으로 계산해서 저장하고 싶다면(히스토리 없이)
  Future<void> saveFromUserSetting({
    required DateTime now,
    required UserSetting setting,
  }) async {
    // 일수(자정 기준)
    final start = DateTime(
      setting.startDate.year,
      setting.startDate.month,
      setting.startDate.day,
    );
    final ref = DateTime(now.year, now.month, now.day);
    final days = ref.difference(start).inDays.clamp(0, 1000000);

    final cigPerDay = setting.cigPrivePerDay;
    final alcPerDay = setting.alcPrivePerDay;
    final cigTotal = cigPerDay * days;
    final alcTotal = alcPerDay * days;

    double? sumTotal;
    if (setting.cigCurrency == setting.alcCurrency) {
      sumTotal = cigTotal + alcTotal;
    }

    await saveCalculatedResult(
      days: days,
      cigTotal: cigTotal,
      alcTotal: alcTotal,
      sumTotal: sumTotal,
      cigCurrency: setting.cigCurrency,
      alcCurrency: setting.alcCurrency,
    );
  }
}
