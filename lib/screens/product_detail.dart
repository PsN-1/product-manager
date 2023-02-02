import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/async_image.dart';

const textStyle = TextStyle(fontSize: 22, color: Colors.black);
const labelStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);

class ProductDetail extends StatefulWidget {
  Product product;

  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var descriptionTextController = TextEditingController();

  @override
    void initState() {
      super.initState();

    descriptionTextController.text = widget.product.description ?? "";
    }

  void addQuantity() {
    setState(() {
      if (widget.product.quantity != null) {
        widget.product.quantity =
            (int.parse(widget.product.quantity!) + 1).toString();
      }
    });
  }

  void decreaseQuantity() {
    setState(() {
      if (widget.product.quantity != null) {
        if (int.parse(widget.product.quantity!) > 0) {
          widget.product.quantity =
              (int.parse(widget.product.quantity!) - 1).toString();
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.product ?? "")),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: ListView(
          children: [
            AsyncImage(image: widget.product.image ?? ""),
            const SizedBox(height: 20),
            const Text("Produto", style: labelStyle),
            Text(widget.product.product ?? "", style: textStyle),
            const SizedBox(height: 20),

            const Text("Descrição", style: labelStyle),
            // Text(widget.product.description ?? "", style: textStyle),
            TextField(controller: descriptionTextController, style: textStyle,),

            const SizedBox(height: 20),
            const Text("Caixa: ", style: labelStyle),
            Text(widget.product.box ?? "", style: textStyle),
            const SizedBox(height: 20),
            const Text("Quantidade: ", style: labelStyle),
            Row(
             mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                IconButton(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0),
                  onPressed: decreaseQuantity, icon: const Icon(Icons.remove)),
                Text(widget.product.quantity ?? "", style: textStyle),
                IconButton(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.all(0),
                  onPressed: addQuantity, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                OutlinedButton(onPressed: () {}, child: const Text("Confirm")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
