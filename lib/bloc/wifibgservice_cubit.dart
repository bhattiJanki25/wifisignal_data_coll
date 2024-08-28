import 'package:bloc/bloc.dart';
import 'package:workmanager/workmanager.dart';

class WifiBackgroundCubit extends Cubit<int?> {
  WifiBackgroundCubit() : super(null);

  void startBackgroundService() {
    Workmanager().registerPeriodicTask(
      "1",
      "wifiSignalTask",
      frequency: const Duration(minutes: 15),
    );
  }
}
