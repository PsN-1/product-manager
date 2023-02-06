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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Controle de Estoque")),
      body: const SafeArea(
        child: ProductsStream(),
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
  const ProductsStream({super.key});

  @override
  State<ProductsStream> createState() => _ProductsStreamState();
}

class _ProductsStreamState extends State<ProductsStream> {
  String searchText = "";
  String searchField = "";

  void updateSearch(String newSearchText, String newSearchField) {
    setState(() {
      searchText = newSearchText;
      searchField = newSearchField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Product>>(
      stream: (searchText.isNotEmpty)
          ? FirebaseService.getFilteredStreamSnapshot(searchText, searchField)
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
        List<Widget> productsCards = [];
        productsCards.add(SearchCard(
          onSearchPressed: updateSearch,
        ));
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

class SearchCard extends StatefulWidget {
  const SearchCard({super.key, required this.onSearchPressed});

  final void Function(String, String) onSearchPressed;

  @override
  _SearchCardState createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  final searchController = TextEditingController();
  String selectedValue = SearchFields.values.first.value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 20),
        child: Column(children: [
          TextField(
            controller: searchController,
            decoration: kTextFieldInputDecoration,
          ),
          // IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          const SizedBox(height: 20),
          DropdownButton(
            isExpanded: true,
            value: selectedValue,
            onChanged: (newValue) {
              setState(() {
                selectedValue = newValue ?? "";
              });
            },
            items: SearchFields.values
                .map((field) => DropdownMenuItem(
                    value: field.value, child: Text(field.value)))
                .toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            label: Text('Procurar'),
            icon: Icon(Icons.search),
              onPressed: () {
                widget.onSearchPressed(searchController.text, selectedValue);
              },)
        ]),
      ),
    );
  }
}

enum SearchFields {
  product('Produto'),
  description('Descrição'),
  box('Caixa');

  const SearchFields(this.value);
  final String value;
}
