import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../pages/details_page.dart';
 
class EditReportPage extends StatefulWidget {
  final Report report;
  const EditReportPage({super.key, required this.report});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descriptionCtrl;
  late String _type;
  late DateTime _date;
  final List<String> _reportTypes = ['Type1', 'Type2', 'Type3'];
  final _reportService = ReportService();
  @override
  void initState() {
    _titleCtrl = TextEditingController(text: widget.report.title);
    _descriptionCtrl = TextEditingController(text: widget.report.description);
    _type = widget.report.type;
    _date = widget.report.date;
    super.initState();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل التقرير'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl, const
                decoration: InputDecoration(labelText: 'العنوان'),
                validator: (v) => v!.isEmpty ? 'مطلوب' : null, 
              ),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(labelText: 'الوصف'), 
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'مطلوب' : null,
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: _reportTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v!),
                validator: (v) => v == null ? 'مطلوب' : null,
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() => _date = pickedDate);
                  }
                },
                child:  Text('التاريخ: ${_date.toLocal().toString().split(' ')[0]}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _reportService.updateReport(Report(
                        id: widget.report.id,
                        title: _titleCtrl.text,
                        description: _descriptionCtrl.text,
                        type: _type,
                        date: _date));
                   if (mounted){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DetailsPage(report: Report(id: widget.report.id, title: _titleCtrl.text, description: _descriptionCtrl.text, type: _type, date: _date))));
                    }
                  }
                },
                child: const Text('حفظ'),
              ),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ],
          ),
        ),
      ),
    );
  }
}