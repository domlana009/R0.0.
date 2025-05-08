class DailyReport {
  final DateTime date;
  final int totalStopsMinutes;
  final int totalVibratorCounter;
  final int totalLiaisonCounter;
  final int totalStockQuantity;

  DailyReport({
    required this.date,
    required this.totalStopsMinutes,
    required this.totalVibratorCounter,
    required this.totalLiaisonCounter,
    required this.totalStockQuantity,
  });
}