// lib/select_role.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Colores
const Color disdelBlue = Color(0xFF004A8F);
const Color disdelMinimalistGreen = Color(0xFF96C11F);
const Color selectRolePageBackground = Color(0xFFF8F9FA);
const Color cardBackgroundColor = Colors.white;
const Color inputFillColor = Colors.white;
const Color dropdownMenuBackgroundColor = Colors.white;
const Color subtleTextColor = Color(0xFF6C757D);
const Color inputBorderColor = Color(0xFFCED4DA);


class SelectRolePage extends StatefulWidget {
  const SelectRolePage({super.key});

  @override
  State<SelectRolePage> createState() => _SelectRolePageState();
}

class _SelectRolePageState extends State<SelectRolePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCompany;
  String? _selectedRole;

  final List<String> _companies = ['DISDEL, S.A.', 'L&G'];
  final List<String> _roles = [
    'Administrador',
    'Vendedor',
    'Bodeguero',
    'Cliente',
    'Supervisor de Ventas',
    'Contador',
    'Gerente de Operaciones',
    'Soporte Técnico',
    'Analista de Datos',
    'Recursos Humanos',
    'Ejecutivo de Cuentas Clave',
    'Especialista en Marketing'
  ];

  @override
  void initState() {
    super.initState();
    if (_companies.length == 1) {
      _selectedCompany = _companies.first;
    }
  }

  void _continueToHome() {
    if (_formKey.currentState!.validate()) {
      print('Compañía seleccionada: $_selectedCompany');
      print('Rol seleccionado: $_selectedRole');
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: selectRolePageBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  color: cardBackgroundColor,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.07,
                        vertical: screenHeight * 0.035
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                            child: Image.asset(
                              'assets/images/disdel_sa.png',
                              height: screenHeight * 0.075,
                              color: disdelMinimalistGreen,
                            )
                                .animate()
                                .fadeIn(duration: 700.ms, curve: Curves.easeOut)
                                .slideY(begin: -0.15, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
                                .scaleXY(begin: 0.9, end: 1.0, duration: 600.ms, curve: Curves.elasticOut)
                                .then(delay: 200.ms)
                                .shimmer(
                              duration: 1800.ms,
                              color: Colors.white.withOpacity(0.9),
                              angle: 45 * (3.1415926535 / 180),
                              size: 0.6,
                            ),
                          ),
                          Text(
                            'Bienvenido',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.065,
                              fontWeight: FontWeight.w600,
                              color: disdelBlue,
                            ),
                          )
                              .animate(delay: 150.ms)
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCirc),
                          Text(
                            'Selecciona tu compañía y rol para continuar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: subtleTextColor,
                                fontWeight: FontWeight.normal
                            ),
                          ).animate(delay: 250.ms).fadeIn(duration: 600.ms),
                          SizedBox(height: screenHeight * 0.04),
                          _buildDropdownField(
                            context: context,
                            value: _selectedCompany,
                            hintText: 'Compañía',
                            items: _companies,
                            onChanged: (String? newValue) {
                              setState(() { _selectedCompany = newValue; });
                            },
                            validator: (value) => value == null ? 'Por favor, selecciona una compañía' : null,
                            iconData: Icons.business_center_outlined,
                            animationDelay: 400.ms,
                            slideBegin: -0.3,
                            // Para el dropdown de compañía, probablemente no necesite menuMaxHeight
                            // a menos que tengas muchas compañías.
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          _buildDropdownField(
                            context: context,
                            value: _selectedRole,
                            hintText: 'Rol',
                            items: _roles,
                            onChanged: (String? newValue) {
                              setState(() { _selectedRole = newValue; });
                            },
                            validator: (value) => value == null ? 'Por favor, selecciona un rol' : null,
                            iconData: Icons.person_pin_circle_outlined,
                            animationDelay: 550.ms,
                            slideBegin: 0.3,
                            // APLICAMOS menuMaxHeight PARA EL DROPDOWN DE ROLES
                            menuMaxHeight: screenHeight * 0.35, // Límite al 35% de la altura de la pantalla
                          ),
                          SizedBox(height: screenHeight * 0.045),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: disdelMinimalistGreen,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              elevation: 5,
                              shadowColor: disdelMinimalistGreen.withOpacity(0.6),
                            ),
                            onPressed: _continueToHome,
                            child: Text(
                              'ACCEDER',
                              style: TextStyle(
                                fontSize: screenWidth * 0.043,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.3,
                              ),
                            ),
                          )
                              .animate(delay: 700.ms)
                              .fadeIn(duration: 600.ms)
                              .scaleXY(begin: 0.8, end: 1, duration: 500.ms, curve: Curves.elasticOut),
                        ],
                      ),
                    ),
                  ),
                ).animate(delay: 50.ms).fadeIn(duration:500.ms).scaleXY(begin: 0.93, end: 1.0, curve: Curves.easeOutSine),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Powered by Disdel S.A. © ${DateTime.now().year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: subtleTextColor.withOpacity(0.8),
                  ),
                )
                    .animate(delay: 900.ms)
                    .fadeIn(duration: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String? value,
    required String hintText,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    required FormFieldValidator<String>? validator,
    required IconData iconData,
    required Duration animationDelay,
    required double slideBegin,
    double? menuMaxHeight, // <<--- PARÁMETRO OPCIONAL AÑADIDO
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height; // No lo necesitamos aquí si pasamos menuMaxHeight

    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hintText, style: TextStyle(color: subtleTextColor, fontSize: screenWidth * 0.04)),
      isExpanded: true,
      dropdownColor: dropdownMenuBackgroundColor,
      // <<------------------- APLICACIÓN DE menuMaxHeight ---------------------->>
      menuMaxHeight: menuMaxHeight, // Usa el valor pasado o null si no se proporciona
      // <<---------------------------------------------------------------------->>
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFillColor,
        contentPadding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: inputBorderColor.withOpacity(0.5), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: inputBorderColor.withOpacity(0.7), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: disdelMinimalistGreen, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 8.0),
          child: Icon(iconData, color: disdelMinimalistGreen, size: screenWidth * 0.055),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(Icons.expand_more_rounded, color: disdelBlue.withOpacity(0.8), size: screenWidth * 0.065),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
                item,
                style: TextStyle(
                    color: disdelBlue,
                    fontSize: screenWidth * 0.042,
                    fontWeight: FontWeight.w500
                )
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(fontSize: screenWidth * 0.042, color: disdelBlue, fontWeight: FontWeight.w500),
    )
        .animate(delay: animationDelay)
        .fadeIn(duration: 600.ms)
        .slideX(begin: slideBegin, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }
}