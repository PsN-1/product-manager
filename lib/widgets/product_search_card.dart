import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

class ProductSearchCard extends StatefulWidget {
  final void Function(String) onSearchTapped;

  const ProductSearchCard({super.key, required this.onSearchTapped});

  @override
  State<ProductSearchCard> createState() => _ProductSearchCardState();
}

class _ProductSearchCardState extends State<ProductSearchCard> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: windowWidth > 400 ? 400 : windowWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(15),
        child: Container(
          padding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
          child: Column(
            children: [
              const Text(
                'Busca',
                style: K.labelStyle,
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _searchController,
                      decoration: K.textFieldInputDecoration,
                      onSubmitted: (text) {
                        widget.onSearchTapped(_searchController.text);
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _searchController.text = "";
                        widget.onSearchTapped("");
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  widget.onSearchTapped(_searchController.text);
                },
                icon: const Icon(Icons.search),
                label: const Text("Procurar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
