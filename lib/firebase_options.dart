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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBpqjDXtOHxpcvnl0fTfsRqgPHxCwy9CXk',
    appId: '1:963388241050:web:5d34b0f1e6d6f612b89b23',
    messagingSenderId: '963388241050',
    projectId: 'study-planner-c97ad',
    authDomain: 'study-planner-c97ad.firebaseapp.com',
    storageBucket: 'study-planner-c97ad.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAU6eViyizwaPct4DZ1YSoB5dFOPoWdODM',
    appId: '1:963388241050:android:8bbb3f6e7d3ba297b89b23',
    messagingSenderId: '963388241050',
    projectId: 'study-planner-c97ad',
    storageBucket: 'study-planner-c97ad.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBrBAEsmmtiN8owllmDGNAMGehEMSUQIhE',
    appId: '1:963388241050:ios:45fc481fa809d170b89b23',
    messagingSenderId: '963388241050',
    projectId: 'study-planner-c97ad',
    storageBucket: 'study-planner-c97ad.appspot.com',
    androidClientId: '963388241050-cbh21alncdaft4ofjll5p21s89csstpv.apps.googleusercontent.com',
    iosClientId: '963388241050-cn67884fvt85kg5ia1bbm5lg50p0ak47.apps.googleusercontent.com',
    iosBundleId: 'com.example.socially',
  );
}
