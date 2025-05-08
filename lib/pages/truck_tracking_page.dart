import 'package:flutter/material.dart';

class TruckEntry {
  String id;
  String truckNumber;
  String driver;
  List<String> counts;
  String tSud;
  String tNord;
  String stock;
  String total;
  String hour;
  String location;

  TruckEntry({
    required this.id,
    this.truckNumber = '',
    this.driver = '',
    List<String>? counts,
    this.tSud = '',
    this.tNord = '',
    this.stock = '',
    this.total = '0',
    this.hour = '',
    this.location = '',
  }) : counts = counts ?? List.generate(15, (_) => '');
}

class TruckTrackingPage extends StatefulWidget {
  final DateTime selectedDate;

  TruckTrackingPage({required this.selectedDate});

  @override
  _TruckTrackingPageState createState() => _TruckTrackingPageState();
}

class _TruckTrackingPageState extends State<TruckTrackingPage> {
  // Poste selection
  String _selectedPoste = '1er';
  static const _postes = ['3ème', '1er', '2ème'];
  static const _posteTimes = {
    '3ème': '22:30 - 06:30',
    '1er': '06:30 - 14:30',
    '2ème': '14:30 - 22:30',
  };

  // General info
  final Map<String, String> _generalInfo = {
    'direction': '',
    'division': '',
    'oibEe': '',
    'mine': '',
    'sortie': '',
    'distance': '',
    'qualite': '',
    'machineEngins': '',
    'arretsExplication': '',
  };

  // Truck entries
  List<TruckEntry> _truckData = [];

  @override
  void initState() {
    super.initState();
    _addTruck();
  }

  void _addTruck() {
    setState(() {
      _truckData.add(TruckEntry(id: UniqueKey().toString()));
    });
  }

  void _deleteTruck(int index) {
    setState(() {
      _truckData.removeAt(index);
    });
  }

  void _updateTruckField(int index, String field, String value, [int? countIndex]) {
    final truck = _truckData[index];
    switch (field) {
      case 'truckNumber': truck.truckNumber = value; break;
      case 'driver': truck.driver = value; break;
      case 'counts':
        if (countIndex != null) truck.counts[countIndex] = value;
        break;
      case 'tSud': truck.tSud = value; break;
      case 'tNord': truck.tNord = value; break;
      case 'stock': truck.stock = value; break;
      case 'hour': truck.hour = value; break;
      case 'location': truck.location = value; break;
    }
    _recalculateTotal(truck);
  }

  void _recalculateTotal(TruckEntry truck) {
    int sum = 0;
    for (var c in truck.counts) {
      sum += int.tryParse(c) ?? 0;
    }
    sum += int.tryParse(truck.tSud) ?? 0;
    sum += int.tryParse(truck.tNord) ?? 0;
    sum += int.tryParse(truck.stock) ?? 0;
    truck.total = sum.toString();
    setState(() {});
  }

  Widget _buildGeneralInfoSection() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informations Générales', style: Theme.of(context).textTheme.headline6),
            TextField(
              decoration: InputDecoration(labelText: 'Direction'),
              onChanged: (v) => _generalInfo['direction'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Division'),
              onChanged: (v) => _generalInfo['division'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'OIB/EE'),
              onChanged: (v) => _generalInfo['oibEe'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Mine'),
              onChanged: (v) => _generalInfo['mine'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Sortie'),
              onChanged: (v) => _generalInfo['sortie'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Distance'),
              onChanged: (v) => _generalInfo['distance'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Qualité'),
              onChanged: (v) => _generalInfo['qualite'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Machine/Engins'),
              onChanged: (v) => _generalInfo['machineEngins'] = v,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Explication des Arrêts'),
              maxLines: 3,
              onChanged: (v) => _generalInfo['arretsExplication'] = v,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosteSelector() {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Poste (${_posteTimes[_selectedPoste]})', style: Theme.of(context).textTheme.headline6),
            Row(
              children: _postes.map((poste) => Expanded(
                child: RadioListTile<String>(
                  title: Text(poste),
                  value: poste,
                  groupValue: _selectedPoste,
                  onChanged: (v) => setState(() => _selectedPoste = v!),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTruckTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('N° Camion')),
          DataColumn(label: Text('Conducteur')),
          for (int i = 1; i <= 15; i++) DataColumn(label: Text(i.toString())),
          DataColumn(label: Text('T.sud')),
          DataColumn(label: Text('T.nord')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Heure')),
          DataColumn(label: Text('Lieu')),
          DataColumn(label: Text('')),
        ],
        rows: _truckData.asMap().entries.map((e) {
          final idx = e.key; final truck = e.value;
          return DataRow(cells: [
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (v) => _updateTruckField(idx, 'truckNumber', v),
            )),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (v) => _updateTruckField(idx, 'driver', v),
            )),
            ...truck.counts.asMap().entries.map((c) => DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateTruckField(idx, 'counts', v, c.key),
            ))),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateTruckField(idx, 'tSud', v),
            )),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateTruckField(idx, 'tNord', v),
            )),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              keyboardType: TextInputType.number,
              onChanged: (v) => _updateTruckField(idx, 'stock', v),
            )),
            DataCell(Text(truck.total)),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (v) => _updateTruckField(idx, 'hour', v),
            )),
            DataCell(TextField(
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (v) => _updateTruckField(idx, 'location', v),
            )),
            DataCell(IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTruck(idx),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}';
    return Scaffold(
      appBar: AppBar(title: Text('POINTAGE DES CAMIONS — $dateStr')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralInfoSection(),
            _buildPosteSelector(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tableau de Pointage', style: Theme.of(context).textTheme.headline6),
            ),
            _buildTruckTable(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Ajouter Camion'),
                onPressed: _addTruck,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(onPressed: () { /* save logic */ }, child: Text('Enregistrer')),
                  SizedBox(width: 8),
                  ElevatedButton(onPressed: () { /* submit logic */ }, child: Text('Soumettre')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}