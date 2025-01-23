import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiztime/firebase_options.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ));
  }
}
