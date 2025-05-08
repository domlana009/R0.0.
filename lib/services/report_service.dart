import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/report_model.dart';
 
class ReportService {
  final FirebaseFirestore _db;

  ReportService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  final String collectionPath = 'reports';

  // Add a new report
  Future<void> addReport(Report report) async {    
    final docRef = await _db.collection(collectionPath).add({
      'title': report.title,
      'description': report.description,
      'type': report.type,
      'date': report.date,
    });
    await _db.collection(collectionPath).doc(docRef.id).update({'id': docRef.id});

  }

  // Get all reports
  Stream<List<Report>> getReports() {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        print(doc.data());
        return Report(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          type: doc['type'],
          date: (doc['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  // Get report by Id
  Future<Report> getReportById(String id) async {
    final doc = await _db.collection(collectionPath).doc(id).get();

    if (!doc.exists) {
      throw Exception('Report with id $id not found');
    }

    return Report(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      type: doc['type'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }
  // Update an existing report
  Future<void> updateReport(Report report) async {
    await _db.collection(collectionPath).doc(report.id).update({
      'title': report.title,
      'description': report.description,
      'type': report.type,
      'date': report.date,
    });
  }

  // Delete a report
  Future<void> deleteReport(String reportId) async {
    await _db.collection(collectionPath).doc(reportId).delete();
  }
}

