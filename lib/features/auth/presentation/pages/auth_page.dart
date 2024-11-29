import 'package:flutter/widgets.dart';
import 'package:mobile_app/features/auth/presentation/pages/login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/register_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_login_page.dart';
import 'package:mobile_app/features/auth/presentation/pages/vendor_register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

// enum to manage page states
enum AuthPageType { login, register, vendorLogin, vendorRegister }

class _AuthPageState extends State<AuthPage> {
  // track the current page
  AuthPageType currentPage = AuthPageType.login;

  // switch pages
  void switchPage(AuthPageType page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPage) {
      case AuthPageType.register:
        return RegisterPage(
          togglePages: (page) => switchPage(page),
        );
      case AuthPageType.vendorLogin:
        return VendorLoginPage(
          togglePages: (page) => switchPage(page),
        );
      case AuthPageType.vendorRegister:
        return VendorRegisterPage(
          togglePages: (page) => switchPage(page),
        );
      case AuthPageType.login:
      default:
        return LoginPage(
          togglePages: (page) => switchPage(page),
        );
    }
  }
}
