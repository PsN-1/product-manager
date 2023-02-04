import 'package:flutter/material.dart';

class AsyncImage extends StatelessWidget {
  final String image;
  const AsyncImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (!image.startsWith("https")) {
      imageWidget = LayoutBuilder(builder: (context, constraint) {
        return Icon(
          Icons.add_photo_alternate,
          size: constraint.biggest.width * 0.7,
        );
      });
    } else {
      imageWidget = Image.network(
        image,
        fit: BoxFit.fitWidth,
      );
    }
    return imageWidget;

    // return FutureBuilder(
    //   future: getImage(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> imageData) {
    //     if (imageData.hasData) Image(image: NetworkImage(imageData.data));
    //
    //     if (imageData.hasError) const Text("Error loading image");
    //
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
  }
}
