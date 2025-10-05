import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:no_cigarette_alcohol/services/home_widget_service.dart';
import '../models/user_setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final cigController = TextEditingController();
  final drinkController = TextEditingController();
  String currency = '₩';
  UserSetting? setting;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<UserSetting>('userBox');
    if (box.isNotEmpty) setting = box.getAt(0);
    if (setting != null) {
      cigController.text = setting!.cigDaily.toString();
      drinkController.text = setting!.drinkDaily.toString();
    }
  }

  Future<void> _save() async {
    final cig = double.tryParse(cigController.text) ?? 0;
    final drink = double.tryParse(drinkController.text) ?? 0;
    final start = setting?.startDate ?? DateTime.now();

    final box = Hive.box<UserSetting>('userBox');
    final data = UserSetting(
      startDate: start,
      cigDaily: cig,
      drinkDaily: drink,
      currency: currency,
    );

    await box.clear();
    await box.add(data);

    // home_widget에도 저장
    await HomeWidgetService.instance.saveInitial(
      startDate: start,
      cigDaily: cig,
      drinkDaily: drink,
      currency: currency,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('저장 완료! 위젯이 갱신됩니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('금연·금주 설정')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: cigController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '하루 담배값 (₩)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: drinkController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '하루 술값 (₩)'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: currency,
              items: const [
                DropdownMenuItem(value: '₩', child: Text('₩ (원)')),
                DropdownMenuItem(value: '¥', child: Text('¥ (엔)')),
                DropdownMenuItem(value: '\$', child: Text('\$ (달러)')),
              ],
              onChanged: (v) => setState(() => currency = v!),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
