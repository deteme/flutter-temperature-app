import 'dart:async';
import 'package:temperature/models/sensor.dart';
import 'package:temperature/services/server_communication.dart';
import 'package:temperature/utils/functions.dart';

/// Manages sensor data, modes, and server communication
class SensorManager {
  // Sensor data variables
  double _temperature = 0.0; // Current temperature value
  double _humidity = 0.0;    // Current humidity value
  bool isActive = true;      // Active/Sleep mode flag
  bool isAutoMode = true;    // Auto/Manual mode flag
  bool _isManualDataPending = false; // Tracks if manual update is waiting

  // Timers for periodic updates
  Timer? _tempTimer;       // Timer for temperature updates
  Timer? _humidityTimer;   // Timer for humidity updates
  
  // Sensor configuration
  final Sensor sensor = Sensor(
    "1", // Device ID
    "Temperature Sensor", // Device name
    "temperature_sensor", // Device type
    clientAttributes: {'Serial Number': 'TS-001'}, // Client metadata
    serverAttributes: {'Location': 'Living Room'}, // Server metadata
    telemetryData: { // Initial telemetry values
      'temperature': '0.0', 
      'humidity': '0.0',
      'status': 'active'
    },
  );

  // Getters for current values
  double get temperature => _temperature; // Returns current temperature
  double get humidity => _humidity;      // Returns current humidity

/// Sets temperature with validation (0-50°C)
void setTemperature(double value) {
  if (value < 0 || value > 50) {
    throw ArgumentError('Temperature must be between 0-50°C');
  }
  _temperature = (value * 10).round() / 10; // Maintains 0.1°C precision
  _isManualDataPending = true;
}

/// Sets humidity with validation (0-100%)
void setHumidity(double value) {
  if (value < 0 || value > 100) {
    throw ArgumentError('Humidity must be between 0-100%');
  }
  _humidity = value.roundToDouble(); // Maintains 1% precision
  _isManualDataPending = true;
}

  /// Starts data transmission with specified update callback
  /// [onUpdate] - Callback function to trigger UI updates
  void start({required Function onUpdate}) {
    _startTimers(onUpdate);
  }

  /// Stops all active timers and cleans up resources
  void stop() {
    _tempTimer?.cancel();
    _humidityTimer?.cancel();
  }

  /// Initializes timers based on current active/sleep mode
  /// [onUpdate] - Callback for UI refresh
  void _startTimers(Function onUpdate) {
    stop(); // Cancel any existing timers

    // Set up temperature timer with appropriate interval
    _tempTimer = Timer.periodic(
      Duration(seconds: isActive ? 10 : 20), 
      (_) => _updateData(onUpdate, isTemperature: true),
    );

    // Set up humidity timer with appropriate interval
    _humidityTimer = Timer.periodic(
      Duration(seconds: isActive ? 20 : 50),
      (_) => _updateData(onUpdate, isTemperature: false),
    );
  }

  /// Handles data updates and server communication
  /// [onUpdate] - UI refresh callback
  /// [isTemperature] - Flag indicating if updating temperature or humidity
  Future<void> _updateData(Function onUpdate, {required bool isTemperature}) async {
    if (isAutoMode) {
      // Auto-generate new values
      if (isTemperature) {
        _temperature = generateTemperature(1);
      } else {
        _humidity = generateHumidity(1);
      }
      await _sendToServer();
    } else if (_isManualDataPending) {
      // Send manual updates
      await _sendToServer();
      _isManualDataPending = false;
    }
    onUpdate(); // Trigger UI refresh
  }

  /// Sends current data to server with error handling
  Future<void> _sendToServer() async {
    try {
      await ServerCommunication.sendDataToServer(
        sensor,
        _temperature,
        _humidity,
      );
    } catch (e) {
      print("Server communication error: $e");
    }
  }

  /// Toggles between active and sleep modes
  void toggleActiveMode() {
    isActive = !isActive;
    _startTimers(() {});
  }

  /// Toggles between auto and manual modes
  void toggleAutoMode() {
    isAutoMode = !isAutoMode;
    if (isAutoMode) {
      // Generate new values immediately for UI
      _temperature = generateTemperature(1);
      _humidity = generateTemperature(1);
      // Server updates will follow normal intervals
    }
  }
}