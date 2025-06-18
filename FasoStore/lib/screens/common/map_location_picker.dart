import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/location.dart';
import '../../widgets/location_selector.dart';

class MapLocationPicker extends StatefulWidget {
  final Location? initialLocation;

  const MapLocationPicker({
    super.key,
    this.initialLocation,
  });

  @override
  State<MapLocationPicker> createState() => _MapLocationPickerState();
}

class _MapLocationPickerState extends State<MapLocationPicker> {
  GoogleMapController? _mapController;
  LatLng? _selectedPosition;
  bool _isLoading = false;
  String _address = '';
  String _country = '';
  String _region = '';
  String _province = '';
  String _city = '';

  // Position par défaut (Bobo-Dioulasso)
  static const LatLng _defaultPosition = LatLng(11.1773, -4.2979);

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedPosition = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      _address = widget.initialLocation!.address;
      _city = widget.initialLocation!.city;
      _province = widget.initialLocation!.district;
    }
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permission de localisation refusée');
        }
      }

      final Position position = await Geolocator.getCurrentPosition();
      final LatLng currentPosition = LatLng(position.latitude, position.longitude);

      setState(() => _selectedPosition = currentPosition);

      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPosition,
            zoom: 15,
          ),
        ),
      );

      await _getAddressFromLatLng(currentPosition);
    } catch (e) {
      print('Erreur de localisation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'obtenir votre position')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        setState(() {
          _address = '${place.street}, ${place.subLocality}';
          _country = place.country ?? 'Burkina Faso'; // Par défaut
        });
      }
    } catch (e) {
      print('Erreur de géocodage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionner une adresse'),
        actions: [
          if (_selectedPosition != null && _city.isNotEmpty)
            TextButton(
              onPressed: _confirmLocation,
              child: const Text(
                'Confirmer',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedPosition ?? _defaultPosition,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  onTap: _onMapTapped,
                  markers: _selectedPosition == null
                      ? {}
                      : {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _selectedPosition!,
                            draggable: true,
                            onDragEnd: _onMapTapped,
                          ),
                        },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedPosition != null) ...[
                    const Text(
                      'Adresse sélectionnée',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_address),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],
                  LocationSelector(
                    initialCountry: _country,
                    initialRegion: _region,
                    initialProvince: _province,
                    initialCity: _city,
                    onLocationSelected: (country, region, province, city) {
                      setState(() {
                        _country = country;
                        _region = region;
                        _province = province;
                        _city = city;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onMapTapped(LatLng position) async {
    setState(() => _selectedPosition = position);
    await _getAddressFromLatLng(position);
  }

  void _confirmLocation() {
    if (_selectedPosition != null && _city.isNotEmpty) {
      final location = Location(
        id: DateTime.now().toString(),
        latitude: _selectedPosition!.latitude,
        longitude: _selectedPosition!.longitude,
        address: _address,
        city: _city,
        district: _province,
      );
      Navigator.pop(context, location);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner une ville'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
