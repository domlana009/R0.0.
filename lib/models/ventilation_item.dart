class VentilationItem {
  final int code;
  final String label;
  String duree;
  String note;

  VentilationItem({
    required this.code,
    required this.label,
    this.duree = '',
    this.note = '',
  });
}