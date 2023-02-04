import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/firebase.dart';
import 'package:product_manager/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: const Text("Controle de Estoque"),
      ),
      body: const SafeArea(
        child: ProductsStream(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductsStream extends StatelessWidget {
  const ProductsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Product>>(
      stream: FirebaseService.getStreamSnapshotProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreenAccent,
            ),
          );
        }
        final products = snapshot.data?.docs;
        List<ProductCard> productsCards = [];
        for (var productData in products!) {
          productsCards.add(
            ProductCard(
              product: productData.data(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductDetail(
                    product: productData.data(),
                    onSave: (newProduct) async {
                      await FirebaseService.updateProduct(productData.id, newProduct);
                    },
                  );
                }));
              },
            ),
          );
        }

        return ListView(
          children: productsCards,
        );
      },
    );
  }
}
