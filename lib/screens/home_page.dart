import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/screens/add_new_product.dart';
import 'package:product_manager/screens/login.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/widgets/main_page_drawer.dart';
import 'package:product_manager/widgets/products_stream.dart';

class HomePage extends StatefulWidget {
  static String id = "home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var user = SupabaseService.getCurrentUser();

  @override
  void initState() {
    super.initState();

    if (user == null) {
      logout();
    }
  }

  void logout() async {
    await SupabaseService.signOut();
    setState(() {
      Navigator.pop(context);
      Navigator.popAndPushNamed(context, LoginPage.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    void goToAddNewProduct() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const AddNewProduct();
      }));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: K.primaryColor,
        foregroundColor: K.backgroundColor,
        title: const Text("Controle de Estoque"),
      ),
      body: const SafeArea(
        child: ProductsStream(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddNewProduct,
        tooltip: 'Increment',
        backgroundColor: K.primaryColor,
        foregroundColor: K.backgroundColor,
        child: const Icon(Icons.add),
      ),
      drawer: MainPageDrawer(
        user: user?.email ?? "",
        onLogoutPressed: logout,
      ),
    );
  }
}
