import 'package:flutter/material.dart';
import 'package:product_manager/constants.dart';

enum SearchFields {
  product('Produto'),
  description('Descrição'),
  box('Caixa');

  const SearchFields(this.value);
  final String value;
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
          const Text(
            'Busca',
            style: kLabelStyle,
          ),
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
            style: const ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(kPrimaryColor),
            ),
            label: const Text('Procurar'),
            icon: const Icon(Icons.search),
            onPressed: () {
              widget.onSearchPressed(searchController.text, selectedValue);
            },
          )
        ]),
      ),
    );
  }
}
