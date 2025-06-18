import 'package:flutter/material.dart';
import '../../models/delivery_vehicle.dart';
import '../../services/vehicle_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleManagementScreen extends StatefulWidget {
  const VehicleManagementScreen({super.key});

  @override
  State<VehicleManagementScreen> createState() => _VehicleManagementScreenState();
}

class _VehicleManagementScreenState extends State<VehicleManagementScreen> {
  final VehicleService _vehicleService = VehicleService();
  List<DeliveryVehicle> _vehicles = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Simuler le chargement des véhicules (à remplacer par l'appel réel)
      await Future.delayed(const Duration(seconds: 1));
      // final vehicles = await _vehicleService.getAllVehicles();
      final vehicles = []; // Temporaire

      setState(() {
        _vehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur lors du chargement des véhicules: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Véhicules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddVehicleDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau Véhicule'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadVehicles,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_vehicles.isEmpty) {
      return const Center(
        child: Text('Aucun véhicule enregistré'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _vehicles[index];
        return _buildVehicleCard(vehicle);
      },
    );
  }

  Widget _buildVehicleCard(DeliveryVehicle vehicle) {
    final bool needsInspection = vehicle.necessiteControle;
    final bool documentsValid = vehicle.documentsValides;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: vehicle.isActive ? Colors.green : Colors.grey,
          child: Icon(
            _getVehicleIcon(vehicle.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          vehicle.matricule,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getVehicleTypeName(vehicle.type)),
            if (needsInspection)
              const Text(
                'Contrôle technique requis',
                style: TextStyle(color: Colors.orange),
              ),
            if (!documentsValid)
              const Text(
                'Documents expirés',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Capacité', '${vehicle.capaciteKg} kg / ${vehicle.capaciteM3} m³'),
                _buildInfoRow('Zones', vehicle.zonesAutorisees.join(', ')),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showEditVehicleDialog(context, vehicle),
                      icon: const Icon(Icons.edit),
                      label: const Text('Modifier'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showDocumentsDialog(context, vehicle),
                      icon: const Icon(Icons.description),
                      label: const Text('Documents'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _recordInspection(vehicle),
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Contrôle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: needsInspection ? Colors.orange : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.moto:
        return Icons.motorcycle;
      case VehicleType.tricycle:
        return Icons.pedal_bike;
      case VehicleType.voiture:
        return Icons.directions_car;
      case VehicleType.camionnette:
        return Icons.local_shipping;
    }
  }

  String _getVehicleTypeName(VehicleType type) {
    switch (type) {
      case VehicleType.moto:
        return 'Moto';
      case VehicleType.tricycle:
        return 'Tricycle';
      case VehicleType.voiture:
        return 'Voiture';
      case VehicleType.camionnette:
        return 'Camionnette';
    }
  }

  Future<void> _showFilterDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filtrer les véhicules'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('Véhicules actifs uniquement'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Nécessitant un contrôle'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('Documents à jour uniquement'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Appliquer les filtres
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddVehicleDialog(BuildContext context) async {
    // TODO: Implémenter l'ajout de véhicule
  }

  Future<void> _showEditVehicleDialog(BuildContext context, DeliveryVehicle vehicle) async {
    // TODO: Implémenter la modification de véhicule
  }

  Future<void> _showDocumentsDialog(BuildContext context, DeliveryVehicle vehicle) async {
    // TODO: Implémenter la gestion des documents
  }

  Future<void> _recordInspection(DeliveryVehicle vehicle) async {
    try {
      await _vehicleService.recordVehicleInspection(vehicle.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contrôle technique enregistré avec succès'),
          backgroundColor: Colors.green,
        ),
      );
      _loadVehicles();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
