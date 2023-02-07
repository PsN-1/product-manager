import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/constants.dart';

class ListOfProducts extends StatefulWidget {
  final void Function(String) onSelected;

  const ListOfProducts({super.key, required this.onSelected});

  @override
  State<ListOfProducts> createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  List<String> products = [];
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  void loadProducts() async {
    products = await _loadAsset();
    setState(() {});
  }

  void _handleSearch(String text) {
    setState(() {
      _searchText = text;
        });
  }

  Future<List<String>> _loadAsset() async {
    final products = await rootBundle.loadString('assets/products.txt');

    return products.split('\n').toList();
  }

  bool _isFilteredProduct(String product) {
    if (_searchText.isNotEmpty) {
      return product.toLowerCase().contains(_searchText.toLowerCase());
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return ProductSearchCard(onSearchTapped: _handleSearch);
          }

          if (_isFilteredProduct(products[index - 1])) {
            return TextButton(
                onPressed: () {
                  widget.onSelected(products[index - 1]);
                  Navigator.pop(context);
                },
                child: Text(products[index - 1]));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class ProductSearchCard extends StatelessWidget {
  final _searchController = TextEditingController();
  final void Function(String) onSearchTapped;

  ProductSearchCard({super.key, required this.onSearchTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(15),
      child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
          child: Column(
            children: [
              const Text(
                'Busca',
                style: kLabelStyle,
              ),
              TextField(
                controller: _searchController,
                decoration: kTextFieldInputDecoration,
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                  onPressed: () {
                    onSearchTapped(_searchController.text);
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Procurar"))
            ],
          )),
    );
  }
}
