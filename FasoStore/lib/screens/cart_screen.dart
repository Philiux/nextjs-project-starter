import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/commission.dart';
import 'buyer/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalWithCommission = calculateTotalWithCommission(cart.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                return ListTile(
                  leading: Image.network(cartItem.product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(cartItem.product.name),
                  subtitle: Text('Quantité: ${cartItem.quantity}'),
                  trailing: Text('${(cartItem.product.price * cartItem.quantity).toStringAsFixed(2)} FCFA'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total avec commission: ${totalWithCommission.toStringAsFixed(2)} FCFA'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutScreen()),
              );
            },
            child: const Text('Passer à la caisse'),
          ),
        ],
      ),
    );
  }
}
