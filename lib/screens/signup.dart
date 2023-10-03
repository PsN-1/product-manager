import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/utils/alert_dialog.dart';
import 'package:product_manager/widgets/box_button.dart';
import 'package:product_manager/widgets/box_textfield.dart';
import 'package:product_manager/widgets/custom_loading.dart';

class SignupPage extends StatefulWidget {
  static String id = "signup";

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;

    void dismiss() {
      Navigator.pop(context);
    }

    void setLoading(bool loading) {
      setState(() {
        _isLoading = loading;
      });
    }

    void handleResult(bool wasCreated) {
      CustomAlert.showOkAlert(context,
          title: (wasCreated)
              ? "Conta criada com sucesso."
              : "Erro ao criar nova conta.",
          onOkPressed: dismiss);
    }

    void handleUnmatchPassword() {
      CustomAlert.showOkAlert(context,
          title: "As senhas devem devem ser iguais", onOkPressed: () {});
    }

    bool passwordMatch() {
      return _passwordConfirmationController.text == _passwordController.text;
    }

    void handleSignup() async {
      if (!passwordMatch()) {
        handleUnmatchPassword();
        return;
      }

      setLoading(true);
      final accountCreated = await SupabaseService.signUp(
          _emailController.text, _passwordController.text);
      setLoading(false);

      handleResult(accountCreated);
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomModalHUD(
        isLoading: _isLoading,
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
              const SizedBox(height: 50),
              BoxTextField(
                controller: _emailController,
                hintText: 'E-mail',
              ),
              const SizedBox(height: 20),
              BoxTextField(
                controller: _passwordController,
                obscure: true,
                hintText: 'Senha',
              ),
              const SizedBox(height: 20),
              BoxTextField(
                controller: _passwordConfirmationController,
                obscure: true,
                hintText: 'Confirmar Senha',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: windowWidth > 500 ? 500 : windowWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxButton(text: 'Voltar', isPrimary: false, onTap: dismiss),
                    BoxButton(
                        text: "Cadastrar", isPrimary: true, onTap: handleSignup)
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
