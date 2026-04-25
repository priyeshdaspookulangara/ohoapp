import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng initialPosition;
  const MapPickerScreen({super.key, this.initialPosition = const LatLng(-1.286389, 36.817223)}); // Default Nairobi

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late LatLng _selectedPosition;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedPosition),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: widget.initialPosition, zoom: 15),
        onTap: (position) {
          setState(() => _selectedPosition = position);
        },
        markers: {
          Marker(markerId: const MarkerId('selected'), position: _selectedPosition),
        },
      ),
    );
  }
}
