import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/product_card.dart';

final _firestore = FirebaseFirestore.instance;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> products = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      loadProducts();
    });
  }

  void loadProducts() async {
    var data = await _firestore
        .collection('Products')
        .withConverter(
          fromFirestore: Product.fromFirestore,
          toFirestore: (Product product, _) => product.toFirestore(),
        )
        .get();

    for (var docSnap in data.docs) {
      var product = docSnap.data();
      products.add(ProductCard(product: product, onTap: () {
      print(product.product);
    }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: products, 
          // ProductCard(
          //   product: product,
          //   onTap: () {},
        //   // )
        // ],
      ),
    );
  }
}

