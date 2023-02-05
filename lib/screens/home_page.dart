import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/add_new_product.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/services/firebase.dart';
import 'package:product_manager/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> products = [];

  String searchText = "";

  void onSearchChange(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBarWidget(
        onChanged: onSearchChange,
      ),
      body: SafeArea(
        child: ProductsStream(searchText: searchText),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddNewProduct();
          }));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductsStream extends StatefulWidget {
  String searchText;
  ProductsStream({super.key, required this.searchText});

  @override
  State<ProductsStream> createState() => _ProductsStreamState();
}

class _ProductsStreamState extends State<ProductsStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Product>>(
      stream: (widget.searchText.isNotEmpty)
          ? FirebaseService.getFilteredStreamSnapshot(widget.searchText)
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
        List<ProductCard> productsCards = [];
        for (var productData in products!) {
          productsCards.add(
            ProductCard(
              product: productData.data(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProductDetail(
                    product: productData.data(),
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

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SearchBarWidget({super.key, required this.onChanged});

  final void Function(String) onChanged;
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  Icon _customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text("Controle de Estoque");

  final _searchController = TextEditingController();

  void showSearchBar() {
    setState(() {
      if (_customIcon.icon == Icons.search) {
        _customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
          title: TextField(
            onEditingComplete: () {
              widget.onChanged(_searchController.text);
            },
            controller: _searchController,
            decoration: kTextFieldInputDecoration,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
      } else {
        _customIcon = const Icon(Icons.search);
        customSearchBar = const Text("Controle de Estoque");
        _searchController.text = "";
        widget.onChanged("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: customSearchBar,
      actions: [IconButton(onPressed: showSearchBar, icon: _customIcon)],
    );
  }
}
