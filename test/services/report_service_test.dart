import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/report_service.dart';
import 'package:mockito/mockito.dart';

class MockCollectionRef extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late ReportService service;
  late MockFirebaseFirestore mockDb;
  late MockCollectionRef mockCol;

  setUp(() {
    mockDb = MockFirebaseFirestore();
    mockCol = MockCollectionRef();
    when(mockDb.collection('daily_reports')).thenReturn(mockCol);
    service = ReportService(db: mockDb);
  });

  test('addReport calls Firestore add', () async {
    when(mockCol.add(any)).thenAnswer((_) async => MockDocumentReference());
    await service.addReport('uid', 'T', 'C');
    verify(
      mockCol.add(
        argThat(
          allOf(
            containsPair('userId', 'uid'),
            containsPair('title', 'T'),
            containsPair('content', 'C'),
            contains('timestamp'),
          ),
        ),
      ),
    ).called(1);
  });

  test('getUserReports returns stream', () {
    final stream = service.getUserReports('uid');
    expect(stream, isA<Stream<QuerySnapshot>>());
  });
}
