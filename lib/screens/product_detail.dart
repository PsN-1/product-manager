import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/constants.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/utils/alert_dialog.dart';
import 'package:product_manager/utils/snack_bar.dart';
import 'package:product_manager/widgets/custom_loading.dart';
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
        widget.product.saveToHistory(
          oldValue: oldQuantity,
          newValue: widget.product.quantity ?? "",
        );
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
    showSuccessMessage();
    _dismiss();
  }

  void updateNewBox() async {
    _dismiss();
    setLoading(true);
    setState(() async {
      String oldBox = widget.product.box ?? "";
      widget.product.box = newBoxController.text;
      widget.product.saveToHistory(
        oldValue: oldBox,
        newValue: newBoxController.text,
        isBox: true,
      );

      await widget.onSave(widget.product);
      setLoading(false);
      showSuccessMessage();
      _dismiss();
    });
  }

  var newBoxController = TextEditingController();
  void _changeProductBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Column(
          children: [
            const Text("Qual sera a nova caixa"),
            TextField(
              controller: newBoxController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          OutlinedButton(
            onPressed: _dismiss,
            child: const Text("Cancelar"),
          ),
          OutlinedButton(
            onPressed: updateNewBox,
            style: K.deleteButtonStyle,
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void showFullProductHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: SizedBox(
          width: 300,
          height: 300,
          child: ListView(
            children: [
              const Text('Últimas atualizações: ', style: K.labelStyle),
              const Text(""),
              for (var str in widget.product.history ?? [])
                Text(str, style: K.historyStyle)
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessMessage() {
    CustomSnackBar.showSuccessMessage(
      context,
      "Produto atualizado com sucesso",
      () {},
    );
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
    final double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.product ?? "")),
      body: CustomModalHUD(
        isLoading: _isLoading,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: windowWidth > 600 ? 600 : windowWidth,
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
                const SizedBox(height: 20),
                const Text("Produto", style: K.labelStyle),
                Text(widget.product.product ?? "", style: K.textStyle),
                const SizedBox(height: 20),

                const Text("Descrição", style: K.labelStyle),
                // Text(widget.product.description ?? "", style: textStyle),
                TextField(
                  controller: descriptionTextController,
                  style: K.textStyle,
                ),

                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Caixa ", style: K.labelStyle),
                    Row(
                      children: [
                        Text(widget.product.box ?? "", style: K.textStyle),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: _changeProductBox,
                          child: const Text("Mover"),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "Preço",
                  style: K.labelStyle,
                ),
                TextField(
                  controller: priceController,
                  style: K.textStyle,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text("Quantidade: ", style: K.labelStyle),
                    const Spacer(),
                    Visibility(
                      visible: isNewQuantity,
                      child:
                          const Text("Valor anterior: ", style: K.labelStyle),
                    )
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
                    Text(widget.product.quantity ?? "", style: K.textStyle),
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
                        style: K.textStyle.copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Últimas atualizações: ', style: K.labelStyle),
                GestureDetector(
                  onTap: showFullProductHistory,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var str in (widget.product.history ?? []).take(3))
                        (str != null)
                            ? Text(str, style: K.historyStyle)
                            : const Text(""),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: _dismiss, child: const Text("Cancel")),
                    if (widget.product.quantity == "0")
                      OutlinedButton(
                        onPressed: () {
                          CustomAlert.showOkCancelAlert(context,
                              title: "Atenção!!!",
                              message: "Deseja mesmo apagar o produto?",
                              okPressed: _deleteProduct);
                        },
                        style: K.deleteButtonStyle,
                        child: const Text("Apagar"),
                      ),
                    OutlinedButton(
                      onPressed: _updateProduct,
                      style: K.saveButtonStyle,
                      child: const Text("Salvar"),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
