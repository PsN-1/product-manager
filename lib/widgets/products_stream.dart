import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/firebase.dart';
import 'package:product_manager/widgets/product_card.dart';
import 'package:product_manager/widgets/product_search_card.dart';

class ProductsStream extends StatefulWidget {
  const ProductsStream({super.key});

  @override
  State<ProductsStream> createState() => _ProductsStreamState();
}

class _ProductsStreamState extends State<ProductsStream> {
  String searchText = "";

  void _updateSearch(String newSearchText) {
    setState(() {
      searchText = newSearchText;
    });
  }

  bool _isFilteredProduct(Product product) {
    if (searchText.isEmpty) {
      return true;
    }

    bool hasProductText =
        product.product?.toLowerCase().contains(searchText.toLowerCase()) ??
            false;
    bool hasDescriptionText =
        product.description?.toLowerCase().contains(searchText.toLowerCase()) ??
            false;
    bool hasBoxNumber = product.box == searchText;

    return hasProductText || hasDescriptionText || hasBoxNumber;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshotProduct>(
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
        List<Widget> productsCards = [];
        productsCards.add(ProductSearchCard(
          onSearchTapped: _updateSearch,
        ));
        for (var productData in products!) {
          if (_isFilteredProduct(productData.data())) {
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
        }
        productsCards.add(const SizedBox(height: 20));

        return ListView(
          children: productsCards,
        );
      },
    );
  }
}
