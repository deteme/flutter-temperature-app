import 'dart:async';
import 'package:temperature/services/server_communication.dart'; 

/// Classe représentant un capteur de température et d'humidité
class TemperatureSensor {
  double _temperature = 20.0; // Température initiale en °C
  double _humidity = 50.0;    // Humidité initiale en %
  bool isActive = true;       // Mode actif ou veille
  Timer? _temperatureTimer;   // Timer pour l'envoi des données de température
  Timer? _humidityTimer;      // Timer pour l'envoi des données d'humidité

  /// Précision demandée pour la température (0.1°C)
  static const double tempPrecision = 0.1;
  /// Précision demandée pour l'humidité (1%)
  static const double humidityPrecision = 1.0;

  /// Accesseurs pour récupérer la température et l'humidité
  double get temperature => _temperature;
  double get humidity => _humidity;

  /// Met à jour la température avec une valeur falsifiable
  /// Arrondi à la précision de 0.1°C
  void setTemperature(double value) {
    _temperature = (value * 10).round() / 10; // Arrondi à 0.1°C
  }

  /// Met à jour l'humidité avec une valeur falsifiable
  /// Arrondi à la précision de 1%
  void setHumidity(double value) {
    _humidity = value.roundToDouble(); // Arrondi à 1%
  }

  /// Démarre l'envoi des données de température
  /// Cette méthode envoie la température toutes les 10s (mode actif) 
  /// ou toutes les 20s (mode veille).
  void startTemperatureTransmission(Function sendData) {
    stopTemperatureTransmission(); // Annule l'ancien timer si existant
    // Envoi toutes les 10s en mode actif, 20s en mode veille
    _temperatureTimer = Timer.periodic(
      Duration(seconds: isActive ? 10 : 20),
      (Timer timer) {
        sendData(_temperature); // Envoie la température à chaque intervalle
        ServerCommunication.sendDataToServer(_temperature, _humidity); // Envoie aussi au serveur
      },
    );
  }

  /// Démarre l'envoi des données d'humidité
  /// Cette méthode envoie l'humidité toutes les 20s (mode actif)
  /// ou toutes les 50s (mode veille).
  void startHumidityTransmission(Function sendData) {
    stopHumidityTransmission(); // Annule l'ancien timer si existant
    // Envoi toutes les 20s en mode actif, 50s en mode veille
    _humidityTimer = Timer.periodic(
      Duration(seconds: isActive ? 20 : 50),
      (Timer timer) {
        sendData(_humidity); // Envoie l'humidité à chaque intervalle
        ServerCommunication.sendDataToServer(_temperature, _humidity); // Envoie aussi au serveur
      },
    );
  }

  /// Arrête l'envoi des données de température
  /// Cette méthode annule le timer d'envoi de température
  void stopTemperatureTransmission() {
    _temperatureTimer?.cancel();
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
    startTemperatureTransmission((temp) {
      print('Température : $temp°C'); // Affiche la température envoyée
    });
    startHumidityTransmission((hum) {
      print('Humidité : $hum%'); // Affiche l'humidité envoyée
    });
  }
}
