import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/screens/signup.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/utils/alert_dialog.dart';
import 'package:product_manager/widgets/box_button.dart';
import 'package:product_manager/widgets/box_textfield.dart';
import 'package:product_manager/widgets/custom_loading.dart';

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

  @override
  void initState() {
    super.initState();

    _goToHomePage();
  }

  void _handleSignup() async {
    Navigator.pushNamed(context, SignupPage.id);
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _handleLogin() async {
    _setLoading(true);
    isLoggedIn = await SupabaseService.signIn(
      _emailTextController.text.trim(),
      _passwordTextController.text.trim(),
    );

    if (!isLoggedIn) {
      showErrorMessage();
    }

    _setLoading(false);
    _goToHomePage();
  }

  void showErrorMessage() {
    CustomAlert.showOkAlert(
      context,
      title: "Algo deu errado",
      message: "Por gentileza verificar suas credenciais.",
      onOkPressed: () {},
    );
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
    final double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomModalHUD(
        isLoading: _isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              const Text(
                'Controle de Estoque',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Login",
                textAlign: TextAlign.left,
                style: kLabelStyle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 50),
              BoxTextField(
                controller: _emailTextController,
                hintText: "E-mail",
              ),
              const SizedBox(height: 20),
              BoxTextField(
                controller: _passwordTextController,
                hintText: "Senha",
                obscure: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: windowWidth > 500 ? 500 : windowWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BoxButton(
                      text: "Cadastrar",
                      isPrimary: false,
                      onTap: _handleSignup,
                    ),
                    BoxButton(
                      text: 'Login',
                      isPrimary: true,
                      onTap: _handleLogin,
                    ),
                  ],
                ),
              ),
              Spacer(),
              const Text("version: 1.22")
            ],
          ),
        ),
      ),
    );
  }
}
