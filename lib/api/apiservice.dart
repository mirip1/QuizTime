import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://opentdb.com/api.php';

  /// Obtiene preguntas de Open Trivia Database API según los parámetros
  Future<List<dynamic>> getQuestions({
    required int amount,
    String? difficulty,
    int? category, 
    String? type,
  }) async {
    // Construcción dinámica de parámetros
    final Map<String, String> queryParameters = {
      'amount': amount.toString(),
    };

    if (difficulty != null) queryParameters['difficulty'] = difficulty;
    if (category != null) queryParameters['category'] = category.toString();
    if (type != null) queryParameters['type'] = type;

    // Construcción de la URL
    final Uri url = Uri.parse(_baseUrl).replace(queryParameters: queryParameters);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Validar el contenido de la respuesta
        if (data['response_code'] == 0 && data['results'] is List) {
          return List<dynamic>.from(data['results']);
        } else if (data['response_code'] == 1) {
          throw Exception("No se encontraron suficientes preguntas para los parámetros.");
        } else {
          throw Exception("Error en la respuesta de la API: código ${data['response_code']}");
        }
      } else {
        throw Exception("Error al conectar con la API: Código ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      throw Exception("Error de red: ${e.message}");
    } on FormatException catch (e) {
      throw Exception("Error al decodificar la respuesta: ${e.message}");
    } catch (e) {
      throw Exception("Error inesperado: $e");
    }
  }
}
