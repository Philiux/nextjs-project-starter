import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/delivery.dart';
import '../../models/location.dart';
import '../../models/order.dart';
import '../../providers/delivery_provider.dart';
import '../../utils/helpers.dart';

class DeliveryOptionsScreen extends StatefulWidget {
  final Order order;
  final Location sellerLocation;

  const DeliveryOptionsScreen({
    super.key,
    required this.order,
    required this.sellerLocation,
  });

  @override
  State<DeliveryOptionsScreen> createState() => _DeliveryOptionsScreenState();
}

class _DeliveryOptionsScreenState extends State<DeliveryOptionsScreen> {
  DeliveryType _selectedType = DeliveryType.courier;
  Location? _deliveryLocation;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options de livraison'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSellerLocationCard(),
            const SizedBox(height: 16),
            _buildDeliveryTypeSelector(),
            const SizedBox(height: 16),
            if (_selectedType == DeliveryType.courier) ...[
              _buildDeliveryLocationSection(),
              if (_deliveryLocation != null) ...[
                const SizedBox(height: 16),
                _buildDeliveryFeeCard(),
              ],
            ],
            const SizedBox(height: 24),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSellerLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adresse du vendeur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.sellerLocation.address),
            Text(widget.sellerLocation.district),
            Text(widget.sellerLocation.city),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mode de livraison',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile<DeliveryType>(
              title: const Text('Livraison par coursier'),
              subtitle: const Text('Un coursier livrera votre commande'),
              value: DeliveryType.courier,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),
            RadioListTile<DeliveryType>(
              title: const Text('Récupération en boutique'),
              subtitle: const Text('Récupérez votre commande chez le vendeur'),
              value: DeliveryType.pickup,
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adresse de livraison',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectDeliveryLocation,
              icon: const Icon(Icons.add_location),
              label: const Text('Sélectionner l\'adresse de livraison'),
            ),
            if (_deliveryLocation != null) ...[
              const SizedBox(height: 16),
              Text(_deliveryLocation!.address),
              Text(_deliveryLocation!.district),
              Text(_deliveryLocation!.city),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryFeeCard() {
    final deliveryProvider = Provider.of<DeliveryProvider>(context);
    final fee = deliveryProvider.calculateDeliveryFee(
      widget.sellerLocation,
      _deliveryLocation!,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frais de livraison',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Helpers.formatPrice(fee),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _canProceed() ? _proceedToCheckout : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Continuer'),
      ),
    );
  }

  bool _canProceed() {
    if (_selectedType == DeliveryType.pickup) return true;
    return _deliveryLocation != null;
  }

  Future<void> _selectDeliveryLocation() async {
    final Location? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          initialLocation: _deliveryLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() => _deliveryLocation = selectedLocation);
      
      // Vérifier si le vendeur et l'acheteur sont dans la même ville
      if (!widget.sellerLocation.isInSameCity(_deliveryLocation!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La livraison n\'est disponible que dans la même ville que le vendeur.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _deliveryLocation = null);
      }
    }
  }

  Future<void> _proceedToCheckout() async {
    if (!_canProceed()) return;

    setState(() => _isLoading = true);

    try {
      final deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);
      
      if (_selectedType == DeliveryType.courier) {
        final delivery = await deliveryProvider.createDelivery(
          order: widget.order,
          pickupLocation: widget.sellerLocation,
          deliveryLocation: _deliveryLocation!,
          type: _selectedType,
        );

        if (delivery != null) {
          if (mounted) {
            Navigator.pop(context, delivery);
          }
        }
      } else {
        // Pour la récupération en boutique
        final delivery = await deliveryProvider.createDelivery(
          order: widget.order,
          pickupLocation: widget.sellerLocation,
          deliveryLocation: widget.sellerLocation, // Même adresse
          type: DeliveryType.pickup,
        );

        if (delivery != null) {
          if (mounted) {
            Navigator.pop(context, delivery);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
