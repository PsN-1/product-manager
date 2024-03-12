import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

class ProductSearchCard extends StatefulWidget {
  final void Function(String, ColumnName) onSearchTapped;
  final bool showSelection;

  const ProductSearchCard(
      {super.key, required this.onSearchTapped, this.showSelection = false});

  @override
  State<ProductSearchCard> createState() => _ProductSearchCardState();
}

enum ColumnName { product, description, box, log }

extension ColumnNameExtension on ColumnName {
  String get name {
    switch (this) {
      case ColumnName.product:
        return "product";
      case ColumnName.description:
        return "description";
      case ColumnName.box:
        return "box";
      case ColumnName.log:
        return "log";
    }
  }
}

class _ProductSearchCardState extends State<ProductSearchCard> {
  final _searchController = TextEditingController();
  var columnName = ColumnName.product;

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
                        widget.onSearchTapped(
                            _searchController.text, columnName);
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _searchController.text = "";
                        widget.onSearchTapped("", columnName);
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              const SizedBox(height: 10),
              if (widget.showSelection)
                SegmentedButton(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: ColumnName.product,
                      label: Text(
                        "Produto",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: ColumnName.description,
                      label: Text(
                        "Descrição",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: ColumnName.box,
                      label: Text(
                        "Caixa",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ButtonSegment(
                      value: ColumnName.log,
                      label: Text(
                        "Histórico",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  selected: <ColumnName>{columnName},
                  onSelectionChanged: (Set<ColumnName> newSelection) {
                    setState(() {
                      columnName = newSelection.first;
                    });
                  },
                ),
              if (widget.showSelection) const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  widget.onSearchTapped(_searchController.text, columnName);
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
