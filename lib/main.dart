import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socially/firebase_options.dart';
import 'package:socially/router/router.dart';
import 'package:socially/views/responsive/mobile_screen_layout.dart';
import 'package:socially/views/responsive/responsive_layout.dart';
import 'package:socially/views/responsive/web_screen_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Socially',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: RouterClass().router,
    );
  }
}
