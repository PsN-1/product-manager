import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickableAsyncImage extends StatefulWidget {
  final String image;
  final void Function(Uint8List)? onChangeImage;

  const PickableAsyncImage({
    super.key,
    required this.image,
    this.onChangeImage,
  });

  @override
  State<PickableAsyncImage> createState() => _PickableAsyncImageState();
}

class _PickableAsyncImageState extends State<PickableAsyncImage> {
  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = const CircularProgressIndicator();

    if (imageFile != null) {
      if (kIsWeb) {
        imageWidget = Image.network(imageFile!.path);
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

    void onTap() async {
      if (widget.onChangeImage != null) {
        final ImagePicker picker = ImagePicker();
        imageFile = await picker.pickImage(source: ImageSource.gallery);
        final newImageForWeb = await imageFile?.readAsBytes();

        if (newImageForWeb != null) {
          widget.onChangeImage!(newImageForWeb);
        }
        setState(() {});
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: imageWidget,
    );
  }
}
