import 'package:home_widget/home_widget.dart';

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

  Future<void> saveInitial({
    required DateTime startDate,
    required double cigDaily,
    required double drinkDaily,
    required String currency,
  }) async {
    await HomeWidget.saveWidgetData<String>(
      'start_date_iso',
      startDate.toIso8601String(),
    );
    await HomeWidget.saveWidgetData<double>('cig_daily', cigDaily);
    await HomeWidget.saveWidgetData<double>('drink_daily', drinkDaily);
    await HomeWidget.saveWidgetData<String>('currency', currency);

    await HomeWidget.updateWidget(iOSName: HWIds.iOSWidgetKind);
  }
}
