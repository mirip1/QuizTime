import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
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
              const SizedBox(height:35),
              // Campo de Username
              TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person, color:  Color(0xFFE31749)),
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
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock, color:  Color(0xFFE31749)),
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
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE31749),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Text(
                  "Log in",
                  style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 10),
              
              const SizedBox(height: 20),
              // Texto "Don't have account? Sign up"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have account?",
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color:  Color.fromARGB(255, 231, 16, 127),
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
    );
  }
}
