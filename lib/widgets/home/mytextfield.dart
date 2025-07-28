// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String label;
  final int minLines;
  final int maxLines;
  final int maxLength;
  const MyTextField(
      {required this.controller,
      required this.validator,
      required this.label,
      required this.minLines,
      required this.maxLines,
      required this.maxLength});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  static OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: const BorderSide(width: 1, color: Colors.black));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      style: const TextStyle(color: Colors.black),
      controller: widget.controller,
      validator: widget.validator,
      maxLength: widget.maxLength,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: inputBorder,
        disabledBorder: inputBorder,
        counterText: '',
        errorBorder: inputBorder.copyWith(
            borderSide: const BorderSide(width: 1, color: Colors.red)),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        focusedErrorBorder: inputBorder,
        labelText: widget.label,
        hintStyle: const TextStyle(color: Colors.black, fontSize: 17),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 17),
        helperStyle: const TextStyle(color: Colors.black, fontSize: 17),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        fillColor: Colors.grey,
        // contentPadding:
        // const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
        // hintText: controller.text != '' ? controller.text : '',
      ),
    );
  }
}
