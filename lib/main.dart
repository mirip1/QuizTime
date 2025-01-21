import 'package:flutter/material.dart';
import 'routes/routes.dart';

void main() {
  runApp(const QuizTimeApp());
}

class QuizTimeApp extends StatelessWidget {
  const QuizTimeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: appRoutes,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF3E0),
  
        
    )
    );
  }
}
