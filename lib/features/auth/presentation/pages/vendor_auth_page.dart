/*
Auth Page - This page determines whether to show the login or register page
*/

import 'package:flutter/material.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_register_page.dart';

// Define an enum for the page state
enum VendorAuthPageState {
  vendorLogin,
  vendorRegister,
  register,
}

class VendorAuthPage extends StatefulWidget {
  final VoidCallback switchToUserApp;

  const VendorAuthPage({super.key, required this.switchToUserApp});

  @override
  State<VendorAuthPage> createState() => _VendorAuthPageState();
}

class _VendorAuthPageState extends State<VendorAuthPage> {
  // Track the current page state
  VendorAuthPageState currentPage = VendorAuthPageState.vendorRegister;

  // Navigate to vendor login page
  void showVendorLoginPage() {
    setState(() {
      currentPage = VendorAuthPageState.vendorLogin;
    });
  }

  // Navigate to suer register page
  void showRegisterPage() {
    widget.switchToUserApp();
  }

  // Navigate to vendor register page
  void showVendorRegisterPage() {
    setState(() {
      currentPage = VendorAuthPageState.vendorRegister;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case VendorAuthPageState.vendorLogin:
        return VendorLoginPage(
          showVendorRegisterPage: showVendorRegisterPage,
        );
      case VendorAuthPageState.vendorRegister:
        return VendorRegisterPage(
          showVendorLoginPage: showVendorLoginPage,
          showRegisterPage: showRegisterPage,
        );
      default:
        return Container(); // shouldn't be reached
    }
  }
}
