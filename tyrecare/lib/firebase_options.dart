// Generated-style Firebase configuration for TyreCare.
// Keep this file versioned: Firebase web configuration is public client config,
// while access to data is protected by Firebase Authentication and rules.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'Firebase options are not configured for $defaultTargetPlatform. '
          'Run "flutterfire configure" to add this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBgLbRsJjoEeIrn5erPVKcucc5RPSj7V6g',
    appId: '1:308418932482:web:01f564ef2e870bf8325c1b',
    messagingSenderId: '308418932482',
    projectId: 'tyrecare-2fe9a',
    authDomain: 'tyrecare-2fe9a.firebaseapp.com',
    storageBucket: 'tyrecare-2fe9a.firebasestorage.app',
    measurementId: 'G-6PLR0FF5V3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVG2xixBmt_EQjrIsmAbIexl9RTKc43DA',
    appId: '1:308418932482:android:a011ba1480ee4b94325c1b',
    messagingSenderId: '308418932482',
    projectId: 'tyrecare-2fe9a',
    storageBucket: 'tyrecare-2fe9a.firebasestorage.app',
  );
}
