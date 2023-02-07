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

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  void loadProducts() async {
    products = await _loadAsset();
    setState(() {});
  }

  Future<List<String>> _loadAsset() async {
    final products = await rootBundle.loadString('assets/products.txt');

    return products.split('\n').toList();
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
              return ProductSearchCard();
            }
            return TextButton(
                onPressed: () {
                  widget.onSelected(products[index - 1]);
                  Navigator.pop(context);
                },
                child: Text(products[index - 1]));
          },
        ));
  }
}

class ProductSearchCard extends StatelessWidget {
  final _searchController = TextEditingController();

  ProductSearchCard({super.key});

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
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  label: const Text("Procurar"))
            ],
          )),
    );
  }
}
