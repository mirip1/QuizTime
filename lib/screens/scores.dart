import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HighScoreScreenState createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  String selectedCategory = "Video Games";

  final Map<String, int> categoryMap = {
    "Video Games": 15,
    "Computer Science": 18,
    "History": 23,
    "General Knowledge": 9,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A0080),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6100A8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "HighScore",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    selectedCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('highscores')
                    .where('category',
                        isEqualTo: categoryMap[selectedCategory].toString()) 
                    .orderBy('score', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "There are no scores yet",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  var scores = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      var player = scores[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['userEmail'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "${player['score']}pt",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 4,
                children: categoryMap.keys
                    .map((category) => _buildCategoryButton(
                        category, _getCategoryColor(category)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 70,
              color: const Color(0xFF6100A8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(LucideIcons.arrowLeft,
                        color: Colors.white, size: 32),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    icon: const Icon(LucideIcons.logOut,
                        color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Metodo utilizado para crear los botones de categoria de las preguntas
  Widget _buildCategoryButton(String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = label;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.5,),
        ),
      ),
    );
  }

  // Metodo para cambiar el color según la categoria
  Color _getCategoryColor(String category) {
    switch (category) {
      case "Video Games":
        return const Color(0xFFFFA800);
      case "Computer Science":
        return const Color(0xFFE31749);
      case "History":
        return const Color(0xFF3B28CC);
      case "General Knowledge":
        return const Color(0xFF00CC4F);
      default:
        return Colors.grey;
    }
  }
}
