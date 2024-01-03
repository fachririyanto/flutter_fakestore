import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/cart.dart';
import './pages/detail_product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/product': (context) => const DetailProductPage(),
        '/cart': (context) => const CartPage(),
      },
    );
  }
}
