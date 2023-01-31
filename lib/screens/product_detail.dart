import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/async_image.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.product ?? "")),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: ListView(
          children: [
            AsyncImage(image: product.image ?? ""),
            const SizedBox(height: 20),
            const Text("Produto", style: labelStyle),
            Text(product.product ?? "", style: textStyle),
            const SizedBox(height: 20),
            const Text("Descrição", style: labelStyle),
            Text(product.description ?? "", style: textStyle),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Caixa: ", style: labelStyle),
                Text("Quantidade: ", style: labelStyle),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.box ?? "", style: textStyle),
                Text(product.quantity ?? "", style: textStyle),
              ],
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(onPressed: () {}, child: const Text("Cancel")),
                OutlinedButton(onPressed: () {}, child: const Text("Confirm")),
              ],
            )
          ],
        ),
      ),
    );
  }
}

const textStyle = TextStyle(fontSize: 22, color: Colors.black);
const labelStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);
