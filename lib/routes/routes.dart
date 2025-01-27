import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';
import '../screens/difficulty.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    case '/register':
      return MaterialPageRoute(builder: (_) => const RegisterScreen());

    case '/quiz':
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    case '/difficulty':
      if (settings.arguments is Map<String, dynamic>) {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DifficultySelectionScreen(category: args['category']),
        );
      }
      return _errorRoute(); 

    default:
      return _errorRoute(); 
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("Error")),
      body: const Center(child: Text("Ruta no encontrada")),
    ),
  );
}
