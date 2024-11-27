import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app.dart';
import 'package:mobile_app/features/auth/presentation/pages/auth_page.dart';
import 'package:mobile_app/firebase_options.dart';
import 'package:mobile_app/themes/light_mode.dart';



void main() async {
  // firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // run app
  runApp(const MyApp());
}


