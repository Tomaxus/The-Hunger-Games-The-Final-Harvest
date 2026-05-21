import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tributo.dart';

class ApiService {
  // Tu IP de Wi-Fi local para la comunicación entre la App y FastAPI
  final String baseUrl = 'http://localhost:8000';

  /// RF-001: Obtener la lista de tributos
  Future<List<Tributo>> obtenerTributos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tributos'));
      if (response.statusCode == 200) {
        // Decodificamos el cuerpo asegurando el soporte de caracteres utf8
        final dynamic body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body is List) {
          return body.map((dynamic item) => Tributo.fromJson(item)).toList();
        }
        return [];
      } else {
        throw Exception('Error del servidor (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener tributos: $e');
    }
  }

  /// RF-001: Crear tributo por Query Parameters (Solución definitiva al int_parsing)
  Future<void> crearTributo(
      String nombre, int distrito, String genero, String avatar) async {
    try {
      // Convertimos explícitamente el entero a string (.toString()) para evitar que Flutter mande símbolos raros
      final String dStr = distrito.toString();

      final String urlConParams = '$baseUrl/tributos'
          '?nombre=${Uri.encodeComponent(nombre)}'
          '&distrito=$dStr'
          '&genero=$genero'
          '&avatar=${Uri.encodeComponent(avatar)}';

      final response = await http.post(
        Uri.parse(urlConParams),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({}), // Cuerpo vacío requerido por la estructura del POST
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        String mensaje = errorBody['detail']?.toString() ?? response.body;
        throw Exception(mensaje);
      }
    } catch (e) {
      throw Exception('No se pudo registrar: $e');
    }
  }

  /// RF-002: Editar tributo por Query Parameters
  Future<void> editarTributo(
      int id, String nombre, int distrito, String genero, String avatar) async {
    try {
      final String dStr = distrito.toString();
      final String idStr = id.toString();

      final String urlConParams = '$baseUrl/tributos/$idStr'
          '?nombre=${Uri.encodeComponent(nombre)}'
          '&distrito=$dStr'
          '&genero=$genero'
          '&avatar=${Uri.encodeComponent(avatar)}';

      final response = await http.put(
        Uri.parse(urlConParams),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({}),
      );

      if (response.statusCode != 200) {
        final errorBody = jsonDecode(response.body);
        String mensaje = errorBody['detail']?.toString() ?? response.body;
        throw Exception(mensaje);
      }
    } catch (e) {
      throw Exception('No se pudo editar: $e');
    }
  }

  /// RF-003: Eliminar un tributo
  Future<void> eliminarTributo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tributos/$id'));
      if (response.statusCode != 200) throw Exception('Error al eliminar');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// RF-004 / RF-005: Inicializar simulación
  Future<void> iniciarSimulacion(String tonoIA) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulacion/iniciar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tono': tonoIA}),
      );
      if (response.statusCode != 200) {
        final errorMsg =
            jsonDecode(response.body)['detail'] ?? 'Error desconocido';
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// RF-006: Avanzar día
  Future<Map<String, dynamic>> avanzarDia() async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/simulacion/avanzar'));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
      } else {
        final errorMsg =
            jsonDecode(response.body)['detail'] ?? 'Error de simulación';
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception('Error en la arena: $e');
    }
  }

  /// RF-009: Obtener reporte final
  Future<Map<String, dynamic>> obtenerReporteFinal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/simulacion/reporte'));
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;
      } else {
        throw Exception('No se recuperó el reporte final.');
      }
    } catch (e) {
      throw Exception('Error de estadísticas: $e');
    }
  }

  /// Reiniciar la simulación en el backend: restablece tributos a estado inicial
  Future<void> reiniciarSimulacion() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/simulacion/reiniciar'));
      if (response.statusCode != 200) {
        throw Exception('Error al reiniciar la simulación');
      }
    } catch (e) {
      throw Exception('Error de conexión al reiniciar: $e');
    }
  }
}
