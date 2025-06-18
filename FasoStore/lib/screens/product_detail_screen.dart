import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text('${product.price.toStringAsFixed(2)} FCFA', style: Theme.of(context).textTheme.subtitle1),
            const SizedBox(height: 16),
            Text(product.description),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produit ajouté au panier')),
                );
              },
              child: const Text('Ajouter au panier'),
            ),
          ],
        ),
      ),
    );
  }
}
