import 'dart:math';
import 'package:flutter/material.dart';
import 'package:listy/src/authentication/register_page.dart';
import 'package:realm/realm.dart';

import '../menu/menu_page.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  final App app;
  final void Function() onLogin;

  const LoginPage({
    Key? key,
    required this.app,
    required this.onLogin,
  }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _showError = false;

  final List<String> inspirationalQuotes = [
    "Success is not final, failure is not fatal: It is the courage to continue that counts. - Winston Churchill",
    "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
    "The secret of getting ahead is getting started. - Mark Twain",
    "I attribute my success to this: I never gave or took any excuse. - Florence Nightingale",
    "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "The best way to predict the future is to create it. - Peter Drucker",
    "Don't be afraid to give up the good to go for the great. - John D. Rockefeller",
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = emailController.text;
    final password = passwordController.text;

    widget.app.logIn(Credentials.emailPassword(email, password)).then((user) {
      if (user != null) {
        widget.onLogin();
        Navigator.pushReplacementNamed(context, MenuPage.routeName);
      } else {
        setState(() {
          _showError = true;
        });
      }
    }).catchError((error) {
      print('Login error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to\nSalePro',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              Text(
                _getRandomInspirationalQuote(),
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: collection4Color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: collection4Color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: collection4Color),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: collection4Color),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                cursorColor: collection4Color,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: collection4Color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: collection4Color),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: collection4Color),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                obscureText: true,
                cursorColor: collection4Color,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  primary: collection4Color,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RegisterPage.routeName);
                },
                child: const Text(
                  'Don\'t have an account? Register here.',
                  style: TextStyle(
                    color: collection4Color,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              if (_showError)
                const Text(
                  'Invalid email or password.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRandomInspirationalQuote() {
    final random = Random();
    return inspirationalQuotes[random.nextInt(inspirationalQuotes.length)];
  }
}
