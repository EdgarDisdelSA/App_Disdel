import 'package:flutter/material.dart';
import 'login_page.dart';    // Tu página de login existente
import 'splash_screen.dart'; // <<--- AÑADE ESTA IMPORTACIÓN (crearás este archivo)

// MyHomePage puede permanecer aquí o moverse a su propio archivo (ej. home_page.dart).
// Si lo mueves, asegúrate de importarlo aquí también.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App DISDEL', // Cambiado para reflejar el nombre de tu app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.deepPurple.withOpacity(0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            // Usar Theme.of(context) dentro de build, aquí usamos el color primario directamente
            borderSide: const BorderSide(color: Colors.deepPurple, width: 2), // O tu color primario
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // home: const LoginPage(), // <<--- ESTA LÍNEA CAMBIA
      home: const SplashScreen(),    // <<--- AHORA INICIAMOS CON EL SPLASH SCREEN
      routes: {
        // Define rutas nombradas para una navegación más limpia
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MyHomePage(title: 'DISDEL - Principal'), // Pasa el título requerido
        // Puedes añadir más rutas aquí para otras pantallas de tu app
      },
    );
  }
}

// MyHomePage se mantiene igual, pero ahora se accede después del login
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () {
              // Navegar de vuelta al LoginPage usando la ruta nombrada
              Navigator.pushReplacementNamed(context, '/login');
              // Antes era:
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => const LoginPage()),
              // );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Contenido principal de la aplicación:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}