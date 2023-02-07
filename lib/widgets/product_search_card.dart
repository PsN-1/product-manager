import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

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