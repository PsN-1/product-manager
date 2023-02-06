import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/firebase.dart';
import 'package:product_manager/widgets/product_card.dart';
import 'package:product_manager/widgets/search_card.dart';

class ProductsStream extends StatefulWidget {
  const ProductsStream({super.key});

  @override
  State<ProductsStream> createState() => _ProductsStreamState();
}

class _ProductsStreamState extends State<ProductsStream> {
  String searchText = "";
  String searchField = "";

  void updateSearch(String newSearchText, String newSearchField) {
    setState(() {
      searchText = newSearchText;
      searchField = newSearchField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Product>>(
      stream: (searchText.isNotEmpty)
          ? FirebaseService.getFilteredStreamSnapshot(searchText, searchField)
          : FirebaseService.getStreamSnapshotProducts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreenAccent,
            ),
          );
        }
        final products = snapshot.data?.docs;
        List<Widget> productsCards = [];
        productsCards.add(SearchCard(
          onSearchPressed: updateSearch,
        ));
        for (var productData in products!) {
          productsCards.add(
            ProductCard(
              product: productData.data(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductDetail(
                    product: productData.data(),
                    onDelete: () async {
                      await FirebaseService.deleteProduct(productData.id);
                    },
                    onSave: (newProduct) async {
                      await FirebaseService.updateProduct(
                          productData.id, newProduct);
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
