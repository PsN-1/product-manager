import 'package:flutter/material.dart';
import 'package:product_manager/models/column_name.dart';
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
  String searchText = '';
  ColumnName column = ColumnName.product;

  void _updateSearch(String newSearchText, ColumnName newColumn) {
    setState(() {
      searchText = newSearchText;
      column = newColumn;
    });
  }

  Future _pullRefresh() async {
    setState(() {
      searchText = '';
      column = ColumnName.product;
    });
  }

  List<Widget> createProductsCard(List<Map<String, dynamic>> products) {
    List<Widget> productsCards = [];

    // Create the Search Card
    productsCards.add(ProductSearchCard(
      onSearchTapped: _updateSearch,
      showSelection: true,
    ));

    for (var productData in products) {
      final product = Product.fromMap(productData);
      productsCards.add(
        ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ProductDetail(
                    product: product,
                    onDelete: () async {
                      await SupabaseService.deleteProduct(product.id);
                    },
                    onSave: (newProduct) async {
                      await SupabaseService.updateProduct(
                        product.id,
                        newProduct,
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      );
    }
    productsCards.add(const SizedBox(height: 20));
    return productsCards;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Scaffold(
        body: StreamBuilder(
          stream: SupabaseService.getProductsFiltered(
            searchText: searchText,
            column: column.name,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return ProductSearchCard(
                onSearchTapped: _updateSearch,
                showSelection: true,
              );
            }
            final products = snapshot.data!;
            List<Widget> productsCards = createProductsCard(products);

            return ListView(
              children: productsCards,
            );
          },
        ),
      ),
    );
  }
}
