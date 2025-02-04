import 'package:flutter/material.dart';
import '../screens/screens.dart';


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

    case '/trivia':
      if (settings.arguments is Map<String, dynamic>) {
        final args = settings.arguments as Map<String, dynamic>;
        if (args.containsKey('category') && args.containsKey('difficulty')) {
          return MaterialPageRoute(
            builder: (_) => TriviaScreen(
              category: args['category'],
              difficulty: args['difficulty'],
            ),
          );
        }
      }
      return _errorRoute();
    case '/highscore':
      return MaterialPageRoute(builder: (_) =>  const HighScoreScreen());


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
