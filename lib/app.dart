import 'package:flutter/material.dart';
import 'package:mobile_app/user_app.dart';
import 'package:mobile_app/vendor_app.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  bool isVendorApp = false;

  // Switch to VendorApp
  void switchToVendorApp() {
    setState(() {
      isVendorApp = true;
    });
  }

  // Switch back to MyApp
  void switchToUserApp() {
    setState(() {
      isVendorApp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isVendorApp) {
      return VendorApp(switchToUserApp: switchToUserApp); // Pass callback
    } else {
      return UserApp(switchToVendorApp: switchToVendorApp); // Pass callback
    }
  }
}
