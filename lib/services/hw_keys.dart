// lib/services/hw_keys.dart
class HWKeys {
  static const startDate = 'start_date_iso'; // e.g. 2025-10-05
  static const cigDaily = 'cig_daily'; // double (1일 담배값)
  static const drinkDaily = 'drink_daily'; // double (1일 술값)
  static const total = 'total'; // 누적 금액(표시용 캐시, Android에서 저장)
  static const currency = 'currency'; // "₩", "¥" 등
}
