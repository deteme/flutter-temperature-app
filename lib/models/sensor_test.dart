import 'package:test/test.dart';

import 'temperature_sensor.dart';

void main() {
  group('Test du capteur de température et d\'humidité', () {
    test('Vérification des valeurs falsifiables', () {
      // Crée une instance du capteur
      final sensor = TemperatureSensor();

      // Test de falsification des données
      sensor.setTemperature(22.5); // Température personnalisée
      sensor.setHumidity(55);      // Humidité personnalisée

      // Vérifie les valeurs
      expect(sensor.temperature, 22.5);
      expect(sensor.humidity, 55);

      // Vérifie que le mode est bien actif
      sensor.startTemperatureTransmission((temp) {
        print('Température : $temp°C');
      });

      sensor.startHumidityTransmission((hum) {
        print('Humidité : $hum%');
      });

      // Test pour changer de mode (actif/veille)
      sensor.toggleMode(); // Passer en mode veille
      sensor.toggleMode(); // Repasser en mode actif
    });
  });
}
