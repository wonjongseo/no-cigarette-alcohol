import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:no_cigarette_alcohol/controllers/user_setting_controller.dart';
import 'package:no_cigarette_alcohol/core/utils/app_translations.dart';
import 'package:no_cigarette_alcohol/core/widgets/custom_button.dart';
import 'package:no_cigarette_alcohol/core/widgets/custom_text_form_field.dart';

class UserSettingScreen extends GetView<UserSettingController> {
  static String name = '/user-setting';
  const UserSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              ProductInput(
                label: AppString.cigratette.tr,
                dayTec: controller.cigDayTec,
                priceTec: controller.cigPriceTec,
                currencyType: controller.cigCurrenct,
                onChange: (v) => controller.onChangeCurrency(false, v),
              ),
              SizedBox(height: 12),
              ProductInput(
                label: AppString.alcohol.tr,
                dayTec: controller.alcDayTec,
                priceTec: controller.alcPriceTec,
                currencyType: controller.alcCurrenct,
                onChange: (v) => controller.onChangeCurrency(true, v),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomBtn(label: AppString.save.tr, onTap: () => controller.save()),
          ],
        ),
      ),
    );
  }
}

class ProductInput extends StatelessWidget {
  const ProductInput({
    super.key,
    required this.label,
    required this.dayTec,
    required this.priceTec,
    required this.currencyType,
    required this.onChange,
  });

  final String label;
  final Rx<CurrencyType> currencyType;
  final Function(CurrencyType?) onChange;
  final TextEditingController dayTec;
  final TextEditingController priceTec;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextFormField(
                hintText: AppString.cntCigPerBuyOne.tr,
                sufficIcon: Text(AppString.day.tr),
                controller: dayTec,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Obx(
                () => CustomTextFormField(
                  hintText: AppString.price.tr,
                  sufficIcon: DropdownButton2(
                    underline: SizedBox(),
                    value: currencyType.value,
                    onChanged: onChange,
                    items: List.generate(CurrencyType.values.length, (i) {
                      final type = CurrencyType.values[i];
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.label, style: TextStyle(fontSize: 12)),
                      );
                    }),
                  ),
                  controller: priceTec,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
