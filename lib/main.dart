import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/screens/login.dart';
import 'package:product_manager/screens/signup.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppK.url,
    anonKey: AppK.anonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: (SupabaseService.getCurrentUser() != null)
          ? HomePage.id
          : LoginPage.id,
      routes: {
        LoginPage.id: (context) => const LoginPage(),
        SignupPage.id: (context) => const SignupPage(),
        HomePage.id: (context) => const HomePage(),
      },
    );
  }
}
