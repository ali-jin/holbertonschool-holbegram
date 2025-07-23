import 'package:flutter/material.dart';
import '../widgets/text_field.dart';
import 'upload_image_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFieldInput(
            controller: emailController,
            isPassword: false,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          TextFieldInput(
            controller: usernameController,
            isPassword: false,
            hintText: 'Username',
            keyboardType: TextInputType.text,
          ),
          TextFieldInput(
            controller: passwordController,
            isPassword: true,
            hintText: 'Password',
            keyboardType: TextInputType.visiblePassword,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPicture(
                    email: emailController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  ),
                ),
              );
            },
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
