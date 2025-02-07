import 'dart:async';
import 'package:flutter/material.dart';
import '../api/apiservice.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


//Metodo para guardar los puntos en Firebase si es su marca personal
void _saveScoreToFirebase(String category, String difficulty, int score) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }


  int finalScore = _calculateFinalScore(difficulty, score);

  final highscoreRef = FirebaseFirestore.instance
      .collection('highscores')
      .doc('${user.uid}-$category');

  try {
    final highscoreDoc = await highscoreRef.get();
    int previousScore = highscoreDoc.exists ? (highscoreDoc.data()?['score'] ?? 0) : 0;

    if (finalScore > previousScore) {
      await highscoreRef.set({
        'userId': user.uid,
        'userEmail': user.email ,
        'category': category,
        'difficulty': difficulty,
        'score': finalScore,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } 
    
  } catch (e){
    return ;
  }
}

  //Metodo que calcula los puntos segun la difficultad y las respuestas respondidas correctamente
  int _calculateFinalScore(String difficulty, int score) {
    if (difficulty == 'easy') return score * 1;
    if (difficulty == 'medium') return (score * 1.5).round();
    if (difficulty == 'hard') return score * 2;
    return score;
  }

  //metodo que llama a la api y muestra las preguntas
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
          allAnswers.shuffle();
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

  //Metodo para iniciar un contador
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _showGameOverDialog();
      }
    });
  }

  //Metodo que muestra las respuestas y las mezcla
  void _setCurrentAnswers() {
    if (_questions.isNotEmpty) {
      final currentQuestion = _questions[_currentQuestionIndex];
      _shuffledAnswers = List<String>.from(currentQuestion['shuffled_answers']);
    }
  }

  //Texto que formateea el texto cogido de la api para que sea legible
  String formatText(String text) {
    final unescape = HtmlUnescape();
    return unescape.convert(text);
  }

  //metodo para pasar a la  siguiente pregunta
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

  //metodo que comprueba si una respuesta es correcta
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

  //metodo para mostrar el dialogo si has perdido
  void _showGameOverDialog() async {
    _timer?.cancel();
    int finalScore = _calculateFinalScore(widget.difficulty, _score);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final highscoreRef = FirebaseFirestore.instance
        .collection('highscores')
        .doc('${user.uid}-${widget.category}');

    final highscoreDoc = await highscoreRef.get();
    int previousScore =
        highscoreDoc.exists ? (highscoreDoc.data()?['score'] ?? 0) : 0;

    bool isNewPB = finalScore > previousScore;

    // Guardar el puntaje en Firebase (solo si es un nuevo PB)
    _saveScoreToFirebase(widget.category, widget.difficulty, _score);

   
    String scoreMessage = "Your score: $finalScore";
    if (isNewPB) scoreMessage += " (PB)"; // Agregar (PB) si es récord

    // Mostrar el diálogo con la puntuación si pierdes
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(scoreMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/quiz");
            },
            child: const Text('Exit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  //metodo para mostrar el dialogo si has perdido
  void _showGameResult() {
    _timer?.cancel();

    _saveScoreToFirebase(widget.category, widget.difficulty, _score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Juego terminado!'),
        content: Text('Tu puntuación es: $_score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/quiz', (route) => false);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  //MEtodo que muestar un mensaje de error
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
  //metodo para reiniciar el juego
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
                      color: Colors.white,
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
              child: Text(
                formatText(currentQuestion['question']),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ..._shuffledAnswers.map(
              (answer) => RadioListTile<String>(
                title: Text(formatText(answer)),
                value: answer,
                groupValue: _selectedAnswer,
                onChanged: (value) {
                  setState(() => _selectedAnswer = value);
                  _checkAnswer(value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
