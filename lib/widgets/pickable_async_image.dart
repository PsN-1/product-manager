import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

late Uint8List? newImageForWeb;

class PickableAsyncImage extends StatefulWidget {
  final String image;
  final void Function(String)? onChangeImage;

  const PickableAsyncImage(
      {super.key, required this.image, this.onChangeImage});

  @override
  State<PickableAsyncImage> createState() => _PickableAsyncImageState();
}

class _PickableAsyncImageState extends State<PickableAsyncImage> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    late Widget imageWidget;

    void getImage() async {
      newImageForWeb = await imageFile!.readAsBytes();
    }

    if (imageFile != null) {
      if (kIsWeb) {
        imageWidget = Image.network(imageFile!.path);
        getImage();
      } else {
        imageWidget = Image.file(File(imageFile!.path));
      }
    } else if (!widget.image.startsWith("https")) {
      imageWidget = LayoutBuilder(builder: (context, constraint) {
        return Icon(
          Icons.add_photo_alternate,
          size: constraint.biggest.width * 0.7,
        );
      });
    } else {
      imageWidget = Image.network(
        widget.image,
        fit: BoxFit.fitWidth,
      );
    }

    return GestureDetector(
      onTap: () async {
        if (widget.onChangeImage != null) {
          final ImagePicker picker = ImagePicker();
          imageFile = await picker.pickImage(source: ImageSource.gallery);
          if (imageFile != null) {
            widget.onChangeImage!(imageFile!.path);
          }
          setState(() {});
        }
      },
      child: imageWidget,
    );
  }
}
