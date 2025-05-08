import 'package:flutter/material.dart';
import 'package:myapp/models/report_model.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/services/report_service.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  String? _selectedType;
  DateTime? _selectedDate;

  final List<String> _reportTypes = [
    'Type 1',
    'Type 2',
    'Type 3',
  ];

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final newReport = Report(
        id: '',
        title: _titleCtrl.text,
        description: _descriptionCtrl.text,
        type: _selectedType!,
        date: _selectedDate!,
      );
      await ReportService().addReport(newReport);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة تقرير'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'عنوان التقرير',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'عنوان التقرير مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'وصف التقرير',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'وصف التقرير مطلوب' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'نوع التقرير',
                ),
                items: _reportTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v),
                validator: (v) => v == null ? 'نوع التقرير مطلوب' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() => _selectedDate = date);
                },
                child: Text(
                    _selectedDate == null ? 'إختر التاريخ' : 'التاريخ : ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
              ),
              if (_selectedDate == null)
                TextFormField(
                  validator: (v) => _selectedDate == null ? 'التاريخ مطلوب' : null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _submitReport,
                    child: const Text('حفظ'),
                  ),
                  ElevatedButton(onPressed: ()=> Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  ), child: const Text("إلغاء"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
