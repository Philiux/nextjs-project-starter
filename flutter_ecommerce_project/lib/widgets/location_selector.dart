import 'package:flutter/material.dart';
import '../utils/location_data.dart';

class LocationSelector extends StatefulWidget {
  final Function(String country, String region, String province, String city) onLocationSelected;
  final String? initialCountry;
  final String? initialRegion;
  final String? initialProvince;
  final String? initialCity;

  const LocationSelector({
    super.key,
    required this.onLocationSelected,
    this.initialCountry,
    this.initialRegion,
    this.initialProvince,
    this.initialCity,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String? _selectedCountry;
  String? _selectedRegion;
  String? _selectedProvince;
  String? _selectedCity;

  List<String> _countries = [];
  List<String> _regions = [];
  List<String> _provinces = [];
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _countries = CountryData.countries.keys.toList();
    
    // Initialiser avec les valeurs fournies
    if (widget.initialCountry != null) {
      _selectedCountry = widget.initialCountry;
      _updateRegions();
      
      if (widget.initialRegion != null) {
        _selectedRegion = widget.initialRegion;
        _updateProvinces();
        
        if (widget.initialProvince != null) {
          _selectedProvince = widget.initialProvince;
          _updateCities();
          
          if (widget.initialCity != null) {
            _selectedCity = widget.initialCity;
          }
        }
      }
    }
  }

  void _updateRegions() {
    if (_selectedCountry != null) {
      setState(() {
        _regions = CountryData.getRegions(_selectedCountry!);
        _selectedRegion = null;
        _selectedProvince = null;
        _selectedCity = null;
        _provinces = [];
        _cities = [];
      });
    }
  }

  void _updateProvinces() {
    if (_selectedCountry != null && _selectedRegion != null) {
      setState(() {
        _provinces = CountryData.getProvinces(_selectedCountry!, _selectedRegion!);
        _selectedProvince = null;
        _selectedCity = null;
        _cities = [];
      });
    }
  }

  void _updateCities() {
    if (_selectedCountry != null) {
      final regionData = CountryData.countries[_selectedCountry!]?.firstWhere(
        (r) => r.name == _selectedRegion,
        orElse: () => const RegionData(name: '', provinces: [], mainCities: []),
      );
      
      if (regionData != null) {
        setState(() {
          _cities = regionData.mainCities;
          _selectedCity = null;
        });
      }
    }
  }

  void _notifySelection() {
    if (_selectedCountry != null &&
        _selectedRegion != null &&
        _selectedProvince != null &&
        _selectedCity != null) {
      widget.onLocationSelected(
        _selectedCountry!,
        _selectedRegion!,
        _selectedProvince!,
        _selectedCity!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          label: 'Pays',
          value: _selectedCountry,
          items: _countries,
          onChanged: (value) {
            setState(() {
              _selectedCountry = value;
            });
            _updateRegions();
          },
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Région',
          value: _selectedRegion,
          items: _regions,
          onChanged: (value) {
            setState(() {
              _selectedRegion = value;
            });
            _updateProvinces();
          },
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Province',
          value: _selectedProvince,
          items: _provinces,
          onChanged: (value) {
            setState(() {
              _selectedProvince = value;
            });
            _updateCities();
          },
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: 'Ville',
          value: _selectedCity,
          items: _cities,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
            });
            _notifySelection();
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              hint: Text('Sélectionner $label'),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
