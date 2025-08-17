// lib/main.dart
import 'package:flutter/material.dart';
import 'shoe_store_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shoe Store',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ShoeStorePage(),
    );
  }
}
