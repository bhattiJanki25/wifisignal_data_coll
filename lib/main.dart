import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wifisignal_data_coll/screens/map_screen.dart';
import 'package:wifisignal_data_coll/screens/map_signal_strength_screen.dart';
import 'package:wifisignal_data_coll/screens/measure_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'bloc/wifi_cubit.dart';
import 'bloc/wifibgservice_cubit.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const MyApp());
}
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Perform background task
    return Future.value(true);
  });
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WifiCubit>(
          create: (context) => WifiCubit(),
        ),
        BlocProvider<WifiBackgroundCubit>(
          create: (context) => WifiBackgroundCubit()..startBackgroundService(),
        ),
      ],
      child: MaterialApp(
        title: 'Wi-Fi Signal Mapper',debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const  MapScreen(),
          '/measure': (context) => const MeasureScreen(longitude: 0,latitude: 0,),
          '/signal-map': (context) => const SignalMapScreen (lat: 0,long: 0,),
        },
      ),
    );
  }
}
