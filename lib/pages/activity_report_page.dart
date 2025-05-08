import 'package:flutter/material.dart';

class ActivityReportPage extends StatefulWidget {
  final DateTime selectedDate;
  const ActivityReportPage({super.key, required this.selectedDate});

  @override
  State<ActivityReportPage> createState() => _ActivityReportPageState();
}

class _ActivityReportPageState extends State<ActivityReportPage> {
  @override
  Widget build(BuildContext context) {
    final formattedDate = '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';
    return Scaffold(
      appBar: AppBar(title:  Text('Rapport d\'activité - $formattedDate')),
      body: const Center(child:  Text('rapport d\'activité')),
    );
  }
}

