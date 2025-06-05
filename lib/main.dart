import 'package:flutter/material.dart';
import 'login_page.dart';    // Tu página de login existente
import 'splash_screen.dart'; // Tu pantalla de splash
import 'home_page.dart';     // <<--- AÑADE ESTA IMPORTACIÓN

// Colores de la empresa (puedes definirlos aquí para usarlos en el tema)
// O usar los nuevos que sugerí:
const Color disdelPrimaryBlue = Color(0xFF135EAB);
const Color disdelAccentGreen = Color(0xFF96C121);
const Color pageBackgroundColor = Color(0xFFF4F6F8);
const Color cardBackgroundColor = Colors.white;
const Color textPrimaryColor = Color(0xFF333333);
const Color textSecondaryColor = Color(0xFF777777);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App DISDEL',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),    // Iniciamos con el Splash Screen
      routes: {
        '/login': (context) => const LoginPage(),
        // '/select_role': (context) => const SelectRolePage(), // SE ELIMINA O COMENTA
        '/home': (context) => const HomePage(title: 'DISDEL Panel Principal'), // <<--- CAMBIO AQUÍ
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: disdelPrimaryBlue,
          primary: disdelPrimaryBlue,
          secondary: disdelAccentGreen,
          background: pageBackgroundColor,
          surface: cardBackgroundColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white, // Puedes cambiar esto a Colors.black si el verde es muy claro para texto blanco
          onError: Colors.white,
          error: Colors.red.shade700,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: pageBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: disdelPrimaryBlue,
          foregroundColor: Colors.white,
          elevation: 2.0,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme( // Mantén tus estilos o ajusta
          filled: true,
          fillColor: const Color(0xFFF0F0F0), // textFieldFillColor original
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: disdelAccentGreen, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.red.shade700, width: 2.0),
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600),
          prefixIconColor: disdelAccentGreen,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: disdelAccentGreen,
            foregroundColor: Colors.white, // Color del texto del botón
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5,
            shadowColor: disdelAccentGreen.withOpacity(0.4),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: disdelPrimaryBlue.withOpacity(0.85),
            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3.0, // Un poco menos de elevación para un look más plano
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Bordes más suaves
          ),
          color: cardBackgroundColor,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0), // Sin margen horizontal por defecto para que ocupen el ancho
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: disdelAccentGreen,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
            headlineSmall: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 22),
            titleLarge: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w600, fontSize: 18),
            titleMedium: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.w500, fontSize: 16),
            bodyLarge: TextStyle(color: textPrimaryColor, fontSize: 16, height: 1.4),
            bodyMedium: TextStyle(color: textSecondaryColor, fontSize: 14, height: 1.4),
            bodySmall: TextStyle(color: textSecondaryColor, fontSize: 12),
            labelLarge: TextStyle(color: disdelPrimaryBlue, fontWeight: FontWeight.bold, fontSize: 15) // Para texto en botones (ej. ElevatedButton con fondo blanco)
        ),
      ),
    );
  }
}

// ELIMINA LA DEFINICIÓN DE MyHomePage y _MyHomePageState DE AQUÍ
// class MyHomePage extends StatefulWidget { ... }
// class _MyHomePageState extends State<MyHomePage> { ... }