import 'package:flutter/material.dart';
import 'package:temperature/models/temperature_sensor.dart';

void main() {
  runApp(const MyApp());
}

/// Classe principale de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capteur Température',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Capteur Température et Humidité'),
    );
  }
}

/// Écran principal de l'application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TemperatureSensor sensor = TemperatureSensor(); // Instanciation du capteur

  @override
  void initState() {
    super.initState();

    // Démarrer la transmission des données dès l'initialisation, avec le mode par défaut (actif ou veille)
    sensor.toggleMode(); // Passer au mode actif ou veille, selon l'état initial du capteur

    sensor.startTemperatureTransmission((temp) {
      setState(() {}); // Met à jour l'UI pour la température
    });

    sensor.startHumidityTransmission((hum) {
      setState(() {}); // Met à jour l'UI pour l'humidité
    });
  }

  /// Met à jour la température avec une nouvelle valeur saisie par l'utilisateur
  void updateTemperature(double value) {
    setState(() {
      sensor.setTemperature(value);
    });
  }

  /// Met à jour l'humidité avec une nouvelle valeur saisie par l'utilisateur
  void updateHumidity(double value) {
    setState(() {
      sensor.setHumidity(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tempController = TextEditingController();
    TextEditingController humidityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Température: ${sensor.temperature}°C',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Humidité: ${sensor.humidity}%',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),

            // Champ pour entrer une nouvelle température
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Nouvelle température (°C)"),
            ),
            ElevatedButton(
              onPressed: () {
                double? newTemp = double.tryParse(tempController.text);
                if (newTemp != null) {
                  updateTemperature(newTemp);
                }
              },
              child: const Text("Modifier Température"),
            ),

            // Champ pour entrer une nouvelle humidité
            TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Nouvelle humidité (%)"),
            ),
            ElevatedButton(
              onPressed: () {
                double? newHumidity = double.tryParse(humidityController.text);
                if (newHumidity != null) {
                  updateHumidity(newHumidity);
                }
              },
              child: const Text("Modifier Humidité"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  sensor.toggleMode(); // Change le mode actif/veille
                });
              },
              child: Text(sensor.isActive ? 'Passer en veille' : 'Activer'),
            ),
          ],
        ),
      ),
    );
  }
}
