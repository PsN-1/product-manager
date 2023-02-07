import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/utils/alert_dialog.dart';
import 'package:product_manager/widgets/pickable_async_image.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  final Future Function(Product) onSave;
  final Future Function() onDelete;

  const ProductDetail(
      {super.key,
      required this.product,
      required this.onSave,
      required this.onDelete});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var descriptionTextController = TextEditingController();
  var priceController = TextEditingController();

  late String oldQuantity;
  bool _isLoading = false;
  String? newImagePath;

  @override
  void initState() {
    super.initState();

    descriptionTextController.text = widget.product.description ?? "";
    priceController.text = widget.product.price ?? "";
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
    setLoading(true);

    setState(() {
      if (isNewQuantity) {
        widget.product
            .saveToHistory(oldQuantity, widget.product.quantity ?? "");
        oldQuantity = widget.product.quantity ?? "";
      }
    });
    widget.product.description = descriptionTextController.text;
    widget.product.price = priceController.text;

    if (newImagePath != null) {
      await widget.product.saveNewImage(newImagePath!);
    }

    await widget.onSave(widget.product);
    setLoading(false);
    _dismiss();
  }

  void _deleteProduct() async {
    setLoading(true);
    await widget.onDelete();
    setLoading(false);
    _dismiss();
  }

  void didChangeImage(String imagePath) {
    newImagePath = imagePath;
  }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
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
              PickableAsyncImage(
                image: widget.product.image ?? "",
                onChangeImage: didChangeImage,
              ),
              const SizedBox(height: 20),
              const Text("Produto", style: kLabelStyle),
              Text(widget.product.product ?? "", style: kTextStyle),
              const SizedBox(height: 20),

              const Text("Descrição", style: kLabelStyle),
              // Text(widget.product.description ?? "", style: textStyle),
              TextField(
                controller: descriptionTextController,
                style: kTextStyle,
              ),

              const SizedBox(height: 20),
              const Text("Caixa ", style: kLabelStyle),
              Text(widget.product.box ?? "", style: kTextStyle),
              const SizedBox(height: 20),
              const Text(
                "Preço",
                style: kLabelStyle,
              ),
              TextField(
                controller: priceController,
                style: kTextStyle,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text("Quantidade: ", style: kLabelStyle),
                  const Spacer(),
                  Visibility(
                    visible: isNewQuantity,
                    child: const Text("Valor anterior: ", style: kLabelStyle),
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
                  Text(widget.product.quantity ?? "", style: kTextStyle),
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
                      style: kTextStyle.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Últimas atualizações: ', style: kLabelStyle),
              for (var str in widget.product.history ?? [])
                Text(str, style: kHistoryStyle),

              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                      onPressed: _dismiss, child: const Text("Cancel")),
                  if (widget.product.quantity == "0")
                    OutlinedButton(
                      onPressed: () {
                        CustomAlert.show(context,
                            title: "Atenção!!!",
                            message: "Deseja mesmo apagar o produto?",
                            okPressed: _deleteProduct);
                      },
                      style: kDeleteButtonStyle,
                      child: const Text("Apagar"),
                    ),
                  OutlinedButton(
                      onPressed: _updateProduct, child: const Text("Salvar")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
