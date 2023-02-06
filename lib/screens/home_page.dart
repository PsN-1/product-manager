import 'package:flutter/material.dart';
import 'package:product_manager/screens/add_new_product.dart';
import 'package:product_manager/screens/login.dart';
import 'package:product_manager/services/firebase.dart';
import 'package:product_manager/widgets/products_stream.dart';

class HomePage extends StatefulWidget {
  static String id = "home_page";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Controle de Estoque"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  FirebaseService.auth.signOut();
                  Navigator.popAndPushNamed(context, LoginPage.id);
                });
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: const SafeArea(
        child: ProductsStream(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewProduct();
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
