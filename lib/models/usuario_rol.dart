// lib/models/usuario_rol.dart
class UsuarioRol {
  final int idRelacion;
  final int idRol;
  final String nombre; // Cambiado de nombreRol a nombre para coincidir con el JSON

  UsuarioRol({
    required this.idRelacion,
    required this.idRol,
    required this.nombre, // Cambiado aquí también
  });

  factory UsuarioRol.fromJson(Map<String, dynamic> json) {
    // Validación básica para asegurar que las claves existen y son del tipo esperado
    if (json['IdRelacion'] == null || json['IdRol'] == null || json['Nombre'] == null) {
      // Podrías lanzar una excepción más específica o retornar un valor por defecto/nulo
      // dependiendo de cómo quieras manejar datos malformados.
      print('Error al parsear UsuarioRol: Faltan datos o son nulos. JSON: $json');
      throw const FormatException('Datos de UsuarioRol incompletos o inválidos.');
    }
    if (json['IdRelacion'] is! int || json['IdRol'] is! int || json['Nombre'] is! String) {
      print('Error al parsear UsuarioRol: Tipos de datos incorrectos. JSON: $json');
      throw const FormatException('Tipos de datos de UsuarioRol incorrectos.');
    }

    return UsuarioRol(
      idRelacion: json['IdRelacion'] as int,
      idRol: json['IdRol'] as int,
      nombre: json['Nombre'] as String, // <<<--- CORRECCIÓN IMPORTANTE AQUÍ
    );
  }

  // Sobrescribir == y hashCode es una buena práctica si estos objetos se usan
  // en colecciones (Set, Map) o como 'value' en DropdownButtonFormField,
  // para que las comparaciones funcionen como se espera.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UsuarioRol &&
              runtimeType == other.runtimeType &&
              idRol == other.idRol && // Usamos idRol como identificador principal para la comparación
              nombre == other.nombre;

  @override
  int get hashCode => idRol.hashCode ^ nombre.hashCode;

  // El método toString() es útil para debugging y también puede ser usado por
  // DropdownButtonFormField para mostrar el texto del ítem si no se especifica un itemBuilder
  // que haga algo diferente.
  @override
  String toString() {
    return nombre; // Esto hará que el Dropdown muestre el nombre del rol por defecto
  }
}