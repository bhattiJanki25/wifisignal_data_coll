import 'package:bloc/bloc.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WifiCubit extends Cubit<int?> {
  WifiCubit() : super(null) {
    _initializeDatabase();
  }

  late Database _database;

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'wifi_data.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE wifi_data(id INTEGER PRIMARY KEY AUTOINCREMENT, timestamp TEXT,latitude REAL ,longitude REAL, signalStrength INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> fetchAndSaveSignalStrength(double latitude, longitude ) async {
    try {
      int? signalStrength = await WiFiForIoTPlugin.getCurrentSignalStrength();
      if (signalStrength != null) {
        emit(signalStrength);
        await _database.insert(
          'wifi_data',
          {'timestamp': DateTime.now().toIso8601String(),'latitude':latitude,'longitude':longitude, 'signalStrength': signalStrength},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print("insert succ...");
      }
    } catch (e) {
      emit(null); // Handle errors
    }
  }
}
