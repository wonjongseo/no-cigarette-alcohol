import 'dart:convert';

import 'package:hive/hive.dart';

part 'user_setting.g.dart';

@HiveType(typeId: 0)
class UserSetting extends HiveObject {
  @HiveField(0)
  DateTime startDate; // 금연/금주 시작일

  @HiveField(1)
  double cigPrice; // 담배 가격

  @HiveField(2)
  double alcPrice; // 술 가격

  @HiveField(3)
  String cigCurrency; //담배 통회

  @HiveField(4)
  String alcCurrency; //술 통화

  @HiveField(5)
  int alcDay; // 술 마시는 주기

  @HiveField(6)
  int cigDay; // 담배 사는 주기

  double get cigPrivePerDay => cigPrice / cigDay;
  double get alcPrivePerDay => alcPrice / alcDay;

  UserSetting({
    required this.startDate,
    required this.cigPrice,
    required this.alcPrice,
    required this.cigCurrency,
    required this.alcCurrency,
    required this.alcDay,
    required this.cigDay,
  });

  @override
  String toString() {
    return 'UserSetting(startDate: $startDate, cigPrice: $cigPrice, alcPrice: $alcPrice, cigCurrency: $cigCurrency, alcCurrency: $alcCurrency, alcDay: $alcDay, cigDay: $cigDay)';
  }
}
