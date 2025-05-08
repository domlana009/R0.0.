int parseDurationToMinutes(String duration) {
  if (duration.isEmpty) return 0;
  final cleaned = duration.replaceAll(RegExp(r'[^0-9Hh:s]'), '').trim();
  final parts = cleaned.split(RegExp(r'[Hh:s]+')).where((p) => p.isNotEmpty).toList();
  int hours = 0, minutes = 0;
  if (parts.length == 2) {
    hours = int.tryParse(parts[0]) ?? 0;
    minutes = int.tryParse(parts[1]) ?? 0;
  } else if (parts.length == 1 && cleaned.contains(RegExp(r'[Hh]'))) {
    hours = int.tryParse(parts[0]) ?? 0;
  } else if (parts.length == 1) {
    minutes = int.tryParse(parts[0]) ?? 0;
  }
  return hours * 60 + minutes;
}

String formatMinutesToHoursMinutes(int totalMinutes) {
  if (totalMinutes <= 0) return '0h 0m';
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return '${hours}h ${minutes}m';
}