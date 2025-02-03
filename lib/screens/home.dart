import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFE31749),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi again, Francis",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Choose the Category",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(221, 255, 255, 255),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Categorías en forma de botones
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        16.0), // Agregar margen lateral a las categorías
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildCategoryButton(
                      label: "Video Games",
                      color: const Color(0xFFFFA800),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/difficulty',
                          arguments: {'category': '15'},
                        );
                      },
                    ),
                    _buildCategoryButton(
                      label: "Computer Science",
                      color: const Color(0xFFE31749),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/difficulty',
                          arguments: {'category': '18'},
                        );
                      },
                    ),
                    _buildCategoryButton(
                      label: "History",
                      color: const Color(0xFF3B28CC),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/difficulty',
                          arguments: {'category': '23'},
                        );
                      },
                    ),
                    _buildCategoryButton(
                      label: "General Knowledge",
                      color: const Color(0xFF00CC4F),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/difficulty',
                          arguments: {'category': '9'},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: double.infinity,
              height: 80,
              color: const Color(0xFFE31749),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      LucideIcons.logOut,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para los botones de categorías
  Widget _buildCategoryButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.all(16.0),
        elevation: 4,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
