import 'package:flutter/material.dart';
import 'package:newsapp/screens/login_screen.dart';
import 'package:newsapp/services/auth_service.dart';
import 'package:newsapp/widgets/my_button.dart';
import 'package:newsapp/widgets/my_textfield.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';
  RegisterScreen({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(
                parent: NeverScrollableScrollPhysics()),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),

                    // logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(height: 50),

                    const SizedBox(height: 25),

                    MyTextField(
                      controller: nameController,
                      hintText: 'name',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    // username textfield
                    MyTextField(
                      controller: emailController,
                      hintText: 'email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),

                    const SizedBox(height: 25),

                    // sign in button
                    MyButton(
                      text: "Register",
                      onTap: () {
                        AuthService().signup(
                            emailController.text,
                            passwordController.text,
                            nameController.text,
                            context);
                      },
                    ),

                    const SizedBox(height: 20),

                    // not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
