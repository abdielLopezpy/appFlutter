import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class RegisterPage extends StatefulWidget {
  static const String routeName = '/register';

  final App app;
  final void Function() onRegister;

  const RegisterPage({
    Key? key,
    required this.app,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool showWelcomeMessage = false;

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

  void showWelcome() {
    setState(() {
      showWelcomeMessage = true;
    });
  }

  void hideWelcome() {
    setState(() {
      showWelcomeMessage = false;
    });
    login();
  }

  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;
    try {
      // Log in the user with Realm
      final credentials = Credentials.emailPassword(email, password);
      await widget.app.logIn(credentials);

      // Call the onRegister callback to notify the parent widget
      widget.onRegister();

      // Perform any additional logic after successful login
    } catch (e) {
      // Handle login error
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: collection1Color,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              ScaleTransition(
                scale: _animation,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    try {
                      // Register the user with Realm
                      final authProvider =
                          EmailPasswordAuthProvider(widget.app);
                      await authProvider.registerUser(email, password);
                      // Call the onRegister callback to notify the parent widget
                      widget.onRegister();

                      // Show welcome message
                      showWelcome();
                    } catch (e) {
                      // Handle registration error
                      print('Registration error: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    primary: collection4Color,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (showWelcomeMessage)
                Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.all(8.0),
                  color: collection1Color,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, color: Colors.white),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Registration successful! Welcome!',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        onPressed: hideWelcome,
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
