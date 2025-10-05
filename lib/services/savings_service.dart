import 'package:hive/hive.dart';
import 'package:no_cigarette_alcohol/models/user_setting_history.dart';

class SavingsResult {
  final int days;
  final double cigTotal;
  final double alcTotal;
  final String cigCurrency;
  final String alcCurrency;
  final double? total;

  const SavingsResult({
    required this.days,
    required this.cigTotal,
    required this.alcTotal,
    required this.cigCurrency,
    required this.alcCurrency,
    required this.total,
  });
}

class SavingsService {
  static SavingsResult compute(List<UserSettingHistory> historyList) {
    final now = DateTime.now();

    if (historyList.isEmpty) {
      // 통화는 앱 기본값(또는 UI에서 별도 처리)으로 리턴
      return const SavingsResult(
        days: 0,
        cigTotal: 0,
        alcTotal: 0,
        cigCurrency: '₩',
        alcCurrency: '₩',
        total: null,
      );
    }

    double cigTotal = 0;
    double alcTotal = 0;
    int totalDays = 0;

    for (final h in historyList) {
      // 하루 단위 비교(자정 기준)
      final start = DateTime(
        h.startDate.year,
        h.startDate.month,
        h.startDate.day,
      );
      final rawEnd = h.endDate ?? now;
      final end = DateTime(rawEnd.year, rawEnd.month, rawEnd.day);

      // end가 start보다 과거인 잘못된 데이터 방지
      final days = (end.isBefore(start) ? 0 : end.difference(start).inDays)
          .clamp(0, 1000000);

      // 0 또는 음수 분모 방지
      final cigPerDay = (h.cigDay <= 0) ? 0 : (h.cigPrice / h.cigDay);
      final alcPerDay = (h.alcDay <= 0) ? 0 : (h.alcPrice / h.alcDay);

      cigTotal += days * cigPerDay;
      alcTotal += days * alcPerDay;
      totalDays += days;
    }

    final cigCurrency = historyList.last.cigCurrency;
    final alcCurrency = historyList.last.alcCurrency;

    double? total;
    if (cigCurrency == alcCurrency) {
      total = cigTotal + alcTotal;
    }

    return SavingsResult(
      days: totalDays,
      cigTotal: cigTotal,
      alcTotal: alcTotal,
      cigCurrency: cigCurrency,
      alcCurrency: alcCurrency,
      total: total,
    );
  }
}
