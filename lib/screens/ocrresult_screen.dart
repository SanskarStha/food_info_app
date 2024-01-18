import 'package:flutter/material.dart';

class OCRResultScreen extends StatelessWidget {
  final String text;

  const OCRResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('OCR Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );
}
