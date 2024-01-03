import 'package:flutter/material.dart';
import '../themes/light_mode.dart';

class StoreDrawer extends StatelessWidget {
  const StoreDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themeData.colorScheme.primary,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // header
            const Column(
              children: [
                // icon
                SizedBox(
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 80,
                  ),
                ),

                // title
                SizedBox(height: 8),

                Text(
                  'App Store',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // menu items
            const SizedBox(height: 24),

            // home
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              leading: const Icon(
                Icons.store_outlined,
                color: Colors.white,
                size: 28,
              ),
              title: const Text(
                'Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // cart
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
              leading: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 28,
              ),
              title: const Text(
                'Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
