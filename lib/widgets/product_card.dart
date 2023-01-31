import 'package:flutter/material.dart';
import 'package:product_manager/models/product.dart';
import 'package:product_manager/widgets/async_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function() onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: PhysicalModel(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: (product.image != null)
                      ? AsyncImage(image: product.image!)
                      : const SizedBox(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.product!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.description ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Caixa: ${product.box}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Qtd: ${product.quantity}',
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  // final product = Product(
  //   description: 'Lâmina de Ralar do Super Chef',
  //   box: "67",
  //   code: "1396",
  //   image: "lamina_3_super_chef_JPG",
  //   product: 'Lâmina Jullienne Super Chefe',
  //   quantity: '2',
  // );
