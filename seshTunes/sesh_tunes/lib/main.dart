import 'package:flutter/material.dart';
import 'strain_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Strain Carousel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StrainView(), // Create the carousel directly
    );
  }
}
