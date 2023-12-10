import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/supabase.dart';
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

    bool hasHistoryDate = checkHasHistoryDate(searchText, product.history);

    return hasProductText ||
        hasDescriptionText ||
        hasBoxNumber ||
        hasHistoryDate;
  }

  bool checkHasHistoryDate(String searchText, List<String?>? history) {
    if (history == null) {
      return false;
    }
    for (final element in history) {
      if (element == null) {
        continue;
      }
      if (element.startsWith(searchText)) {
        return true;
      }
    }
    return false;
  }

  List<Widget> createProductsCard(List<Map<String, dynamic>> products) {
    List<Widget> productsCards = [];

    // Create the Search Card
    productsCards.add(ProductSearchCard(
      onSearchTapped: _updateSearch,
    ));

    for (var productData in products) {
      final product = Product.fromMap(productData);
      if (_isFilteredProduct(product)) {
        productsCards.add(
          ProductCard(
            product: product,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductDetail(
                  product: product,
                  onDelete: () async {
                    await SupabaseService.deleteProduct(product.id);
                  },
                  onSave: (newProduct) async {
                    await SupabaseService.updateProduct(product.id, newProduct);
                  },
                );
              }));
            },
          ),
        );
      }
    }
    productsCards.add(const SizedBox(height: 20));
    return productsCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: SupabaseService.getFutureProducts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          List<Widget> productsCards = createProductsCard(products);

          return ListView(
            children: productsCards,
          );
        },
      ),
    );
  }
}
