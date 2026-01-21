import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'student_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }

    bool success = await DBHelper.loginUser(email, password);
    if (mounted) {
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const StudentPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
      }
    }
  }

  void register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter email and password')));
      return;
    }

    int res = await DBHelper.registerUser(email, password);
    if (mounted) {
      if (res > 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful. Please Login.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: login, child: const Text('Login'))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(onPressed: register, child: const Text('Register'))),
          ])
        ]),
      ),
    );
  }
}
