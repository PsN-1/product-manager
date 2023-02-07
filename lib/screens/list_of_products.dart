import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/widgets/product_search_card.dart';

class ListOfProducts extends StatefulWidget {
  final void Function(String) onSelected;

  const ListOfProducts({super.key, required this.onSelected});

  @override
  State<ListOfProducts> createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  List<String> products = [];
  String _searchText = "";

  final savedProducts = SavedProducts();
  final _addNewProductController = TextEditingController();

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
    final loadedProducts = await savedProducts.readProducts();

    return loadedProducts.split('\n').toList();
  }

  bool _isFilteredProduct(String product) {
    if (_searchText.isNotEmpty) {
      return product.toLowerCase().contains(_searchText.toLowerCase());
    }

    return true;
  }

  Future _saveNewProduct() async {

    await savedProducts.writeToProducts(_addNewProductController.text);

    loadProducts();
    dismiss();
  }

  void dismiss() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    void _addNewProduct() async {
      _addNewProductController.text = "";
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  left: 40,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Adicionar novo Produto: ",
                        style: kLabelStyle,
                      ),
                      TextField(controller: _addNewProductController, ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton(
                              onPressed: dismiss, child: const Text("Cancelar")),
                          OutlinedButton(
                              onPressed: _saveNewProduct, child: const Text("Adicionar")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewProduct,
        child: const Icon(Icons.add),
      ),
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

class SavedProducts {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/saved_products.txt');
  }

  Future<File> writeToProducts(String product) async {
    final file = await _localFile;

    return file.writeAsString(product, mode: FileMode.append);
  }

  Future<String> readProducts() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      return _loadDefaultProducts();
    }
  }

  Future<String> _loadDefaultProducts() async {
    return await rootBundle.loadString('assets/products.txt');
  }
}
