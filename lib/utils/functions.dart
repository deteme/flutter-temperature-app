
import 'dart:math';

double generateTemperature(int precision) {
  double temperature =
      Random().nextDouble() *
      50; // Generates a random temperature between 0 and 50°C
  return double.parse(temperature.toStringAsFixed(precision));
}

double generateHumidity(int precision) {
  double temperature =
      Random().nextDouble() *
      100; // Generates a random Humidity value between 0% and 10%
  return double.parse(temperature.toStringAsFixed(precision));
}

/// function to generate random string
String generateRandomString(int length) {
  /// list of characters allowed
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  //   Random random = Random();

  return List.generate(
    length,
    (index) => chars[Random().nextInt(chars.length)],
  ).join();
}

