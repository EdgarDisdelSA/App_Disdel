// lib/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Asegúrate de que la ruta de importación sea correcta si tu modelo está en una ubicación diferente.
// Por ejemplo, si creas 'lib/models/usuario_rol.dart'.
import '../models/usuario_rol.dart';

class AuthService {
  // CAMBIA ESTO POR LA URL BASE REAL DE TU API
  final String _baseUrl = "https://www.disdelsagt.com/MyBusiness";
  // Ejemplo: "http://localhost:5000" o "https://api.miservidor.com"
  static const String _userIdentifierKey = 'userDocEntry';
  // Podrías añadir una clave para la compañía si la guardaras también, aunque para GetUserRol la estamos quemando.
  // static const String _userCompanyIdKey = 'userCompanyId';

  /// Realiza el login del usuario.
  ///
  /// Devuelve un [Map<String, dynamic>] con la  /// El mapa incluye "Resultado" (bool), "Mensaje" (String), y "DocEntry" (String) si es exitoso. respuesta de la API o `null` en caso de error de parseo.
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
        // responseData contendrá {"DocEntry": "...", "Resultado": true/false, "Mensaje": "...", "compania": "..."}

        if (responseData['Resultado'] == true && responseData['DocEntry'] != null) {
          await _saveUserIdentifier(responseData['DocEntry'].toString());
          // Opcional: Guardar también el ID de la compañía si se va a usar consistentemente
          // if (responseData['compania'] != null) {
          //   await _saveCompanyId(responseData['compania'].toString());
          // }
        }
        return responseData; // Devolvemos todo el mapa para que la UI decida
      } else {
        // Error del servidor o endpoint no encontrado, etc.
        print('Error en login - Status: ${response.statusCode}');
        print('Error en login - Body: ${response.body}');
        return {
          "Resultado": false,
          "Mensaje": "Error del servidor (${response.statusCode}). Inténtalo más tarde."
        };
      }
    } catch (e) {
      // Error de red, timeout, parseo de JSON, etc.
      print('Excepción durante el login: $e');
      return {
        "Resultado": false,
        "Mensaje": "Error de conexión o del servidor. Verifica tu internet e inténtalo de nuevo."
      };
    }
  }

  /// Guarda el identificador del usuario (DocEntry) en SharedPreferences.
  Future<void> _saveUserIdentifier(String docEntry) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdentifierKey, docEntry);
    print('AuthService: DocEntry $docEntry guardado.');
  }

  /* Opcional: Si quisieras guardar y recuperar el companyId
  Future<void> _saveCompanyId(String companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCompanyIdKey, companyId);
    print('AuthService: CompanyId $companyId guardado.');
  }

  Future<String?> getCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userCompanyIdKey);
  }
  */

  /// Obtiene el identificador del usuario (DocEntry) guardado.
  Future<String?> getUserIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdentifierKey);
  }

  /// Cierra la sesión del usuario, eliminando su DocEntry.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdentifierKey);
    // await prefs.remove(_userCompanyIdKey); // Si también guardas companyId
    print('AuthService: Usuario deslogueado, DocEntry eliminado.');
    // Considera llamar a un endpoint de logout en tu API si existe y es necesario.
  }

  /// Verifica si el usuario está actualmente logueado (si tiene un DocEntry guardado).
  Future<bool> isLoggedIn() async {
    final identifier = await getUserIdentifier();
    return identifier != null && identifier.isNotEmpty;
  }

  /// Obtiene los roles asignados a un usuario para una compañía específica.
  ///
  /// [docEntry] El DocEntry del usuario.
  /// [companiaId] El ID de la compañía (ej. "1007").
  /// Devuelve una lista de [UsuarioRol] o `null` si hay un error o no se encuentran roles.
  Future<List<UsuarioRol>?> getUserRoles(String docEntry, String companiaId) async {
    // El endpoint C# es: [HttpPost] [Route("Api/Mobil/GetUserRol/{id}/{idC}")]
    // Esto implica que 'id' (docEntry) e 'idC' (companiaId) son parte de la URL.
    final String url = '$_baseUrl/Api/Mobil/GetUserRol/$docEntry/$companiaId';
    print('AuthService: Solicitando roles desde: $url');

    try {
      final response = await http.post( // Usamos POST como indica [HttpPost] en tu API
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // Podrías necesitar enviar un token de autorización si tu API lo requiere para este endpoint
          // 'Authorization': 'Bearer tu_token_aqui',
        },
        // Dado que los parámetros están en la URL para este endpoint POST específico,
        // el body puede ser vacío. Si tu API espera un JSON vacío, puedes usar: body: jsonEncode({})
        // Si no espera body, puedes omitir el parámetro `body`.
        // Vamos a probar sin body explícito primero. Si falla, intenta con body: jsonEncode({}).
      );

      if (response.statusCode == 200) {
        // Esperamos una lista de objetos UsuarioRol
        // jsonDecode parseará esto a List<dynamic>, donde cada elemento es un Map<String, dynamic>
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is List) {
          List<UsuarioRol> roles = decodedBody
              .map((data) => UsuarioRol.fromJson(data as Map<String, dynamic>))
              .toList();
          print('AuthService: Roles recibidos: ${roles.length}');
          return roles;
        } else {
          print('Error en getUserRoles - La respuesta no es una lista como se esperaba: ${response.body}');
          return null; // O podrías retornar una lista vacía: return [];
        }
      } else {
        print('Error en getUserRoles - Status: ${response.statusCode}');
        print('Error en getUserRoles - Body: ${response.body}');
        // Podrías intentar decodificar el body aquí también para ver si hay un mensaje de error de la API
        // try {
        //   final errorData = jsonDecode(response.body);
        //   print('Error en getUserRoles - API Error Message: ${errorData['Mensaje'] ?? 'No message'}');
        // } catch (e) {
        //   // No era JSON o no tenía 'Mensaje'
        // }
        return null;
      }
    } catch (e) {
      // Error de red, timeout, parseo de JSON, etc.
      print('Excepción durante getUserRoles: $e');
      return null;
    }
  }
}