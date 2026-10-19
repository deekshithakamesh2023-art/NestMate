import 'package:firebase_core/firebase_core.dart';

abstract final class FirebaseConfig {
  static const apiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: 'AIzaSyCfN11w7dSXrKlRQOMOx5dVVbcOumxl3d0',
  );
  static const appId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '1:1020250655720:web:b6ae432a67ea338b15725d',
  );
  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '1020250655720',
  );
  static const projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'webapp-666e2',
  );
  static const authDomain = String.fromEnvironment(
    'FIREBASE_AUTH_DOMAIN',
    defaultValue: 'webapp-666e2.firebaseapp.com',
  );

  static bool get hasAnyConfiguration =>
      apiKey.isNotEmpty ||
      appId.isNotEmpty ||
      messagingSenderId.isNotEmpty ||
      projectId.isNotEmpty ||
      authDomain.isNotEmpty;

  static bool get isConfigured =>
      apiKey.isNotEmpty &&
      appId.isNotEmpty &&
      messagingSenderId.isNotEmpty &&
      projectId.isNotEmpty;

  static FirebaseOptions get options => FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
        authDomain: authDomain.isEmpty ? null : authDomain,
      );
}
