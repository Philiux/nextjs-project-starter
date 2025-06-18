import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';
import '../providers/cart_provider.dart';

class BuyerHome extends StatelessWidget {
  const BuyerHome({super.key});

  final List<Product> sampleProducts = const [
    Product(
      id: '1',
      name: 'Produit 1',
      description: 'Description du produit 1',
      price: 10000,
      imageUrl: 'https://via.placeholder.com/150',
      sellerId: 'seller1',
    ),
    Product(
      id: '2',
      name: 'Produit 2',
      description: 'Description du produit 2',
      price: 20000,
      imageUrl: 'https://via.placeholder.com/150',
      sellerId: 'seller2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: ProductListScreen(products: sampleProducts),
    );
  }
}
