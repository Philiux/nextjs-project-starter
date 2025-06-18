import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des commandes'),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Aucune commande trouvée.'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('Commande #${order.id}'),
                  subtitle: Text('Statut: ${order.status.toString().split('.').last}'),
                  trailing: Text('${order.totalAmount.toStringAsFixed(2)} FCFA'),
                  onTap: () {
                    // TODO: Afficher les détails de la commande
                  },
                );
              },
            ),
    );
  }
}
