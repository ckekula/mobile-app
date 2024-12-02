/*
Auth Page - This page determines whether to show the login or register page
*/

import 'package:flutter/widgets.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_register_page.dart';

class VendorAuthPage extends StatefulWidget {
  const VendorAuthPage({super.key});

  @override
  State<VendorAuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<VendorAuthPage> {
  // initially, show the login page
  bool showLoginPage = true;

  // toggle between pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return VendorLoginPage(
        togglePages: togglePages,
      );
    } else {
      return VendorRegisterPage(
        togglePages: togglePages,
      );
    }
  }
}
