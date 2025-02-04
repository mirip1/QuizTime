import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Método para manejar el inicio de sesión
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Inicia sesión con Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Muestra un SnackBar si el inicio de sesión es exitoso
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inicio de sesión correcto")),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/quiz');
    } on FirebaseAuthException catch (e) {
      // Manejo de errores de Firebase Authentication
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Usuario no encontrado.';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta.';
          break;
        case 'invalid-email':
          message = 'Correo electrónico inválido.';
          break;
        case 'network-request-failed':
          message = 'Error de conexión. Verifica tu internet.';
          break;
        case 'too-many-requests':
          message = 'Demasiados intentos. Inténtalo más tarde.';
          break;
        default:
          message = 'Error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 100,
                  width: 270,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),

                // Subtítulo "Log in"
                const Text(
                  "Log in",
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE31749),
                  ),
                ),
                const SizedBox(height: 35),

                // Campo de Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFFE31749)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo de Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFFE31749)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 70),

                // Botón de "Log in"
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31749),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 20),

                // Texto "Don't have an account? Sign up"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 231, 16, 127),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
