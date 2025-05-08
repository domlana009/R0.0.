import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/report_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  late final ReportService _reportService;
  

  @override
  void initState() {
    super.initState();
    _reportService = ReportService();
  }

  void _submitReport() async {
    final title = _titleCtrl.text.trim();    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) return;    await _reportService.addReport(title, content);
    _titleCtrl.clear();    _contentCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('التقارير اليومية')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: InputDecoration(labelText: 'عنوان التقرير'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentCtrl,
              decoration: InputDecoration(labelText: 'محتوى التقرير'),
              maxLines: 3,
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text('إرسال التقرير'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _reportService.getReports(),                builder: (context, snapshot) {

                  if (snapshot.hasError) {
                    return Text('خطأ في جلب التقارير');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Text('لا توجد تقارير بعد.');
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final doc = docs[i];
                      final data = doc.data() as Map<String, dynamic>;
                      final timestamp =
                          (data['timestamp'] as Timestamp?)?.toDate();
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(data['title'] ?? ''),
                          subtitle: Text(
                            '${data['content']}\n${timestamp != null ? timestamp.toLocal().toString() : ''}',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                _reportService.deleteReport(doc.id),
                          ),
                        ),
                      );
                    },
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
