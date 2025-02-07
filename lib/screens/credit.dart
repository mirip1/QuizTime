import 'package:flutter/material.dart';


class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créditos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE31749),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desarrollado por:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Miguel Velasco Fernández',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Tecnologías utilizadas:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '- Flutter\n- Firebase\n- Open Trivia Database',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            
          ],
        ),
      ),
    );
  }
}