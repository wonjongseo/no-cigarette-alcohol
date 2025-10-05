import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'ja_JP': {
      AppString.appName: AppString.appNameJp,
      AppString.cntCigPerBuyOne: AppString.cntCigPerBuyOneJp,
      AppString.price: AppString.priceJp,
      AppString.sum: AppString.sumJp,
      AppString.currency: AppString.currencyJp,
      AppString.day: AppString.dayJp,
      AppString.days: AppString.daysJp,
      AppString.cigratette: AppString.cigratetteJp,
      AppString.alcohol: AppString.alcoholJp,
      AppString.save: AppString.saveJp,
      AppString.edit: AppString.editJp,
      AppString.changeAmount: AppString.changeAmountJp,
    },
    'ko_KR': {
      AppString.appName: AppString.appNameKr,
      AppString.cntCigPerBuyOne: AppString.cntCigPerBuyOneKr,
      AppString.price: AppString.priceKr,
      AppString.sum: AppString.sumKr,
      AppString.currency: AppString.currencyKr,
      AppString.day: AppString.dayKr,
      AppString.days: AppString.daysKr,
      AppString.cigratette: AppString.cigratetteKr,
      AppString.alcohol: AppString.alcoholKr,
      AppString.save: AppString.saveKr,
      AppString.edit: AppString.editKr,
      AppString.changeAmount: AppString.changeAmountKr,
    },
  };
}

class AppString {
  static String appName = "appNameTr";
  static String appNameKr = "깨끗한날";
  static String appNameJp = "やめとも";
  static String appNameEn = "QuitMate";

  static String cntCigPerBuyOne = "cntCigPerBuyOneTr";
  static String cntCigPerBuyOneKr = "구매 주기";
  static String cntCigPerBuyOneJp = "購買周期";
  static String cntCigPerBuyOneEn = "종각 TOPIK";

  static String price = "priceTr";
  static String priceKr = "가격";
  static String priceJp = "価格";
  static String priceEn = "종각 TOPIK";

  static String sum = "sumTr";
  static String sumKr = "합계";
  static String sumJp = "合計";
  static String sumEn = "Sum";

  static String currency = "currencyTr";
  static String currencyKr = "₩";
  static String currencyJp = "¥";
  static String currencyEn = "\$";

  static String day = "dayTr";
  static String dayKr = "일";
  static String dayJp = "日";
  static String dayEn = "day";

  static String days = "daysTr";
  static String daysKr = "일째";
  static String daysJp = "日目";
  static String daysEn = "Day";

  static String cigratette = "cigratetteTr";
  static String cigratetteKr = "담배";
  static String cigratetteJp = "タバコ";
  static String cigratetteEn = "cigratette";

  static String alcohol = "alcoholTr";
  static String alcoholKr = "술";
  static String alcoholJp = "酒";
  static String alcoholEn = "Alcohol";

  static String save = "saveTr";
  static String saveKr = "저장";
  static String saveJp = "保存";
  static String saveEn = "Save";

  static String edit = "editTr";
  static String editKr = "변경";
  static String editJp = "変更";
  static String editEn = "Edit";

  static String changeAmount = "changeAmountTr";
  static String changeAmountKr = "금액 변겅";
  static String changeAmountJp = "金額変更";
  static String changeAmountEn = "Change Prices";
}
