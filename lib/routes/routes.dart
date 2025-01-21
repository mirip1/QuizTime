import 'package:flutter/material.dart';
import '../screens/login.dart';
import '../screens/register.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (BuildContext context) => const LoginScreen(),
  '/register': (BuildContext context) => const RegisterScreen(),
};
