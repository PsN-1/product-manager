import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/models/raw_product.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/utils/snack_bar.dart';
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

  final _addNewProductController = TextEditingController();

  void _handleSearch(String text) {
    setState(() {
      _searchText = text;
    });
  }

  bool _isFilteredProduct(String product) {
    if (_searchText.isNotEmpty) {
      return product.toLowerCase().contains(_searchText.toLowerCase());
    }

    return true;
  }

  void _saveNewProduct() async {
    final newRawProduct = RawProduct(
      name: _addNewProductController.text,
      ownerId: SupabaseService.getUserUID(),
    );
    await RawProduct.createNewInstance(newRawProduct);
    showSuccessMessage();
    dismiss();
  }

  void showSuccessMessage() {
    CustomSnackBar.showSuccessMessage(
        context, "Novo produto cadastrado com suceso", () {});
  }

  void dismiss() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    void addNewProduct() async {
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
                    TextField(
                      controller: _addNewProductController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            onPressed: dismiss, child: const Text("Cancelar")),
                        OutlinedButton(
                            onPressed: _saveNewProduct,
                            child: const Text("Adicionar")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addNewProduct,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: StreamBuilder(
        stream: SupabaseService.getFutureProductsList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final products = snapshot.data!;
          List<Widget> productsCards = [];
          productsCards.add(ProductSearchCard(onSearchTapped: _handleSearch));
          for (var rawData in products) {
            final rawProduct = RawProduct.fromMap(rawData);
            if (_isFilteredProduct(rawProduct.name ?? "")) {
              productsCards.add(TextButton(
                  onPressed: () {
                    widget.onSelected(rawProduct.name ?? "");
                    Navigator.pop(context);
                  },
                  child: Text(rawProduct.name ?? "")));
            }
          }
          productsCards.add(const SizedBox(height: 30));
          return ListView(
            children: productsCards,
          );
        },
      ),
    );
  }
}
