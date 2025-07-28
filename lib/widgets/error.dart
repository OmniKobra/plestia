// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../general.dart';

class MyErrorWidget extends StatelessWidget {
  final void Function() retry;
  const MyErrorWidget(this.retry);

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final widthQuery = MediaQuery.of(context).size.width >= 800;
    final lang = General.language(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Icon(Icons.error, color: Colors.grey, size: 70)),
          const SizedBox(height: 10),
          Center(
              child: Text(lang.error1,
                  style: TextStyle(
                      color: Colors.grey, fontSize: widthQuery ? 20 : 16))),
          const SizedBox(height: 10),
          Center(
              child: TextButton(
                  onPressed: retry,
                  style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      elevation: MaterialStateProperty.all<double?>(0),
                      shape: MaterialStateProperty.all<OutlinedBorder?>(
                          const BeveledRectangleBorder()),
                      backgroundColor:
                          MaterialStateProperty.all<Color?>(secondaryColor)),
                  child: Text(
                    lang.error2,
                    style: TextStyle(
                        color: Colors.white, fontSize: widthQuery ? 17 : 13),
                  )))
        ]);
  }
}
