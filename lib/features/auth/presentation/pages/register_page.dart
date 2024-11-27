import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:mobile_app/features/auth/presentation/components/my_button.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
 // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final ConfirmPwController = TextEditingController();
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

                // Create account massage
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

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

                // confirm pw textfield
                MyTextField(
                  controller: ConfirmPwController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Register button
                MyButton(
                  onTap: () {},
                  text: "Register",
                ),

                const SizedBox(height: 25),

                // Already member? Login now
                Text(
                  "Already a member? Login now",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}