// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmVYKxXFt81kfJf-L5Pb9I4v8ahrK3_cU',
    appId: '1:1022887170143:web:1e2b867907f2f83cc58bea',
    messagingSenderId: '1022887170143',
    projectId: 'vn-history-chat',
    authDomain: 'vn-history-chat.firebaseapp.com',
    storageBucket: 'vn-history-chat.firebasestorage.app',
    measurementId: 'G-5SHB5EKF7T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwSp2dvQ4WqwQeMSCysSGjYmxRLHiL6i8',
    appId: '1:1022887170143:android:20f600fa40d7ee35c58bea',
    messagingSenderId: '1022887170143',
    projectId: 'vn-history-chat',
    storageBucket: 'vn-history-chat.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBO9glDe2l-ANBkgTwbudctpCRFKIfPyvk',
    appId: '1:1022887170143:ios:06e21700d9923021c58bea',
    messagingSenderId: '1022887170143',
    projectId: 'vn-history-chat',
    storageBucket: 'vn-history-chat.firebasestorage.app',
    androidClientId: '1022887170143-729djo1vscrliqj9unhb0a55odh9prsu.apps.googleusercontent.com',
    iosClientId: '1022887170143-bch9hcib7aqkrf96bn96kumqn14p1mr2.apps.googleusercontent.com',
    iosBundleId: 'com.example.vietnamHistory',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBO9glDe2l-ANBkgTwbudctpCRFKIfPyvk',
    appId: '1:1022887170143:ios:06e21700d9923021c58bea',
    messagingSenderId: '1022887170143',
    projectId: 'vn-history-chat',
    storageBucket: 'vn-history-chat.firebasestorage.app',
    androidClientId: '1022887170143-729djo1vscrliqj9unhb0a55odh9prsu.apps.googleusercontent.com',
    iosClientId: '1022887170143-bch9hcib7aqkrf96bn96kumqn14p1mr2.apps.googleusercontent.com',
    iosBundleId: 'com.example.vietnamHistory',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAmVYKxXFt81kfJf-L5Pb9I4v8ahrK3_cU',
    appId: '1:1022887170143:web:364129b03ba81850c58bea',
    messagingSenderId: '1022887170143',
    projectId: 'vn-history-chat',
    authDomain: 'vn-history-chat.firebaseapp.com',
    storageBucket: 'vn-history-chat.firebasestorage.app',
    measurementId: 'G-MLEHT8RHPS',
  );
}
