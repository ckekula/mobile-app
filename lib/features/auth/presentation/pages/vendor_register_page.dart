import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/presentation/components/my_button.dart';
import 'package:mobile_app/features/auth/presentation/components/my_text_field.dart';
import 'package:mobile_app/features/auth/presentation/cubits/vendor_auth_cubits.dart';

class VendorRegisterPage extends StatefulWidget {
  final void Function()? showVendorLoginPage;
  final void Function()? showRegisterPage;

  const VendorRegisterPage(
      {super.key,
      required this.showVendorLoginPage,
      required this.showRegisterPage});

  @override
  State<VendorRegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<VendorRegisterPage> {
  // text controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  // register button is pressed
  void register() {
    // prepare info
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = pwController.text;
    final String confirmPw = confirmPwController.text;

    // auth cubit
    final authCubit = context.read<VendorAuthCubit>();

    // ensure fields are not empty
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPw.isNotEmpty) {
      // ensure passwords match
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);
      }

      // passwords don't match
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match!")));
      }
    }

    // fields are empty -> display error
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complete all fields!")));
    }
  }

  // dispose controllers
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      // Prevent resizing when the keyboard appears
      resizeToAvoidBottomInset: false,
      // BODY
      body: Stack(
        children: [
          // Main content
          SafeArea(
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

                    // Create account message
                    Text(
                      "Welcome vendors!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Name textfield
                    MyTextField(
                      controller: nameController,
                      hintText: "Name",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),

                    // Email textfield
                    MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),

                    // Password textfield
                    MyTextField(
                      controller: pwController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),

                    // Confirm password textfield
                    MyTextField(
                      controller: confirmPwController,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 25),

                    // Register button
                    MyButton(
                      onTap: register,
                      text: "Register",
                    ),
                    const SizedBox(height: 25),

                    // Already member? Login now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already a member? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.showVendorLoginPage,
                          child: Text(
                            "Login now",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // "Join us" text at the bottom center
          Positioned(
            bottom: 20, // Adjust the spacing from the bottom
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: widget.showRegisterPage,
              child: Text(
                "Go back",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
