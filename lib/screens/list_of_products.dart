import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListOfProducts extends StatefulWidget {
  final void Function(String) onSelected;

  const ListOfProducts({super.key, required this.onSelected});

  @override
  State<ListOfProducts> createState() => _ListOfProductsState();
}

class _ListOfProductsState extends State<ListOfProducts> {
  List<Widget> products = [];

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  void loadProducts() async {
    products = await _loadAsset();
    setState(() {});
  }

  Future<List<Widget>> _loadAsset() async {
    final products = await rootBundle.loadString('assets/products.txt');
    return products
        .split('\n')
        .map((String text) => TextButton(
              onPressed: () {
                widget.onSelected(text);
                Navigator.pop(context);
              },
              child: Text(text),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
        ),
        body: ListView(
          children: products,
        ));
  }
}
