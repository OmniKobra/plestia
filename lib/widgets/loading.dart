import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  bool isShown = false;
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() {
          isShown = !isShown;
        });
      }
    });
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 450),
                opacity: isShown ? 1.0 : 0.25,
                child: Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/plestia-akkad.appspot.com/o/assets%2Fplestia.png?alt=media&token=9e516780-bcfb-4825-a49d-acd667c19b02&_gl=1*qf96le*_ga*MTI0NzA5NzQxOC4xNjg1NzI1NjAx*_ga_CW55HF8NVT*MTY5ODMyNzEzOC44LjEuMTY5ODMyNzM1MC40MC4wLjA.',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ))
        ]);
  }
}
