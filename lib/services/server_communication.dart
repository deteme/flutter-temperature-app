import 'dart:convert';
import 'package:http/http.dart' as http;

/// Classe responsable de la communication avec le serveur
class ServerCommunication {
  // URL de test pour JSONPlaceholder
  static const String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  /// Envoie des données au serveur
  static Future<void> sendDataToServer(double temperature, double humidity) async {
    // Crée une map avec les données
    Map<String, dynamic> data = {
      'temperature': temperature,
      'humidity': humidity,
      'timestamp': DateTime.now().toIso8601String(), // Ajoute l'heure d'envoi pour le test
    };

    try {
      // Envoie les données via une requête POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
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
