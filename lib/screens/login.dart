import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/services/firebase.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isLoading = false;
  bool isLoggedIn = false;

  void _handleSignup() async {}

  void _handleLogin() async {
    _isLoading = true;
    isLoggedIn = await FirebaseService.signIn(
      _emailTextController.text.trim(),
      _passwordTextController.text.trim(),
    );

    _isLoading = false;

    _goToHomePage();
  }

  void _goToHomePage() {
    if (isLoggedIn) {
      setState(() {
        Navigator.popAndPushNamed(context, HomePage.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        color: Colors.black,
        inAsyncCall: _isLoading,
        child: Container(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Controle de Estoque',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 100),
              const Text("E-mail"),
              TextField(
                controller: _emailTextController,
              ),
              const SizedBox(height: 20),
              const Text("Senha"),
              TextField(
                controller: _passwordTextController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: _handleSignup, child: const Text("Cadastrar")),
                  OutlinedButton(
                      onPressed: _handleLogin, child: const Text('Login')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
