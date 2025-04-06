import 'package:flutter/material.dart';
import 'package:temperature/managers/sensor_manager.dart';

void main() {
  runApp(const MyApp());
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Temperature Sensor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Temperature & Humidity Sensor'),
    );
}

/// Home page widget
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// State class for the home page
class _MyHomePageState extends State<MyHomePage> {
  final SensorManager manager = SensorManager(); // Sensor manager instance
  final TextEditingController tempController = TextEditingController(); // Temperature input
  final TextEditingController humidityController = TextEditingController(); // Humidity input

  @override
  void initState() {
    super.initState();
    // Initialize sensor with UI update callback
    manager.start(onUpdate: () => setState(() {}));
  }

  @override
  void dispose() {
    // Clean up resources
    manager.stop();
    tempController.dispose();
    humidityController.dispose();
    super.dispose();
  }

  /// Updates temperature with manual input
  void _updateTemperature() {
    final value = double.tryParse(tempController.text);
    if (value != null) {
      setState(() {
        manager.setTemperature(value);
        tempController.clear();
      });
    }
  }

  /// Updates humidity with manual input
  void _updateHumidity() {
    final value = double.tryParse(humidityController.text);
    if (value != null) {
      setState(() {
        manager.setHumidity(value);
        humidityController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Data display section
              _buildDataDisplay(context),
              const SizedBox(height: 30),
              
              // Manual controls section
              _buildManualControls(),
              const SizedBox(height: 20),
              
              // Mode control buttons
              _buildModeButtons(),
            ],
          ),
        ),
      ),
    );

  /// Builds the data display widgets
  Widget _buildDataDisplay(BuildContext context) => Column(
      children: [
        // Temperature display
        Text(
          '${manager.temperature.toStringAsFixed(1)}°C',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
        ),
        // Humidity display
        Text(
          '${manager.humidity.toStringAsFixed(0)}% RH',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
        ),
        // Mode indicators
        Text(
          manager.isActive ? 'Active Mode' : 'Sleep Mode',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          manager.isAutoMode ? 'Auto Mode' : 'Manual Mode',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );

  /// Builds manual input controls
  Widget _buildManualControls() => AbsorbPointer(
      // Disable controls in auto mode
      absorbing: manager.isAutoMode,
      child: Opacity(
        // Visual indication of disabled state
        opacity: manager.isAutoMode ? 0.6 : 1.0,
        child: Column(
          children: [
            // Temperature input
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Temperature (°C)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateTemperature,
              child: const Text("Update"),
            ),
            const SizedBox(height: 20),
            // Humidity input
            TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Humidity (%)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateHumidity,
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );

  /// Builds mode toggle buttons
  Widget _buildModeButtons() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Active/Sleep mode toggle
        ElevatedButton(
          onPressed: () => setState(manager.toggleActiveMode),
          style: ElevatedButton.styleFrom(
            backgroundColor: manager.isActive ? Colors.orange : Colors.grey,
          ),
          child: Text(manager.isActive ? 'Switch to Sleep' : 'Switch to Active'),
        ),
        const SizedBox(width: 20),
        // Auto/Manual mode toggle
        ElevatedButton(
          onPressed: () => setState(manager.toggleAutoMode),
          style: ElevatedButton.styleFrom(
            backgroundColor: manager.isAutoMode ? Colors.blue : Colors.purple,
          ),
          child: Text(manager.isAutoMode ? 'Switch to Manual' : 'Switch to Auto'),
        ),
      ],
    );
}
