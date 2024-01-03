import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/config.dart';
import '../themes/light_mode.dart';
import '../models/product.dart';
import '../models/cart.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // get detail product
  Future<Product> _fetchProduct(int id) async {
    final response = await http.get(Uri.parse('$apiEndpoint/products/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // add to cart
  Future<void> _addToCart(Product product) async {
    final cart = Cart(
      id: product.id!,
      title: product.title!,
      description: product.description!,
      image: product.image!,
      price: product.price!,
      quantity: 1,
    );
    await cart.addToCart(cart);
  }

  @override
  Widget build(BuildContext context) {
    final Product args = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            args.title!,
            style: const TextStyle(
              color: Color.fromARGB(255, 226, 223, 223),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: themeData.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _fetchProduct(args.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _detailProduct(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // detail product
  Widget _detailProduct(Product product) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Image.network(
                product.image!,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              Text(
                product.title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.description!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${product.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              backgroundColor: themeData.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            onPressed: () {
              _addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to Cart'),
                ),
              );
            },
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
