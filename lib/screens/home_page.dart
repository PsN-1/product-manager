import 'package:flutter/material.dart';
import 'package:product_manager/screens/add_new_product.dart';
import 'package:product_manager/widgets/products_stream.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Estoque")),
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


