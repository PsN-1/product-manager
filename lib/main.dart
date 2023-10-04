import 'package:flutter/material.dart';
import 'package:product_manager/screens/home_page.dart';
import 'package:product_manager/screens/login.dart';
import 'package:product_manager/screens/signup.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iqghfjlsyvdpvnnondyp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxZ2hmamxzeXZkcHZubm9uZHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYyNjMwODUsImV4cCI6MjAxMTgzOTA4NX0.PLRjPi5rwZujoPKQyopwr52RFiqpxhKt5Vvz8vGdhts',
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
