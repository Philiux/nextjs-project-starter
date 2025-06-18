import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/location_data.dart';
import '../../models/delivery.dart';
import '../../providers/delivery_zones_provider.dart';
import '../../services/delivery_zones_service.dart';

class DeliveryZonesScreen extends StatefulWidget {
  const DeliveryZonesScreen({super.key});

  @override
  State<DeliveryZonesScreen> createState() => _DeliveryZonesScreenState();
}

class _DeliveryZonesScreenState extends State<DeliveryZonesScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<DeliveryZonesProvider>(context, listen: false);
    await provider.initializeDefaultSettings();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des zones de livraison'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Burkina Faso'),
              Tab(text: 'Mali'),
              Tab(text: 'Niger'),
            ],
          ),
        ),
        body: Consumer<DeliveryZonesProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              children: [
                _buildCountryTab('Burkina Faso', provider),
                _buildCountryTab('Mali', provider),
                _buildCountryTab('Niger', provider),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Réinitialiser les paramètres'),
                content: const Text(
                  'Voulez-vous réinitialiser tous les paramètres de livraison aux valeurs par défaut ?'
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Réinitialiser'),
                  ),
                ],
              ),
            );

            if (confirmed == true && mounted) {
              await Provider.of<DeliveryZonesProvider>(context, listen: false)
                  .initializeDefaultSettings();
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paramètres réinitialisés avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Réinitialiser'),
        ),
      ),
    );
  }

  Widget _buildCountryTab(String country, DeliveryZonesProvider provider) {
    final regions = CountryData.getRegions(country);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: regions.length,
      itemBuilder: (context, index) {
        final region = regions[index];
        final settings = provider.getZoneSettings(country, region);
        final isActive = settings?.isActive ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          region,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          isActive ? 'Zone active' : 'Zone inactive',
                          style: TextStyle(
                            fontSize: 12,
                            color: isActive ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive,
                    onChanged: (value) async {
                      await provider.toggleZoneStatus(country, region);
                    },
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeeSection(country, region, provider, settings),
                      const Divider(height: 32),
                      _buildLocationDetails(country, region),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeeSection(
    String country,
    String region,
    DeliveryZonesProvider provider,
    DeliveryZoneSettings? settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tarifs de livraison',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildFeeField(
                'Frais de base (FCFA)',
                settings?.baseFee ?? 500,
                (value) async {
                  if (value != null) {
                    await provider.updateZoneSettings(
                      DeliveryZoneSettings(
                        country: country,
                        region: region,
                        baseFee: value,
                        kmFee: settings?.kmFee ?? 100,
                        isActive: settings?.isActive ?? true,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildFeeField(
                'Frais par km (FCFA)',
                settings?.kmFee ?? 100,
                (value) async {
                  if (value != null) {
                    await provider.updateZoneSettings(
                      DeliveryZoneSettings(
                        country: country,
                        region: region,
                        baseFee: settings?.baseFee ?? 500,
                        kmFee: value,
                        isActive: settings?.isActive ?? true,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Exemple : Une livraison de 5 km coûtera ${((settings?.baseFee ?? 500) + ((settings?.kmFee ?? 100) * 5)).toStringAsFixed(0)} FCFA',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildFeeField(
    String label,
    double initialValue,
    Function(double?) onChanged,
  ) {
    return TextFormField(
      initialValue: initialValue.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) => onChanged(double.tryParse(value)),
    );
  }

  Widget _buildLocationDetails(String country, String region) {
    final provinces = CountryData.getProvinces(country, region);
    final cities = CountryData.countries[country]
        ?.firstWhere((r) => r.name == region)
        .mainCities;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Provinces/Cercles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: provinces.map((province) {
            return Chip(
              label: Text(province),
              backgroundColor: Colors.grey.withOpacity(0.1),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Villes principales',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cities?.map((city) {
            return Chip(
              label: Text(city),
              backgroundColor: Colors.blue.withOpacity(0.1),
            );
          }).toList() ?? [],
        ),
      ],
    );
  }
}
