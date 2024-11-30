import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/presentation/components/my_button.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';
import 'package:mobile_app/features/auth/presentation/pages/auth_page.dart';

class LoginPage extends StatefulWidget {
  final void Function(AuthPageType) togglePages;

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  /* 
  Handle the login button press event.
  
  Gets email and password from the [TextEditingController]s, checks if
  they are not empty, and calls [AuthCubit.login] to attempt login.
  If fields are empty,display an error message using [ScaffoldMessenger].
  */
  void login() {
    // prepare email & password
    final String email = emailController.text.trim();
    final String password = pwController.text.trim();

    // auth cubit
    final authCubit = context.read<AuthCubit<AppUser>>();

    // ensure fields are not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    }

    // display error some fields are empty
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields!"),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // BODY
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 50),

                // welcome back message
                Text(
                  "Welcome back, you've been missed!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: pwController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // login button
                MyButton(
                  onTap: login,
                  text: "Login",
                ),

                const SizedBox(height: 25),

                // don't have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: () => widget.togglePages(AuthPageType.register),
                      child: Text(
                        "Register now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
