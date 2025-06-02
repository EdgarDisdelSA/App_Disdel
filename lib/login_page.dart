import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Asegúrate de haber añadido este paquete

// Define los colores de tu empresa para fácil acceso
const Color disdelBlue = Color(0xFF004A8F); // Azul corporativo
const Color disdelGreen = Color(0xFF8BC53F); // Verde corporativo

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Color de fondo amigable elegido
    const Color pageBackgroundColor = Color(0xFFF5F5F5); // Un gris muy claro (off-white)

    // Color para el relleno de los campos de texto, ligeramente diferente al fondo
    final Color textFieldFillColor = Colors.grey.shade200;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: Container(
        color: pageBackgroundColor, // Aplicamos el color de fondo al container también
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // 1. Logo Animado
                Image.asset(
                  'assets/images/disdel_sa.png', // Reemplaza con 'disdel_inicio.gif' si prefieres el GIF
                  height: screenHeight * 0.15,
                )
                    .animate()
                    .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
                    .slideY(begin: -0.3, end: 0, duration: 700.ms, curve: Curves.easeOutExpo)
                    .then(delay: 200.ms)
                    .shimmer(duration: 1500.ms, color: disdelBlue.withOpacity(0.2)), // Shimmer más sutil

                SizedBox(height: screenHeight * 0.04),

                // 2. Texto de Bienvenida Animado
                Text(
                  'Bienvenido a',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.w300,
                    color: disdelBlue.withOpacity(0.85), // Texto oscuro para buen contraste
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
                      color: disdelBlue, // Texto oscuro principal
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow( // Sombra sutil para el texto principal
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
                      // 3. Campo de Usuario Animado
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Usuario o Correo',
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
                        keyboardType: TextInputType.emailAddress,
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

                      // 4. Campo de Contraseña Animado
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

                SizedBox(height: screenHeight * 0.05),

                // 5. Botón de Login Animado
                _isLoading
                    ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(disdelGreen)))
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: disdelGreen,
                    foregroundColor: disdelBlue,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019), // Ajuste ligero
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 6, // Elevación moderada
                    shadowColor: disdelGreen.withOpacity(0.5),
                  ),
                  onPressed: _login,
                  child: Text(
                    'INGRESAR',
                    style: TextStyle(fontSize: screenWidth * 0.043, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
                )
                    .animate(delay: 1300.ms)
                    .fadeIn(duration: 700.ms)
                    .scaleXY(begin: 0.7, end: 1, duration: 600.ms, curve: Curves.elasticOut)
                    .then(delay: 200.ms)
                    .shake(hz: 3, duration: 300.ms, curve: Curves.easeInOutCubic), // Shake un poco más suave

                SizedBox(height: screenHeight * 0.02),

                // 6. Botón de "Olvidé Contraseña" Animado
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

                SizedBox(height: screenHeight * 0.03), // Espacio extra al final
              ],
            ),
          ),
        ),
      ),
    );
  }
}