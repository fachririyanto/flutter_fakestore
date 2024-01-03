import 'package:flutter/material.dart';
import '../components/drawer.dart';
import '../themes/light_mode.dart';
import '../models/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>> _futureCart = Cart().getCart();

  @override
  void initState() {
    super.initState();
  }

  // update future cart
  void _updateFutureCart() {
    setState(() {
      _futureCart = Cart().getCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Cart',
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
              // show dialog
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Clear cart'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Cart().clearCart();
                          _updateFutureCart();
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_outline_outlined),
          ),
        ],
      ),
      drawer: const StoreDrawer(),
      body: FutureBuilder(
        future: _futureCart,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Cart is empty'),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _cartItem(snapshot.data![index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // cart item
  Widget _cartItem(Cart cart) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        // bottom border
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.0),
                image: DecorationImage(
                  image: NetworkImage(cart.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // title, price
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    cart.title!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // price
                  Text(
                    '\$${cart.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // remove button
                  InkWell(
                    onTap: () {
                      Cart().removeFromCart(cart.id!);
                      _updateFutureCart();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: const Text(
                        'Remove',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // quantity and plus minus button
          Container(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                // plus button
                InkWell(
                  onTap: () {
                    if (cart.quantity! < 10) {
                      Cart().updateQuantity(cart.id!, cart.quantity! + 1);
                      _updateFutureCart();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // quantity
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Text(
                    cart.quantity.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFf91089),
                    ),
                  ),
                ),

                // minus button
                InkWell(
                  onTap: () {
                    if (cart.quantity! > 1) {
                      Cart().updateQuantity(cart.id!, cart.quantity! - 1);
                      _updateFutureCart();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
