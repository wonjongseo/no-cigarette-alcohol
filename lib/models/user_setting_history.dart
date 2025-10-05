import 'package:hive/hive.dart';
part 'user_setting_history.g.dart';

@HiveType(typeId: 1)
class UserSettingHistory extends HiveObject {
  @HiveField(0)
  DateTime startDate;

  @HiveField(1)
  DateTime? endDate; // null이면 현재 진행중

  @HiveField(2)
  double cigPrice;

  @HiveField(3)
  double alcPrice;

  @HiveField(4)
  String cigCurrency;

  @HiveField(5)
  String alcCurrency;

  @HiveField(6)
  int cigDay;

  @HiveField(7)
  int alcDay;

  UserSettingHistory({
    required this.startDate,
    required this.cigPrice,
    required this.alcPrice,
    required this.cigCurrency,
    required this.alcCurrency,
    required this.cigDay,
    required this.alcDay,
    this.endDate,
  });

  double get cigPerDay => cigPrice / cigDay;
  double get alcPerDay => alcPrice / alcDay;
}
