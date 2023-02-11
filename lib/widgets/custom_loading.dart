import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:product_manager/constants.dart';

class CustomModalHUD extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CustomModalHUD(
      {super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(color: kPrimaryColor),
      child: child,
    );
  }
}
