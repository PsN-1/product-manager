import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/pickable_async_image.dart';

const textStyle = TextStyle(fontSize: 22, color: Colors.black);
const historyStyle = TextStyle(fontSize: 18, color: Colors.black);
const labelStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);

class ProductDetail extends StatefulWidget {
  final Product product;
  final Future Function(Product) onSave;

  const ProductDetail({super.key, required this.product, required this.onSave});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var descriptionTextController = TextEditingController();
  late String oldQuantity;
  bool _isLoading = false;
  String? newImagePath; 

  @override
  void initState() {
    super.initState();

    descriptionTextController.text = widget.product.description ?? "";
    oldQuantity = widget.product.quantity ?? "";
  }

  void _addQuantity() {
    setState(() {
      widget.product.addQuantity();
    });
  }

  void _decreaseQuantity() {
    setState(() {
      widget.product.decreaseQuantity();
    });
  }

  bool get isNewQuantity {
    return oldQuantity != widget.product.quantity;
  }

  void _dismiss() {
    Navigator.pop(context);
  }

  void _updateProduct() async {
    _isLoading = true;

    setState(() {
      if (isNewQuantity) {
        widget.product
            .saveToHistory(oldQuantity, widget.product.quantity ?? "");
        oldQuantity = widget.product.quantity ?? "";
      }
    });
    widget.product.description = descriptionTextController.text;
    
    if (newImagePath != null) {
      await widget.product.saveNewImage(newImagePath!);
    }

    await widget.onSave(widget.product);
    _isLoading = false;
    _dismiss();
  }

  void didChangeImage(String imagePath) {
    newImagePath = imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.product ?? "")),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        color: Colors.black,
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: ListView(
            // padding: EdgeInsets.only(top: 40, bottom: 40),
            children: [
              PickableAsyncImage(image: widget.product.image ?? "", onChangeImage: didChangeImage,),
              const SizedBox(height: 20),
              const Text("Produto", style: labelStyle),
              Text(widget.product.product ?? "", style: textStyle),
              const SizedBox(height: 20),

              const Text("Descrição", style: labelStyle),
              // Text(widget.product.description ?? "", style: textStyle),
              TextField(
                controller: descriptionTextController,
                style: textStyle,
              ),

              const SizedBox(height: 20),
              const Text("Caixa: ", style: labelStyle),
              Text(widget.product.box ?? "", style: textStyle),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Quantidade: ", style: labelStyle),
                  const Spacer(),
                  Visibility(
                    visible: isNewQuantity,
                    child: const Text("Valor anterior: ", style: labelStyle),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(0),
                      onPressed: _decreaseQuantity,
                      icon: const Icon(Icons.remove)),
                  Text(widget.product.quantity ?? "", style: textStyle),
                  IconButton(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(0),
                      onPressed: _addQuantity,
                      icon: const Icon(Icons.add)),
                  const Spacer(),
                  Visibility(
                    visible: isNewQuantity,
                    child: Text(
                      oldQuantity,
                      style: textStyle.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Últimas atualizações: ', style: labelStyle),
              for (var str in widget.product.history ?? [])
                Text(str, style: historyStyle),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: _dismiss, child: const Text("Cancel")),
                  OutlinedButton(
                      onPressed: _updateProduct, child: const Text("Salvar")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
