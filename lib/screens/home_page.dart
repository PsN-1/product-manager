import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/product_card.dart';

final _firestore = FirebaseFirestore.instance;

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
          title: const Text(
        "Controle de Estoque",
      )),
      body: const SafeArea(
        child: ProductsStream(),
      ),
    );
  }
}

class ProductsStream extends StatelessWidget {
  const ProductsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Product>>(
      stream: _firestore
          .collection('Products')
          .withConverter(
            fromFirestore: Product.fromFirestore,
            toFirestore: (Product product, _) => product.toFirestore(),
          )
          .snapshots(),
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
          productsCards
              .add(ProductCard(product: productData.data(), onTap: () {}));
        }

        return Expanded(
          child: ListView(
            children: productsCards,
          ),
        );
      },
    );
  }
}
