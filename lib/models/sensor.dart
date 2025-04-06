/// Represents a physical sensor device with configuration and telemetry data
class Sensor {
  // Core device identification
  late String id;         // Unique device identifier
  late String name;       // Human-readable device name
  late String type;       // Device classification (e.g. "temperature_sensor")

  // Configuration attributes
  late Map<String, String> clientAttributes;  // Client-side metadata (e.g. serial number)
  late Map<String, String> serverAttributes;  // Server-side configuration (e.g. location)
  late Map<String, String> telemetryData;     // Current sensor readings (temperature/humidity)

  /// Main constructor for creating a sensor instance
  Sensor(
    this.id,
    this.name,
    this.type, {
    required this.clientAttributes,
    required this.serverAttributes,
    required this.telemetryData,
  });

  /// Creates a Sensor instance from JSON data
  /// [json] : Map containing sensor data in JSON format
  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
      clientAttributes: (json['clientAttributes'] as Map?)?.map(
            (key, value) => MapEntry(key as String, value as String),
          ) ??
          {},  // Fallback to empty map if null
      serverAttributes: (json['serverAttributes'] as Map?)?.map(
            (key, value) => MapEntry(key as String, value as String),
          ) ??
          {},
      telemetryData: (json['telemetryData'] as Map?)?.map(
            (key, value) => MapEntry(key as String, value as String),
          ) ??
          {},
    );

  /// Converts the sensor instance to JSON format
  /// Returns: Map containing all sensor data
  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'type': type,
      'clientAttributes': clientAttributes,
      'serverAttributes': serverAttributes,
      'telemetryData': telemetryData,
    };

  /// Provides a string representation of the sensor
  @override
  String toString() => 'Sensor{id: $id, name: $name, type: $type, '
        'clientAttributes: $clientAttributes, '
        'serverAttributes: $serverAttributes, '
        'telemetryData: $telemetryData}';
}