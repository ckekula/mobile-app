import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'themes/light_mode.dart';

/* 
App- root level

Repositories: for the database
  - firebase

Bloc Providers: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  - unauthenticated -> auth page (loh=gin?register)
  - authenticated -> home page

*/


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: const AuthPage(),
    );
  }
}