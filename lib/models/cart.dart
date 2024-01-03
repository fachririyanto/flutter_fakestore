import '../utils/db.dart';

class Cart {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final double? price;
  final int? quantity;

  Cart({
    this.id,
    this.title,
    this.description,
    this.image,
    this.price,
    this.quantity,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }

  // get all cart
  Future<List<Cart>> getCart() async {
    final db = await DatabaseHelper().db;
    final List<Map<String, dynamic>> maps = await db!.query('fakestore_cart');

    return List.generate(maps.length, (i) {
      return Cart(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        image: maps[i]['image'],
        price: maps[i]['price'],
        quantity: maps[i]['quantity'],
      );
    });
  }

  // add to cart
  Future<void> addToCart(Cart cart) async {
    final db = await DatabaseHelper().db;

    // check if product already in cart
    final List<Map<String, dynamic>> maps = await db!.query(
      'fakestore_cart',
      where: 'id = ?',
      whereArgs: [cart.id],
    );

    // if product already in cart, update quantity
    if (maps.isNotEmpty) {
      if (maps[0]['quantity'] == 10) return;

      await db.update(
        'fakestore_cart',
        {
          'quantity': maps[0]['quantity'] + 1,
        },
        where: 'id = ?',
        whereArgs: [cart.id],
      );
      return;
    }

    // if product not in cart, insert to cart
    await db.insert('fakestore_cart', {
      'id': cart.id,
      'title': cart.title,
      'description': cart.description,
      'image': cart.image,
      'price': cart.price,
      'quantity': cart.quantity,
    });
  }

  // update quantity
  Future<void> updateQuantity(int id, int quantity) async {
    final db = await DatabaseHelper().db;
    await db!.update(
      'fakestore_cart',
      {
        'quantity': quantity,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // remove from cart
  Future<void> removeFromCart(int id) async {
    final db = await DatabaseHelper().db;
    await db!.delete(
      'fakestore_cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // clear cart
  Future<void> clearCart() async {
    final db = await DatabaseHelper().db;
    await db!.delete('fakestore_cart');
  }
}
