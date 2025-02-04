import 'dart:async';
import 'package:flutter/material.dart';
import '../api/apiservice.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


void _saveScoreToFirebase(String category, String difficulty, int score) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return; // Si no hay usuario autenticado, no guardar

  int finalScore = _calculateFinalScore(difficulty, score);

  await FirebaseFirestore.instance.collection('highscores').add({
    'userId': user.uid, // UID del usuario autenticado
    'userName': user.displayName ?? 'Anónimo', // Nombre o 'Anónimo'
    'category': category,
    'difficulty': difficulty,
    'score': finalScore,
    'timestamp': FieldValue.serverTimestamp(), // Para ordenar por fecha
  });
}

int _calculateFinalScore(String difficulty, int score) {
  if (difficulty == 'easy') return score * 1;
  if (difficulty == 'medium') return (score * 1.5).round();
  if (difficulty == 'hard') return score * 2;
  return score;
}
class TriviaScreen extends StatefulWidget {
  final String category;
  final String difficulty;

  const TriviaScreen({
    super.key,
    required this.category,
    required this.difficulty,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TriviaScreenState createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  Timer? _timer;
  int _timeLeft = 10;
  String? _selectedAnswer;
  List<String> _shuffledAnswers = [];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    setState(() => _isLoading = true);

    try {
      final int? categoryId = int.tryParse(widget.category);
      if (categoryId == null) {
        throw Exception("Categoría no válida: ${widget.category}");
      }

      final questions = await _apiService.getQuestions(
        amount: 15,
        difficulty: widget.difficulty,
        category: categoryId,
        type: 'multiple',
      );

      if (questions.isEmpty) {
        throw Exception("No se encontraron preguntas.");
      }

      setState(() {
        _questions = questions.map((q) {
          List<String> allAnswers = [
            ...q['incorrect_answers'],
            q['correct_answer']
          ];
          allAnswers.shuffle(); // Se mezclan solo una vez
          return {...q, 'shuffled_answers': allAnswers};
        }).toList();
        _isLoading = false;
        _setCurrentAnswers();
        _startTimer();
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Se cancela cualquier temporizador anterior
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _showGameOverDialog();
      }
    });
  }

  void _setCurrentAnswers() {
    if (_questions.isNotEmpty) {
      final currentQuestion = _questions[_currentQuestionIndex];
      _shuffledAnswers = List<String>.from(currentQuestion['shuffled_answers']);
    }
  }
  String formatText(String text) {
    final unescape = HtmlUnescape();
    return unescape.convert(text);
  }

  void _nextQuestion() {
    _timer?.cancel();

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeLeft = 10;
        _selectedAnswer = null;
        _setCurrentAnswers();
        _startTimer();
      });
    } else {
      _showGameResult();
    }
  }

  void _checkAnswer(String selectedAnswer) {
    _timer?.cancel();
    final correctAnswer = _questions[_currentQuestionIndex]['correct_answer'];

    if (selectedAnswer == correctAnswer) {
      setState(() => _score++);
      _nextQuestion();
    } else {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('Has perdido. Inténtalo de nuevo.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
             Navigator.pushNamed(context, "/quiz");
            },
            child: const Text('Salir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }

  void _showGameResult() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Juego terminado!'),
        content: Text('Tu puntuación es: $_score/30'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    _timer?.cancel();
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _timeLeft = 10;
      _selectedAnswer = null;
      _setCurrentAnswers();
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Menu'),
          ),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.category.toUpperCase(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Diff: ${widget.difficulty.toUpperCase()}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Q.Number: ${_currentQuestionIndex + 1}/15',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _timeLeft / 10,
            
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(formatText(
                currentQuestion[formatText('question')]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 3, 0, 0),
                ),
              ),
            ),
            ..._shuffledAnswers.map(
              (answer) => RadioListTile<String>(
                title:
                    Text(formatText(answer), style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                value: answer,
                groupValue: _selectedAnswer,
                onChanged: (value) {
                  setState(() => _selectedAnswer = value);
                  _checkAnswer(value!);
                },
                activeColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
