import 'package:hive/hive.dart';

part 'user_setting.g.dart';

@HiveType(typeId: 0)
class UserSetting extends HiveObject {
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  double cigDaily;

  @HiveField(2)
  double drinkDaily;

  @HiveField(3)
  String currency;

  UserSetting({
    required this.startDate,
    required this.cigDaily,
    required this.drinkDaily,
    this.currency = '₩',
  });
}
