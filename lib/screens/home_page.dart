import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
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
  var user = FirebaseService.getCurrentUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text("Controle de Estoque"),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.person),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(child: Text("Configurações")),
              PopupMenuItem(
                child: const Text("Sair"),
                onTap: () async {
                  await FirebaseService.signOut();
                  setState(() {
                    Navigator.popAndPushNamed(context, LoginPage.id);
                  });
                },
              ),
            ],
          )
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
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(child: Text("Configurações")),
            ),
            ListTile(
              title: Column(
                children: [
                  const SizedBox(height: 20),
                  Text('E-mail: ${user?.email ?? ""}'),
                  const SizedBox(height: 20),
                  Text("E-mail verificado: ${user?.emailVerified}")
                ],
              ),
            ),
            ListTile(title: Text("Sair"),)
          ],
        ),
      ),
    );
  }
}
