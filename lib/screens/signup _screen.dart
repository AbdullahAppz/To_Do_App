import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utility/snack_bar.dart';
import '../services/firestore_user_service.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();

  static Widget socialButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signUp() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();

    // Validation
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      showSnackBar(context, "Please fill all fields");
      return;
    }

    if (!email.contains("@")) {
      showSnackBar(context, "Enter a valid email");
      return;
    }

    if (password.length < 6) {
      showSnackBar(
          context, "Password must be at least 6 characters");
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? error = await AuthService().signUp(
      name: name,
      email: email,
      password: password,
    );
    if (error == null) {
      await FirestoreUserService().createUser(
        name: name,
        email: email,
      );
    }
    setState(() {
      isLoading = false;
    });

    if (error == null) {
      showSnackBar(context, "Account created successfully!");

      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showSnackBar(context, error);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f2e8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, "/login");
                    },
                    child: const Text("Log In"),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                CustomField(
                  label: "Your Email",
                  controller: emailController,
                ),

                const SizedBox(height: 20),

                CustomField(
                  label: "Name",
                  controller: nameController,
                ),

                const SizedBox(height: 20),

                CustomField(
                  label: "Password",
                  controller: passwordController,
                  obscure: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.brown,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                    ),
                    onPressed:
                    isLoading ? null : signUp,
                    child: isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "By signing up you agree to our "
                        "Terms of Use and Privacy Policy",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomField extends StatelessWidget {
  final String label;
  final bool obscure;
  final TextEditingController controller;

  const CustomField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
      ),
    );
  }
}