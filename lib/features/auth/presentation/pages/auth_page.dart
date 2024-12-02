/*
Auth Page - This page determines whether to show the login or register page
*/

import 'package:flutter/material.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/register_page.dart';

// Define an enum for the page state
enum AuthPageState {
  login,
  register,
  vendorRegister,
}

class AuthPage extends StatefulWidget {
  final VoidCallback switchToVendorApp;

  const AuthPage({super.key, required this.switchToVendorApp});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Track the current page state
  AuthPageState currentPage = AuthPageState.login;

  // Navigate to login page
  void showLoginPage() {
    setState(() {
      currentPage = AuthPageState.login;
    });
  }

  // Navigate to register page
  void showRegisterPage() {
    setState(() {
      currentPage = AuthPageState.register;
    });
  }

  // Navigate to vendor register page
  void showVendorRegisterPage() {
    widget.switchToVendorApp();
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPageState.login:
        return LoginPage(
          showRegisterPage: showRegisterPage,
        );
      case AuthPageState.register:
        return RegisterPage(
          showLoginPage: showLoginPage,
          showVendorRegisterPage: showVendorRegisterPage,
        );
      default:
        return Container(); // shouldn't be reached
    }
  }
}
