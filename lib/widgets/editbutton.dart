// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

import '../providers/home_provider.dart';
import '../general.dart';

class EditButton extends StatefulWidget {
  final TabView currentView;
  final int numViews;
  final void Function(bool) handleEditing;
  const EditButton(this.numViews, this.currentView, this.handleEditing);

  @override
  State<EditButton> createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  Widget buildViewsButton() {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: Container(
            height: 100,
            width: 99,
            padding: const EdgeInsets.all(0),
            child: Column(children: [
              const Spacer(),
              const Icon(Icons.visibility_outlined,
                  color: Colors.white, size: 25),
              Text(General.optimisedNumbers(widget.numViews),
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer()
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            widget.handleEditing(true);
          },
          child: const Icon(Icons.edit_outlined, color: Colors.white, size: 25),
        ),
        const SizedBox(width: 10),
        buildViewsButton()
      ],
    );
  }
}
