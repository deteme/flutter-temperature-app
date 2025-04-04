import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:temperature/models/sensor.dart';
import 'package:temperature/utils/constants.dart';

/// Classe responsable de la communication avec le serveur
class ServerCommunication {

  /// Envoie des données au serveur
  static Future<void> sendDataToServer(Sensor sensor, double temperature, double humidity) async {
    // Crée une map avec les données
    Map<String, dynamic> data = {
		'sensor': sensor.toJson(),
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': DateTime.now().toIso8601String(), // Ajoute l'heure d'envoi pour le test
    };

    try {
      // Envoie les données via une requête POST
      final response = await http.post(
        Uri.parse(THING_API_URL+"receivedata"),
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
}
