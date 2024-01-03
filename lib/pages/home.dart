import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../components/drawer.dart';
import '../utils/config.dart';
import '../themes/light_mode.dart';
import '../models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>>? _futureProducts;

  Future<List<Product>> _fetchProducts() async {
    final response = await http.get(Uri.parse('$apiEndpoint/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'App Store',
              style: TextStyle(
                color: Colors.white,
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
        drawer: const StoreDrawer(),
        body: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return MasonryGridView.count(
                    padding: const EdgeInsets.all(8.0),
                    crossAxisCount: 2,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return _productCard(snapshot.data![index]);
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  // product card
  Widget _productCard(Product product) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: product);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: List.generate(
              10,
              (index) => BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, .2),
              ),
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                height: 160,
                child: Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 16),
                child: Text(
                  product.title!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.3,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8),
                alignment: Alignment.centerRight,
                child: Text(
                  '\$${product.price}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
