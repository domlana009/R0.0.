// lib/pages/R0.dart
--- a/lib/pages/R0.dart
+++ b/lib/pages/R0.dart
@@
import 'package:flutter/material.dart';
import 'package:pointage/models/ventilation_item.dart';
  
class R0FormData {
  final String entree;
  final String secteur;
  final String rapNo;
  final String machine;
  final String sa;
  final String unite;
  final String poste;
  final List<VentilationItem> ventilation;
  final String arretsExplication;

  R0FormData({
    required this.entree,
    required this.secteur,
    required this.rapNo,
    required this.machine,
    required this.sa,
    required this.unite,
    required this.poste,
    required this.ventilation,
    required this.arretsExplication,
  });
}

class R0ReportPage extends StatefulWidget {
  final DateTime selectedDate;
  final String? previousDayThirdShiftEnd;

  const R0ReportPage({
    required this.selectedDate,
    this.previousDayThirdShiftEnd,
    super.key
  });
  
  @override

  _R0ReportPageState createState() => _R0ReportPageState();
}

class _R0ReportPageState extends State<R0ReportPage> {
  // Form controllers
  final _entreeCtrl = TextEditingController();
  final _secteurCtrl = TextEditingController();
  final _rapNoCtrl = TextEditingController();
  final _machineCtrl = TextEditingController();
  final _saCtrl = TextEditingController();
  final _uniteCtrl = TextEditingController();
  final _arretsExplicationCtrl = TextEditingController();

  // Poste selection
  String _selectedPoste = '1er';
  static const _postes = ['1er', '2ème', '3ème'];

  // Ventilation list
  final List<VentilationItem> _ventilation = [];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _ventilation.addAll([
      VentilationItem(code: 121, label: 'ARRET CARREAU INDUSTRIEL'),
      VentilationItem(code: 122, label: 'COUPURE GENERALE DU COURANT'),
      // ... أضف بقية القوائم حسب الحاجة
    ]);
  }
  
  @override
  void dispose() {
    _entreeCtrl.dispose();    
    _secteurCtrl.dispose();    
    _rapNoCtrl.dispose();    
    _machineCtrl.dispose();    
    _saCtrl.dispose();    
    _uniteCtrl.dispose();    
    _arretsExplicationCtrl.dispose();    
    super.dispose();
  }

  void _submit() {
    // Collect data
    final formData = R0FormData(
      entree: _entreeCtrl.text,
      secteur: _secteurCtrl.text,
      rapNo: _rapNoCtrl.text,
      machine: _machineCtrl.text,
      sa: _saCtrl.text,
      unite: _uniteCtrl.text,
      poste: _selectedPoste,
      ventilation: _ventilation,
      arretsExplication: _arretsExplicationCtrl.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('التقرير مُرسل بنجاح')));
    }
  }


  
  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';
    return Scaffold(
      appBar: AppBar(title: Text('R0 Report — $dateStr')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),       
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(controller: _entreeCtrl, label: 'Entrée'),              
              _buildTextField(controller: _secteurCtrl, label: 'Secteur'),              
              _buildTextField(controller: _rapNoCtrl, label: 'Rapport No'),              
              _buildTextField(controller: _machineCtrl, label: 'Machine/Engins'),              
              _buildTextField(controller: _saCtrl, label: 'SA'),              
              _buildTextField(controller: _uniteCtrl, label: 'Unité'),              
              const SizedBox(height: 16),
              _buildPosteSelector(),              
              _buildVentilationTable(),              
              const SizedBox(height: 16),
              _buildTextField(controller: _arretsExplicationCtrl, label: 'Explication Arrêts', maxLines: 3),
              const SizedBox(height: 24),
              // Bouton de soumission              
              Center(
                child: ElevatedButton(onPressed: _submit, child: const Text('Soumettre R0 Report')),
              ),
            ],
          ),
        ),        
      ),
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
      validator: (value) => value!.isEmpty ? 'مطلوب' : null,
    );
  }

  Widget _buildPosteSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Poste', style: Theme.of(context).textTheme.titleMedium),
        Row(
          children: _postes.map((poste) {
            return Expanded(
              child: RadioListTile<String>(
                title: Text(poste),
                value: poste,
                groupValue: _selectedPoste,
                onChanged: (v) => setState(() => _selectedPoste = v!),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildVentilationTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ventilation', style: Theme.of(context).textTheme.titleMedium),
        DataTable(
          columns: const [
            DataColumn(label: Text('Code')),
            DataColumn(label: Text('Label')),
            DataColumn(label: Text('Durée')),
            DataColumn(label: Text('Note')),
          ],
          rows: _ventilation.map((item) {
            return DataRow(cells: [
              DataCell(Text('${item.code}')),
              DataCell(Text(item.label)),
              DataCell(
                SizedBox(
                  width: 60,
                  child: TextField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (v) => item.duree = v,
                  ),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (v) => item.note = v,
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ],
    );
  }
}
            ),
          );
        }).toList(),
      ),
      SizedBox(height: 16),
    ],
  );
}

Widget _buildVentilationTable() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Ventilation', style: Theme.of(context).textTheme.subtitle1),
      DataTable(
        columns: const [
          DataColumn(label: Text('Code')),
          DataColumn(label: Text('Label')),
          DataColumn(label: Text('Durée')),
          DataColumn(label: Text('Note')),
        ],
        rows: _ventilation.map((item) {
          final idx = _ventilation.indexOf(item);
          return DataRow(cells: [
            DataCell(Text('${item.code}')),
            DataCell(Text(item.label)),
            DataCell(
              SizedBox(
                width: 60,
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                  onChanged: (v) => item.duree = v,
                ),
              ),
            ),
            DataCell(
              SizedBox(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(border: InputBorder.none),
                  onChanged: (v) => item.note = v,
                ),
              ),
            ),
          ]);
        }).toList(),
      ),
    ],
  );
}