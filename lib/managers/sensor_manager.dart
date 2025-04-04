import 'dart:async';
import 'package:temperature/models/sensor.dart';
import 'package:temperature/services/server_communication.dart';
import 'package:temperature/utils/functions.dart';

/// Classe représentant un capteur de température et d'humidité
class SensorManager {
  Sensor sensor = Sensor(
    "1",
    "Temperature Sensor From Server",
    "temperature_sensor",
    clientAttributes: {'Serial Number': 'TS-001'},
    serverAttributes: {'Location': 'Living Room'},
    telemetryData: {'temperature': '22.5 °C'},
  );
  double _temperature = 00.0; // Température initiale en °C
  double _humidity = 00.0; // Humidité initiale en %
  bool isActive = true; // Mode actif ou veille
  Timer? timer;
  Timer? _temperatureTimer; // Timer pour l'envoi des données de température
  Timer? _humidityTimer; // Timer pour l'envoi des données d'humidité

  /// Précision demandée pour la température (0.1°C)
  static const int tempPrecision = 2;

  /// Précision demandée pour l'humidité (1%)
  static const int humidityPrecision = 3;

  int _interval = 5;

  /// Accesseurs pour récupérer la température et l'humidité
  double get temperature => _temperature;
  double get humidity => _humidity;

  void launch(Function refresh) async {
    timer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      double temp = generateTemperature(tempPrecision);
      _temperature = temp;
      _humidity = temp;
      print("Generated Temperature: $temperature°C");
      await sendDataToServer();
      //   await ServerCommunication.sendDataToServer(
      //     sensor,
      //     _temperature,
      //     _humidity,
      //   );
      refresh();
    });
  }

  /// Met à jour la température avec une valeur falsifiable
  /// Arrondi à la précision de 0.1°C
  void setTemperature(double value) {
    _temperature = value; // Arrondi à 0.1°C
  }

  /// Met à jour l'humidité avec une valeur falsifiable
  /// Arrondi à la précision de 1%
  void setHumidity(double value) {
    _humidity = value.roundToDouble(); // Arrondi à 1%
  }

  /// Démarre l'envoi des données de température
  /// Cette méthode envoie la température toutes les 10s (mode actif)
  /// ou toutes les 20s (mode veille).
  Future<void> sendDataToServer() async {
    // stopTemperatureTransmission(); // Annule l'ancien timer si existant
    await ServerCommunication.sendDataToServer(sensor, _temperature, _humidity);
  }

  /// Arrête l'envoi des données de température
  /// Cette méthode annule le timer d'envoi de température
  void stopTemperatureTransmission() {
    // _temperatureTimer?.cancel();
    timer?.cancel();
  }

  /// Arrête l'envoi des données d'humidité
  /// Cette méthode annule le timer d'envoi d'humidité
  void stopHumidityTransmission() {
    _humidityTimer?.cancel();
  }

  /// Change le mode entre actif et veille
  /// Cette méthode alterne entre le mode actif et veille,
  /// puis redémarre les envois de température et d'humidité.
  void toggleMode() {
    isActive = !isActive; // Change le mode entre actif et veille
    print("Mode changé: ${isActive ? 'Actif' : 'Veille'}");

    // Redémarre l'envoi des données en fonction du mode
    sendDataToServer();
  }
}
