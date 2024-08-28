import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'measure_screen.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }
  // get current location and permission
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // If permissions are granted, get the current location
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Screen'),
      ),
      body: _currentPosition==null?Container():FlutterMap(
            options:  MapOptions(
              initialCenter: LatLng(_currentPosition!.latitude,_currentPosition!.longitude),
              minZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              ),
              MarkerLayer(
                markers:markerList(),
              ),
            ],
          ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MeasureScreen(latitude: _currentPosition!.latitude,longitude: _currentPosition!.longitude,)),
          );
        },
        child: Icon(Icons.wifi),
      ),
    );
  }
  List<Marker> markerList(){
    return [
      Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        child: const Icon(
          Icons.location_on,
          color:Colors.red,
          size: 50.0,
        ),
      )
    ];
  }
}
