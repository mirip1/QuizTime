import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DifficultySelectionScreen extends StatefulWidget {
  final String category;

  const DifficultySelectionScreen({super.key, required this.category});

  @override
  _DifficultySelectionScreenState createState() =>
      _DifficultySelectionScreenState();
}

class _DifficultySelectionScreenState extends State<DifficultySelectionScreen> {
  String selectedDifficulty = "Hard";
  String displayCategory = "";

  @override
  void initState() {
    super.initState();

    switch (widget.category) {
      case "9":
        displayCategory = "General knowledge";
        break;
      case "15":
        displayCategory = "Video Games";
        break;
      case "18":
        displayCategory = "Computer Science";
        break;
      case "23":
        displayCategory = "History";
        break;
      default:
        displayCategory = widget.category;
    }
  }

  Color _getColorForDifficulty(String difficulty) {
    switch (difficulty) {
      case "Easy":
        return Colors.green;
      case "Medium":
        return Colors.orange;
      case "Hard":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = _getColorForDifficulty(selectedDifficulty);

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
                color: selectedColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayCategory,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Select the difficulty",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  _buildDifficultyOption("Easy", Colors.green),
                  _buildDifficultyOption("Medium", Colors.orange),
                  _buildDifficultyOption("Hard", Colors.red),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/game',
                      arguments: {
                        'category': widget.category,
                        'difficulty': selectedDifficulty,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "START !",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 80,
              color: selectedColor,
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
                      LucideIcons.home,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                  IconButton(
                    onPressed: () {

                      Navigator.pushNamed(context, "/login");
                    },
                    icon: const Icon(
                      LucideIcons.logOut,
                      color: Color.fromARGB(255, 255, 255, 255),
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

  Widget _buildDifficultyOption(String difficulty, Color color) {
    return ListTile(
      title: Text(
        difficulty,
        style:
            TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: color),
      ),
      leading: Radio<String>(
        value: difficulty,
        groupValue: selectedDifficulty,
        onChanged: (value) {
          setState(() {
            selectedDifficulty = value!;
          });
        },
      ),
    );
  }
}
