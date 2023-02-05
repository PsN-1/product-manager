import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/screens/product_detail.dart';
import 'package:product_manager/widgets/pickable_async_image.dart';

class AddNewProduct extends StatelessWidget {
  AddNewProduct({super.key});

  final _productController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _boxController = TextEditingController();
  final _quantityController = TextEditingController();
  String? imagePath;

  void _didSelectedImage(String path) {
    imagePath = path;
  }


  @override
  Widget build(BuildContext context) {

    void _dismiss() {
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Novo Produto")),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            PickableAsyncImage(
              image: "",
              onChangeImage: _didSelectedImage,
            ),
            const SizedBox(height: 20),
            const Text(
              'Produto',
              style: labelStyle,
            ),
            TextField(
              controller: _productController,
              style: textStyle,
              readOnly: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ListOfProducts(
                    onSelected: (selectedProduct) {
                      _productController.text = selectedProduct;
                    },
                  );
                }));
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Descrição',
              style: labelStyle,
            ),
            TextField(
              controller: _descriptionController,
              style: textStyle,
            ),
            const SizedBox(height: 20),
            const Text(
              "Caixa",
              style: labelStyle,
            ),
            TextField(
                controller: _boxController,
                style: textStyle,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 20),
            const Text(
              "Quantidade",
              style: labelStyle,
            ),
            TextField(
              controller: _quantityController,
              style: textStyle,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(onPressed: _dismiss, child: const Text("Cancel")),
                OutlinedButton(onPressed: () {}, child: const Text("Salvar")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

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
