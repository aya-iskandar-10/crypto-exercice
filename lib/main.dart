import 'package:flutter/material.dart';
import 'views/crypto_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      home: const CryptoListScreen(),
    );
  }
}
