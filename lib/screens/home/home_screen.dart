import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:no_cigarette_alcohol/controllers/user_setting_controller.dart';
import 'package:no_cigarette_alcohol/core/utils/app_translations.dart';
import 'package:no_cigarette_alcohol/core/widgets/custom_button.dart';
import 'package:no_cigarette_alcohol/models/user_setting_history.dart';
import 'package:no_cigarette_alcohol/screens/user_setting/setting_screen.dart';
import 'package:no_cigarette_alcohol/services/savings_service.dart';
import 'package:no_cigarette_alcohol/services/home_widget_service.dart';

class HomeScreen extends GetView<UserSettingController> {
  static String name = '/home';
  const HomeScreen({super.key});

  String _format(double v) {
    // 소수점 없이 천단위 콤마
    final nf = NumberFormat('#,###');
    if (v.isNaN || v.isInfinite) return '0';
    return nf.format(v.round());
  }

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<UserSettingHistory>('historyBox');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.appName.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // 아직 시작 정보가 없으면 비워두기
          final s = controller.userSetting.value;
          if (s == null) {
            return _Empty(
              onGoSetting: () => Get.offAllNamed(UserSettingScreen.name),
            );
          }

          // ✅ historyBox 변경에 자동 반응
          return ValueListenableBuilder<Box<UserSettingHistory>>(
            valueListenable: historyBox.listenable(),
            builder: (context, box, _) {
              final histories = box.values.toList();
              if (histories.isEmpty) {
                return _Empty(
                  onGoSetting: () => Get.offAllNamed(UserSettingScreen.name),
                );
              }

              // 누적 계산
              final r = SavingsService.compute(histories);

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppString.days.tr == 'Day'
                          ? 'Day ${r.days}'
                          : '${r.days}${AppString.days.tr}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    _Line(
                      title: AppString.cigratette.tr,
                      value: '${_format(r.cigTotal)}${r.cigCurrency}',
                    ),
                    const SizedBox(height: 8),
                    _Line(
                      title: AppString.alcohol.tr,
                      value: '${_format(r.alcTotal)}${r.alcCurrency}',
                    ),

                    if (r.total != null) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      _Line(
                        title: AppString.sum.tr,
                        value: '${_format(r.total!)}${r.cigCurrency}',
                        bold: true,
                      ),
                    ],

                    const Spacer(),

                    // 설정으로 이동
                    BottomBtn(
                      label: AppString.changeAmount.tr,
                      onTap: () => Get.toNamed(UserSettingScreen.name),
                    ),

                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final String title;
  final String value;
  final bool bold;
  const _Line({required this.title, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(
          value,
          style:
              bold
                  ? style.copyWith(fontWeight: FontWeight.w700)
                  : style.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  final VoidCallback onGoSetting;
  const _Empty({required this.onGoSetting});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('아직 시작 정보가 없어요'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onGoSetting, child: const Text('설정하러 가기')),
        ],
      ),
    );
  }
}
