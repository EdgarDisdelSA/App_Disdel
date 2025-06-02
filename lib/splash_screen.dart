import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () { // Puedes ajustar la duración del splash
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // O el color de fondo que prefieras
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // --- ESTA ES LA PARTE CLAVE ---
            Image.asset(
              'assets/images/disdel_inicio.gif', // <<--- CAMBIA ESTO AL NOMBRE DE TU ARCHIVO GIF
              width: 200, // Ajusta el tamaño según necesites
              height: 200, // Ajusta el tamaño según necesites
              // gaplessPlayback: true, // A veces útil para evitar un breve "parpadeo" mientras el GIF carga
              // aunque para splash screens donde solo se muestra una vez, puede no ser necesario.
            ),
            // --- FIN DE LA PARTE CLAVE ---
            const SizedBox(height: 24),
            const Text(
              "Cargando DISDEL S.A...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}