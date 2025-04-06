import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:temperature/models/sensor.dart';
import 'package:temperature/utils/constants.dart';

/// Handles all HTTP communication with the backend server
class ServerCommunication {

  /// Sends sensor telemetry data to the server
  /// [sensor] : Sensor device information
  /// [temperature] : Current temperature reading
  /// [humidity] : Current humidity reading
  /// Throws: Network or server errors
  static Future<void> sendDataToServer(Sensor sensor, double temperature, double humidity) async {
    // Prepare payload with sensor data and timestamp
    Map<String, dynamic> data = {
      'sensor': sensor.toJson(),  // Convert sensor object to JSON
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': DateTime.now().toIso8601String(),  // ISO 8601 formatted timestamp
    };

    try {
      // Execute POST request to server endpoint
      final response = await http.post(
        Uri.parse(THING_API_URL + "receivedata"),  // Full endpoint URL
        headers: {'Content-Type': 'application/json'},  // JSON content type
        body: json.encode(data),  // Convert payload to JSON string
      );

      // Check response status code
      if (response.statusCode == 200) {
        print('Data successfully sent: ${response.body}');  // Log success
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');  // Log HTTP error
      }
    } catch (e) {
      print('Communication error: $e');  // Log network/parsing errors
      rethrow;  // Preserve stack trace
    }
  }
}