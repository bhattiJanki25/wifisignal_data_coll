import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wifi_cubit.dart';
import 'map_signal_strength_screen.dart';
class MeasureScreen extends StatefulWidget {
  final double latitude,longitude;
  const MeasureScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<MeasureScreen> createState() => _MeasureScreenState();
}
class _MeasureScreenState extends State<MeasureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Measure Signal Strength'),
      ),
      body: BlocBuilder<WifiCubit, int?>(
        builder: (context, signalStrength) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Location: ${widget.latitude}, ${widget.longitude}',
              ),
              Text(
                signalStrength != null
                    ? 'Signal Strength: $signalStrength dBm'
                    : 'No Signal Data',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<WifiCubit>().fetchAndSaveSignalStrength(widget.latitude,widget.longitude);
                  },
                  child: const Text('Capture'),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignalMapScreen(lat:widget.latitude,long:widget.longitude)),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}
