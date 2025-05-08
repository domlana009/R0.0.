import 'package:flutter/material.dart';
import 'package:myapp/models/report_model.dart';
import 'package:myapp/pages/add_report_page.dart';
import 'package:myapp/services/report_service.dart';
import 'package:myapp/pages/details_page.dart' as details;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddReportPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Report>>(
        stream: ReportService().getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد بيانات'));
          }
          final List<Report> reports = snapshot.data!;
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final report = reports[i];
              return Dismissible(
                key: Key(report.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) {
                  ReportService().deleteReport(report.id);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  child: ListTile(
                    title: Text(report.title),
                    subtitle: Text('${report.type} - ${report.date.toLocal().toString().substring(0, 10)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => details.DetailsPage(report: report))

                      );
                    },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
