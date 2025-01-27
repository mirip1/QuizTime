import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'https://opentdb.com/api.php';

  /// Obtiene preguntas de Open Trivia Database API según los parametros
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

        if (data['response_code'] == 0) {
          // Devuelve las preguntas obtenidas
          return data['results'];
        } else {
          throw Exception("No se encontraron preguntas para los parámetros especificados.");
        }
      } else {
        throw Exception("Error en la API: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al obtener preguntas: $e");
    }
  }
}
