// lib/select_role.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Si usas animaciones aquí
import 'auth_service.dart';
import 'models/usuario_rol.dart'; // Asegúrate de que esta ruta es correcta

// Define los colores aquí si son específicos de esta página y no están en el tema global
// o si quieres tenerlos a mano. Si ya están en el tema de main.dart, puedes omitirlos.
const Color disdelBlue = Color(0xFF135EAB); // Usando el azul más oscuro que propusiste
const Color disdelAccentGreen = Color(0xFF96C121); // Usando el verde más brillante
const Color selectRolePageBackground = Color(0xFFF4F6F8); // Coincidiendo con el pageBackgroundColor de main.dart
const Color cardBackgroundColor = Colors.white;
const Color inputFillColor = Colors.white; // O un gris muy claro si prefieres
const Color dropdownMenuBackgroundColor = Colors.white;
const Color subtleTextColor = Color(0xFF6C757D);
// const Color inputBorderColor = Color(0xFFCED4DA); // Ya controlado por el tema

class SelectRolePage extends StatefulWidget {
  final String docEntry;
  const SelectRolePage({super.key, required this.docEntry});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompanyUi;
  UsuarioRol? _selectedRoleObject;

  // Lista de compañías para la UI. Podría venir de una API en el futuro.
  final List<String> _companiesUi = ['DISDEL, S.A.']; // Ejemplo, puedes expandir esto
  final String _companiaIdParaApi = "1007"; // ID de compañía quemado para la API de roles

  List<UsuarioRol> _apiFetchedRoles = [];
  bool _isLoadingRoles = true;
  String? _rolesErrorMessage;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Preseleccionar la compañía si la lista no está vacía
    if (_companiesUi.isNotEmpty) {
      // Intenta encontrar "DISDEL" o toma la primera
      _selectedCompanyUi = _companiesUi.firstWhere(
            (name) => name.toUpperCase().contains("DISDEL"), // Búsqueda insensible a mayúsculas
        orElse: () => _companiesUi.first,
      );
    }
    _fetchUserRoles();
  }

  Future<void> _fetchUserRoles() async {
    if (!mounted) return; // Evitar llamadas a setState si el widget ya no está en el árbol
    setState(() {
      _isLoadingRoles = true;
      _rolesErrorMessage = null;
      _apiFetchedRoles = []; // Limpiar roles anteriores mientras se cargan nuevos
      _selectedRoleObject = null; // Deseleccionar rol anterior
    });

    try {
      final roles = await _authService.getUserRoles(widget.docEntry, _companiaIdParaApi);
      if (mounted) { // Volver a verificar por si el widget se desmontó durante la llamada async
        if (roles != null) {
          setState(() {
            _apiFetchedRoles = roles;
            if (_apiFetchedRoles.isEmpty) { // Si la lista de roles está vacía después de una carga exitosa
              _rolesErrorMessage = "No se encontraron roles asignados para este usuario.";
            }
            // Opcional: Preseleccionar si solo hay un rol
            // if (_apiFetchedRoles.length == 1) {
            //   _selectedRoleObject = _apiFetchedRoles.first;
            // }
            _isLoadingRoles = false;
          });
        } else {
          // Si roles es null, significa que AuthService indicó un error de API o parseo
          setState(() {
            _rolesErrorMessage = "Error al cargar roles. Por favor, inténtalo de nuevo más tarde.";
            _isLoadingRoles = false;
          });
        }
      }
    } catch (e) { // Captura excepciones no esperadas (ej. de UsuarioRol.fromJson si lanza)
      if (mounted) {
        setState(() {
          _rolesErrorMessage = "Ocurrió un error procesando los datos de roles.";
          _isLoadingRoles = false;
        });
      }
      print("Excepción capturada en _fetchUserRoles (SelectRolePage): $e");
    }
  }

  void _continueToHome() {
    if (_formKey.currentState!.validate()) { // Valida los dropdowns
      if (_selectedRoleObject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor, selecciona un rol para continuar.'),
            backgroundColor: Colors.red.shade700, // Usar un color de error del tema si está definido
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
      // Imprimir información para depuración
      print('SelectRolePage: Compañía UI seleccionada: $_selectedCompanyUi');
      print('SelectRolePage: ID Compañía para API: $_companiaIdParaApi');
      print('SelectRolePage: DocEntry Usuario: ${widget.docEntry}');
      print('SelectRolePage: Rol Seleccionado: ${_selectedRoleObject!.nombre} (ID Rol: ${_selectedRoleObject!.idRol})');

      // Navegar a la página de inicio (HomePage) usando la ruta nombrada
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'userDocEntry': widget.docEntry,
          'selectedRole': _selectedRoleObject, // Pasa el objeto UsuarioRol completo
          'companiaId': _companiaIdParaApi,     // Pasa el ID de compañía usado
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context); // Para acceder al tema global

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Usar color del tema
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.07), // Un poco más de padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  // Estilo de Card ya definido en main.dart -> theme.cardTheme
                  // elevation: 6.0,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  // color: cardBackgroundColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                        vertical: screenHeight * 0.04),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.035),
                            child: Image.asset(
                              'assets/images/disdel_sa.png', // Asegúrate que la imagen exista
                              height: screenHeight * 0.08,
                              color: disdelAccentGreen, // Aplicar color de acento al logo
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                                .slideY(begin: -0.2, duration: 500.ms, curve: Curves.easeOutCubic)
                                .then(delay: 100.ms)
                                .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.7)),
                          ),
                          Text(
                            'Bienvenido',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOutCirc),
                          const SizedBox(height: 4),
                          Text(
                            'Selecciona tu compañía y rol para continuar',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: subtleTextColor),
                          ).animate(delay: 250.ms).fadeIn(duration: 500.ms),
                          SizedBox(height: screenHeight * 0.045),
                          _buildDropdownField<String>(
                            context: context,
                            value: _selectedCompanyUi,
                            hintText: 'Compañía',
                            items: _companiesUi,
                            onChanged: (String? newValue) {
                              setState(() { _selectedCompanyUi = newValue; });
                            },
                            validator: (value) => value == null ? 'Por favor, selecciona una compañía' : null,
                            iconData: Icons.business_outlined, // Icono más estándar para compañía
                            itemBuilder: (item) => Text(item, style: TextStyle(color: theme.colorScheme.primary)), // Texto de item con color primario
                          ).animate(delay:300.ms).fadeIn().slideX(begin: -0.2),

                          SizedBox(height: screenHeight * 0.025),

                          if (_isLoadingRoles)
                            const Center(child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 30.0), // Más padding vertical
                              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(disdelAccentGreen)),
                            ))
                          else if (_rolesErrorMessage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                _rolesErrorMessage!,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                              ),
                            )
                          else if (_apiFetchedRoles.isEmpty) // Si no está cargando, no hay error, pero la lista de roles está vacía
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  "No hay roles disponibles para tu usuario.",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(color: subtleTextColor),
                                ),
                              )
                            else // Mostrar el dropdown de roles
                              _buildDropdownField<UsuarioRol>(
                                context: context,
                                value: _selectedRoleObject,
                                hintText: 'Rol de Usuario',
                                items: _apiFetchedRoles,
                                onChanged: (UsuarioRol? newValue) {
                                  setState(() { _selectedRoleObject = newValue; });
                                },
                                validator: (value) => value == null ? 'Por favor, selecciona un rol' : null,
                                iconData: Icons.person_outline, // Icono más estándar para rol/usuario
                                itemBuilder: (UsuarioRol rol) => Text(
                                    rol.nombre, // Usa la propiedad 'nombre'
                                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)
                                ),
                                menuMaxHeight: screenHeight * 0.3, // Un poco menos alto
                              ).animate(delay:400.ms).fadeIn().slideX(begin: 0.2),

                          SizedBox(height: screenHeight * 0.05),
                          ElevatedButton(
                            // Estilo ya definido en main.dart -> theme.elevatedButtonTheme
                            onPressed: _isLoadingRoles || _apiFetchedRoles.isEmpty
                                ? null // Deshabilitado si carga o no hay roles (el error ya impediría llegar aquí si es severo)
                                : _continueToHome,
                            child: Text(
                              'ACCEDER',
                              // Estilo del texto del botón también definido en el tema
                              // style: TextStyle(fontSize: screenWidth * 0.043, fontWeight: FontWeight.bold, letterSpacing: 1.3),
                            ),
                          )
                              .animate(delay: 500.ms)
                              .fadeIn(duration: 500.ms)
                              .scaleXY(begin: 0.9, duration: 400.ms, curve: Curves.elasticOut),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: 50.ms).fadeIn(duration:400.ms).scaleXY(begin: 0.95, curve: Curves.easeOutSine),
                SizedBox(height: screenHeight * 0.06),
                Text(
                  'Powered by Disdel S.A. © ${DateTime.now().year}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(color: subtleTextColor.withOpacity(0.7)),
                )
                    .animate(delay: 600.ms)
                    .fadeIn(duration: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // El _buildDropdownField se mantiene casi igual, solo ajusta los delays de animación si es necesario
  Widget _buildDropdownField<T>({
    required BuildContext context,
    required T? value,
    required String hintText,
    required List<T> items,
    required ValueChanged<T?>? onChanged,
    required FormFieldValidator<T>? validator,
    required IconData iconData,
    // Removí animationDelay y slideBegin de aquí, ya que las animaciones se aplican directamente al widget
    double? menuMaxHeight,
    required Widget Function(T item) itemBuilder,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hintText, style: TextStyle(color: subtleTextColor, fontSize: screenWidth * 0.038)),
      isExpanded: true,
      dropdownColor: dropdownMenuBackgroundColor,
      menuMaxHeight: menuMaxHeight,
      decoration: InputDecoration( // Usará inputDecorationTheme de main.dart
        // Puedes sobreescribir propiedades específicas aquí si es necesario
        // fillColor: inputFillColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 10.0),
          child: Icon(iconData, color: theme.colorScheme.secondary, size: screenWidth * 0.05), // Usar color de acento
        ),
        // ... resto de tu decoración si la necesitas diferente al tema ...
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(Icons.arrow_drop_down_rounded, color: theme.colorScheme.primary.withOpacity(0.7), size: screenWidth * 0.07),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0), // Ajustar padding si es necesario
            child: itemBuilder(item),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500), // Estilo del valor seleccionado
    );
    // Las animaciones se aplican donde se llama a _buildDropdownField
  }
}