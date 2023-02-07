import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/services/firebase.dart';

class SignupPage extends StatelessWidget {
  static String id = "signup";

  SignupPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    void dismiss() {
      Navigator.pop(context);
    }

    void handleSignup() async {
      _isLoading = true;
    await  FirebaseService.signUp(_emailController.text, _passwordController.text );
      _isLoading = false;
      dismiss();
    }

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Controle de Estoque',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Cadastro",
                style: kLabelStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text("E-mail"),
              TextField(
                controller: _emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Senha"),
              TextField(
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: dismiss, child: const Text("Voltar")),
                  OutlinedButton(
                      onPressed: handleSignup, child: const Text('Cadastrar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
