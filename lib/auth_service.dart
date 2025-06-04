import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // CAMBIA ESTO POR LA URL BASE REAL DE TU API
  final String _baseUrl = "https://www.disdelsagt.com/MyBusiness"; // Ejemplo: "http://localhost:5000" o "https://api.miservidor.com"
  static const String _userIdentifierKey = 'userDocEntry';

  Future<Map<String, dynamic>?> login(String nameUser, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/Api/Mobil/ValidarLogin'), // Endpoint completo
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'nameuser': nameUser,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // responseData contendrá {"DocEntry": "...", "Resultado": true/false, "Mensaje": "..."}

        if (responseData['Resultado'] == true && responseData['DocEntry'] != null) {
          await _saveUserIdentifier(responseData['DocEntry'].toString());
        }
        return responseData; // Devolvemos todo el mapa para que la UI decida
      } else {
        // Error del servidor o endpoint no encontrado, etc.
        print('Error en login - Status: ${response.statusCode}');
        print('Error en login - Body: ${response.body}');
        return {
          "Resultado": false,
          "Mensaje": "Error del servidor: ${response.statusCode}"
        };
      }
    } catch (e) {
      // Error de red, timeout, etc.
      print('Excepción durante el login: $e');
      return {
        "Resultado": false,
        "Mensaje": "Error de conexión o del servidor. Inténtalo de nuevo."
      };
    }
  }

  Future<void> _saveUserIdentifier(String docEntry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdentifierKey, docEntry);
  }

  Future<String?> getUserIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdentifierKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdentifierKey);
    // Considera llamar a un endpoint de logout en tu API si existe
  }

  Future<bool> isLoggedIn() async {
    final identifier = await getUserIdentifier();
    return identifier != null && identifier.isNotEmpty;
  }
}