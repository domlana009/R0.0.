import 'package:flutter/material.dart';
import 'activity_report_page.dart';
import 'package:pointage/utils/time_utils.dart';
import 'package:pointage/models/daily_report.dart';
import '../utils/time_utils.dart';
import '../models/daily_report.dart';

class DailyReportPage extends StatelessWidget {
  final DailyReport report;

  const DailyReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final formattedDate = '${report.date.day}/${report.date.month}/${report.date.year}';
    return Scaffold(
      appBar: AppBar(title: Text('Rapport quotidien - $formattedDate')),
      body:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: const Text('Temps total d\'arrêt'),
                trailing: Text(formatMinutesToHoursMinutes(report.totalStopsMinutes)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Compteur Vibrateur'),
                trailing: Text('${report.totalVibratorCounter} unités'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Compteur Liaison'),
                trailing: Text('${report.totalLiaisonCounter} unités'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Quantité Stock'),
                trailing: Text('${report.totalStockQuantity}'),
              ),
            ),
           const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: const Text('Voir détails'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ActivityReportPage(
                        selectedDate: report.date,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}