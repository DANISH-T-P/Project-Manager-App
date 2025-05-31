import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final double initialLat;
  final double initialLng;
  final Function(double, double) onLocationSelected;

  const LocationPicker({
    super.key,
    required this.initialLat,
    required this.initialLng,
    required this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late LatLng _pickedPosition;

  @override
  void initState() {
    super.initState();
    _pickedPosition = LatLng(widget.initialLat, widget.initialLng);
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  Future<void> _getCurrentLocation() async {
    final loc = await Geolocator.getCurrentPosition();
    setState(() {
      _pickedPosition = LatLng(loc.latitude, loc.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedPosition,
              zoom: 15,
            ),
            markers: {
              Marker(markerId: const MarkerId('selected'), position: _pickedPosition),
            },
            onTap: _onMapTapped,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Current Location"),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onLocationSelected(_pickedPosition.latitude, _pickedPosition.longitude);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Select"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
