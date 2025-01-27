import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/register.dart';
import '../screens/home.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
  '/quiz': (BuildContext context) => const HomeScreen(), 
};
