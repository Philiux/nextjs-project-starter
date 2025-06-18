import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final sellerOrders = orderProvider.orders.where((order) => order.userId == 'currentSellerId').toList(); // TODO: Remplacer par l'ID réel du vendeur

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des commandes'),
      ),
      body: sellerOrders.isEmpty
          ? const Center(child: Text('Aucune commande trouvée.'))
          : ListView.builder(
              itemCount: sellerOrders.length,
              itemBuilder: (context, index) {
                final order = sellerOrders[index];
                return ListTile(
                  title: Text('Commande #${order.id}'),
                  subtitle: Text('Statut: ${order.status.toString().split('.').last}'),
                  trailing: DropdownButton<OrderStatus>(
                    value: order.status,
                    items: OrderStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        final updatedOrder = Order(
                          id: order.id,
                          userId: order.userId,
                          items: order.items,
                          totalAmount: order.totalAmount,
                          status: newStatus,
                          orderDate: order.orderDate,
                        );
                        orderProvider.updateOrder(order.id, updatedOrder);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
