import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/location.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../common/map_location_picker.dart';

class ShopLocationScreen extends StatefulWidget {
  const ShopLocationScreen({super.key});

  @override
  State<ShopLocationScreen> createState() => _ShopLocationScreenState();
}

class _ShopLocationScreenState extends State<ShopLocationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Erreur: Utilisateur non connecté'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Localisation de la boutique'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configurez la localisation de votre boutique pour permettre aux clients de vous trouver facilement.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (user.shopLocation != null) ...[
              _buildCurrentLocation(user.shopLocation!),
              const SizedBox(height: 16),
            ],
            _buildLocationButton(user),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocation(Location location) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adresse actuelle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(location.address),
            Text(location.district),
            Text(location.city),
            const SizedBox(height: 8),
            Text(
              'Coordonnées: ${location.latitude}, ${location.longitude}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationButton(UserModel user) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _selectLocation(user),
        icon: const Icon(Icons.location_on),
        label: Text(
          user.shopLocation == null
              ? 'Définir la localisation'
              : 'Modifier la localisation',
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Future<void> _selectLocation(UserModel user) async {
    final Location? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPicker(
          initialLocation: user.shopLocation,
        ),
      ),
    );

    if (selectedLocation != null && mounted) {
      setState(() => _isLoading = true);

      try {
        // Mettre à jour l'utilisateur avec la nouvelle localisation
        final updatedUser = user.copyWith(shopLocation: selectedLocation);
        
        // Mettre à jour dans Firebase et localement
        await Provider.of<UserProvider>(context, listen: false)
            .updateUser(updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Localisation de la boutique mise à jour avec succès'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
