import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/delivery.dart';
import '../../providers/delivery_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/helpers.dart';

class CourierDashboard extends StatefulWidget {
  const CourierDashboard({super.key});

  @override
  State<CourierDashboard> createState() => _CourierDashboardState();
}

class _CourierDashboardState extends State<CourierDashboard> {
  @override
  void initState() {
    super.initState();
    // Commencer à écouter les livraisons du coursier
    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId != null) {
      Provider.of<DeliveryProvider>(context, listen: false)
          .listenToCourierDeliveries(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tableau de bord Coursier'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Livraisons actives'),
              Tab(text: 'Historique'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActiveDeliveriesTab(),
            _DeliveryHistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _ActiveDeliveriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, child) {
        if (deliveryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (deliveryProvider.error != null) {
          return Center(child: Text(deliveryProvider.error!));
        }

        final activeDeliveries = deliveryProvider.activeDeliveries
            .where((d) => d.status != DeliveryStatus.delivered &&
                d.status != DeliveryStatus.cancelled)
            .toList();

        if (activeDeliveries.isEmpty) {
          return const Center(
            child: Text('Aucune livraison active pour le moment'),
          );
        }

        return ListView.builder(
          itemCount: activeDeliveries.length,
          itemBuilder: (context, index) {
            final delivery = activeDeliveries[index];
            return _DeliveryCard(delivery: delivery);
          },
        );
      },
    );
  }
}

class _DeliveryHistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryProvider>(
      builder: (context, deliveryProvider, child) {
        final completedDeliveries = deliveryProvider.activeDeliveries
            .where((d) =>
                d.status == DeliveryStatus.delivered ||
                d.status == DeliveryStatus.cancelled)
            .toList();

        if (completedDeliveries.isEmpty) {
          return const Center(
            child: Text('Aucun historique de livraison'),
          );
        }

        return ListView.builder(
          itemCount: completedDeliveries.length,
          itemBuilder: (context, index) {
            final delivery = completedDeliveries[index];
            return _DeliveryCard(
              delivery: delivery,
              isHistory: true,
            );
          },
        );
      },
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final Delivery delivery;
  final bool isHistory;

  const _DeliveryCard({
    required this.delivery,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Commande #${delivery.order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _StatusChip(status: delivery.status),
              ],
            ),
            const Divider(),
            _LocationInfo(
              icon: Icons.location_on,
              title: 'Lieu de retrait',
              address: delivery.pickupLocation.address,
              district: delivery.pickupLocation.district,
            ),
            const SizedBox(height: 8),
            _LocationInfo(
              icon: Icons.flag,
              title: 'Lieu de livraison',
              address: delivery.deliveryLocation.address,
              district: delivery.deliveryLocation.district,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Frais de livraison: ${Helpers.formatPrice(delivery.deliveryFee)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (!isHistory) _ActionButtons(delivery: delivery),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DeliveryStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        status.toString().split('.').last,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: status.statusColor,
    );
  }
}

class _LocationInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;
  final String district;

  const _LocationInfo({
    required this.icon,
    required this.title,
    required this.address,
    required this.district,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                address,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                district,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Delivery delivery;

  const _ActionButtons({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (delivery.status == DeliveryStatus.accepted)
          ElevatedButton(
            onPressed: () => deliveryProvider.updateDeliveryStatus(
              delivery.id,
              DeliveryStatus.pickedUp,
            ),
            child: const Text('Colis récupéré'),
          ),
        if (delivery.status == DeliveryStatus.pickedUp)
          ElevatedButton(
            onPressed: () => deliveryProvider.updateDeliveryStatus(
              delivery.id,
              DeliveryStatus.delivered,
            ),
            child: const Text('Marquer comme livré'),
          ),
      ],
    );
  }
}
