import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/widgets/product_card.dart';
import 'package:product_manager/widgets/product_search_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Supabase.instance.client
            .from("Products")
            .select('id, product:product(name), description'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          List<Widget> productsCards = [];
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetail(
                        product: product,
                        onDelete: () async {
                          await SupabaseService.deleteProduct(product.id);
                        },
                        onSave: (newProduct) async {
                          await SupabaseService.updateProduct(
                              product.id, newProduct);
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
      ),
    );
  }
}
