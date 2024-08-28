import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class SignalMapScreen extends StatefulWidget {
  final double lat,long;
  const SignalMapScreen({super.key, required this.lat, required this.long});

  @override
  State<SignalMapScreen> createState() => _SignalMapScreenState();
}

class _SignalMapScreenState extends State<SignalMapScreen> {
  List<Map<String, dynamic>> _signalDataList = [];
  @override
  void initState() {
    super.initState();
    _loadSignalData();
  }
// get wifi all data from db and show using wifi icon marker green color on google Map
  Future<void> _loadSignalData() async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), 'wifi_data.db'),
    );

    final List<Map<String, dynamic>> signalData = await database.query('wifi_data');
    signalData.forEach((data) {
      print('ID: ${data['id']}, Lat: ${data['latitude']}, '
          'Lon: ${data['longitude']}, Signal: ${data['signalStrength']} dBm, '
          'Timestamp: ${data['timestamp']}');
    });
    setState(() {
      _signalDataList = signalData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signal Map'),
      ),
      body:FlutterMap(
            options:  MapOptions(
              initialCenter: LatLng(widget.lat, widget.long),
              minZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),

              MarkerLayer(
                markers: _signalDataList.map((signalData) {
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: LatLng(signalData['latitude'], signalData['longitude']),
                    child: const Icon(
                      Icons.wifi,
                      color:Colors.red,
                      size: 50.0,
                    ),
                  );
                }).toList(),
          )]
      ),
    );
  }
}
