import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temperature/managers/sensor_manager.dart';
//import 'package:temperature/models/temperature_sensor.dart';
import 'package:temperature/utils/constants.dart';

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
  final SensorManager sensor = SensorManager(); // Instanciation du capteur

  @override
  void initState() {
    super.initState();

    sensor.launch(() => {setState(() {})});
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

  void sendDataToServer(double temperature, double humidity) async {
	print("send data to the server");
    // Crée une map avec les données
    Map<String, dynamic> data = {
      'temperature': temperature,
      'humidity': humidity,
      'timestamp':
          DateTime.now()
              .toIso8601String(), // Ajoute l'heure d'envoi pour le test
    };

    try {
      // Envoie les données via une requête POST
      final response = await http.post(
        Uri.parse(THING_API_URL + "receivedata"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Si la requête est réussie, affiche la réponse
        print('Données envoyées avec succès : ${response.body}');
      } else {
        // Si la requête échoue, affiche l'erreur
        print('Erreur lors de l\'envoi des données : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur : $e');
    }
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

            /*// Champ pour entrer une nouvelle température
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nouvelle température (°C)",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double? newTemp = double.tryParse(tempController.text);
                if (newTemp != null) {
                  updateTemperature(newTemp);
                }
              },
              child: const Text("Modifier Température"),
            ),*/

            // Champ pour entrer une nouvelle humidité
            /*TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nouvelle humidité (%)",
              ),
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
            */

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  sensor.toggleMode(); // Change le mode actif/veille
                });
              },
              child: Text(sensor.isActive ? 'Passer en veille' : 'Activer'),
            ),
            ElevatedButton(
              onPressed: () {
                sendDataToServer(10, 10);
              },
              child: Text("test server"),
            ),
          ],
        ),
      ),
    );
  }
}
