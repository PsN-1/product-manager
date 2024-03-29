import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/screens/list_of_products.dart';
import 'package:product_manager/services/supabase.dart';
import 'package:product_manager/utils/snack_bar.dart';
import 'package:product_manager/widgets/custom_loading.dart';
import 'package:product_manager/widgets/pickable_async_image.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  bool _isLoading = false;

  final _productController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _boxController = TextEditingController();

  final _quantityController = TextEditingController();

  final _priceController = TextEditingController();

  Uint8List? imagePath;

  void _didSelectedImage(Uint8List path) {
    imagePath = path;
  }

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;

    void dismiss() {
      Navigator.pop(context);
    }

    void goToProductSelectionScreen() {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ListOfProducts(
          onSelected: (selectedProduct) {
            _productController.text = selectedProduct;
          },
        );
      }));
    }

    void setLoading(bool loading) {
      setState(() {
        _isLoading = loading;
      });
    }

    void showSuccessMessage() {
      CustomSnackBar.showSuccessMessage(
          context, "Produto criado com sucesso", () {});
    }

    void createNewProduct() async {
      setLoading(true);
      Product product = Product(
          product: _productController.text,
          description: _descriptionController.text,
          box: _boxController.text,
          quantity: _quantityController.text,
          price: _priceController.text,
          ownerId: SupabaseService.getUserUID());

      if (imagePath != null) {
        await product.saveNewImage(imagePath!);
      }

      await Product.createNewInstance(product);
      setLoading(false);
      showSuccessMessage();
      dismiss();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Novo Produto")),
      body: CustomModalHUD(
        isLoading: _isLoading,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: windowWidth > 600 ? 600 : windowWidth,
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
                  style: K.labelStyle,
                ),
                TextField(
                  controller: _productController,
                  style: K.textStyle,
                  readOnly: true,
                  onTap: goToProductSelectionScreen,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Descrição',
                  style: K.labelStyle,
                ),
                TextField(
                  controller: _descriptionController,
                  style: K.textStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Caixa",
                  style: K.labelStyle,
                ),
                TextField(
                    controller: _boxController,
                    style: K.textStyle,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                const SizedBox(height: 20),
                const Text(
                  "Quantidade",
                  style: K.labelStyle,
                ),
                TextField(
                  controller: _quantityController,
                  style: K.textStyle,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Preço',
                  style: K.labelStyle,
                ),
                TextField(
                  controller: _priceController,
                  style: K.textStyle,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: dismiss, child: const Text("Cancel")),
                    OutlinedButton(
                        onPressed: createNewProduct,
                        style: K.saveButtonStyle,
                        child: const Text("Salvar")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
