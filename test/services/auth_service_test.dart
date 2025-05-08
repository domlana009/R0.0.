import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/services/auth_service.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

@GenerateMocks([FirebaseAuth])
void main() {
  late AuthService auth;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    auth = AuthService(auth: mockAuth);
  });

  test('signIn returns User on success', () async {
    final mockCred = MockUserCredential();
    final mockUser = MockUser();
    when(mockCred.user).thenReturn(mockUser);
    when(mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com', password: 'pass'
    )).thenAnswer((_) async => mockCred);

    final result = await auth.signIn('a@b.com', 'pass');
    expect(result, isA<User>());
  });

  test('signIn returns null on error', () async {
    when(mockAuth.signInWithEmailAndPassword(
      email: 'a@b.com', password: 'wrong'
    )).thenThrow(Exception('fail'));

    final result = await auth.signIn('a@b.com', 'wrong');
    expect(result, isNull);
  });
}
