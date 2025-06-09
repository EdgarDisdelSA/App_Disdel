import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // ¡Import activado!
import '../services/auth_service.dart';
import 'select_role.dart'; // Asegúrate que este archivo define 'SelectRolePage'

// Define los colores de tu empresa para fácil acceso
const Color disdelBlue = Color(0xFF004A8F);
const Color disdelGreen = Color(0xFF8BC53F); // Usado en el diseño original del login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameUserController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  void _performLogin() async {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await _authService.login(
        _nameUserController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response != null && response['Resultado'] == true) {
          final String? docEntry = response['DocEntry']?.toString();
          if (docEntry != null && docEntry.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SelectRolePage(docEntry: docEntry),
              ),
            );
          } else {
            setState(() {
              _errorMessage = "Error: No se recibió el identificador de usuario desde el servidor.";
            });
          }
        } else {
          setState(() {
            _errorMessage = response?['Mensaje'] as String? ?? "Error desconocido. Inténtalo de nuevo.";
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameUserController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    const Color pageBackgroundColor = Color(0xFFF5F5F5);
    final Color textFieldFillColor = Colors.grey.shade200;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- ANIMACIÓN DEL LOGO CON REFLEJO (SHIMMER) ---
              Image.asset(
                'assets/images/disdel_sa.png',
                height: screenHeight * 0.15,
              )
                  .animate()
                  .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
                  .slideY(begin: -0.3, end: 0, duration: 700.ms, curve: Curves.easeOutExpo)
                  .then(delay: 200.ms) // Espera un poco antes del reflejo
                  .shimmer(
                duration: 1800.ms, // Duración del barrido del reflejo
                color: Colors.white.withOpacity(0.7), // Color del reflejo, blanco es más realista
                blendMode: BlendMode.srcATop,
              ),

              SizedBox(height: screenHeight * 0.04),

              Text(
                'Bienvenido a',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.w300,
                  color: disdelBlue.withOpacity(0.85),
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 700.ms)
                  .slideY(begin: 0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),

              Text(
                'DISDEL S.A.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: disdelBlue,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: disdelGreen.withOpacity(0.3),
                        offset: const Offset(1.0, 1.0),
                      ),
                    ]
                ),
              )
                  .animate(delay: 600.ms)
                  .fadeIn(duration: 800.ms)
                  .scaleXY(begin: 0.8, end: 1, duration: 700.ms, curve: Curves.elasticOut),

              SizedBox(height: screenHeight * 0.05),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameUserController,
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Usuario',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(Icons.person_outline, color: disdelGreen, size: 22),
                        filled: true,
                        fillColor: textFieldFillColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: disdelGreen, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su usuario';
                        }
                        return null;
                      },
                    )
                        .animate(delay: 900.ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: -0.5, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),

                    SizedBox(height: screenHeight * 0.025),

                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.black87, fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        prefixIcon: Icon(Icons.lock_outline, color: disdelGreen, size: 22),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: disdelGreen.withOpacity(0.9),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: textFieldFillColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: disdelGreen, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese su contraseña';
                        }
                        return null;
                      },
                    )
                        .animate(delay: 1100.ms)
                        .fadeIn(duration: 600.ms)
                        .slideX(begin: 0.5, end: 0, duration: 500.ms, curve: Curves.easeOutCubic),
                  ],
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 0),
                  child: Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: screenWidth * 0.035,
                    ),
                  )
                      .animate().shake(hz: 4, duration: 300.ms), // Animación para el mensaje de error
                ),

              SizedBox(height: _errorMessage != null ? screenHeight * 0.02 : screenHeight * 0.05),

              _isLoading
                  ? Center(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(disdelGreen)),
              ))
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: disdelGreen,
                  foregroundColor: Colors.white, // Cambiado a blanco para mejor contraste
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 6,
                  shadowColor: disdelGreen.withOpacity(0.5),
                ),
                onPressed: _performLogin,
                child: Text(
                  'INGRESAR',
                  style: TextStyle(fontSize: screenWidth * 0.043, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              )
                  .animate(delay: 1300.ms)
                  .fadeIn(duration: 700.ms)
                  .scaleXY(begin: 0.7, end: 1, duration: 600.ms, curve: Curves.elasticOut),

              SizedBox(height: screenHeight * 0.02),

              TextButton(
                onPressed: _isLoading ? null : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Funcionalidad "Olvidé contraseña" no implementada.'),
                      backgroundColor: disdelBlue.withOpacity(0.9),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(12),
                    ),
                  );
                },
                child: Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: disdelBlue.withOpacity(0.75), fontSize: screenWidth * 0.038),
                ),
              )
                  .animate(delay: 1500.ms)
                  .fadeIn(duration: 600.ms),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}