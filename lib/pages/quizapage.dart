import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:eby/utils/geminiservice.dart';

class QuizAPage extends StatefulWidget {
  final String topic;
  const QuizAPage({
    super.key,
    required this.topic,
  });

  @override
  State<QuizAPage> createState() => _QuizAPageState();
}

class _QuizAPageState extends State<QuizAPage> {
  List<Map<String, dynamic>> _quizQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  bool _isAnswered = false;
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
  }

  Future<void> _fetchQuizQuestions() async {
    try {
      final questions = await GeminiService().generateQuizQuestions(widget.topic);
      if (mounted) {
        setState(() {
          _quizQuestions = questions;
          log(_quizQuestions.toString());
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching quiz questions: $e")),
        );
      }
    }
  }

  void _handleOptionSelection(String selectedOption) {
    if (_isAnswered) return;

    final cleanSelectedAnswer = selectedOption.split(RegExp(r'\)\s*')).last.trim();
    final cleanCorrectAnswer = _quizQuestions[_currentQuestionIndex]['answer']
        .split(RegExp(r'\)\s*'))
        .last
        .trim();

    setState(() {
      _selectedOption = selectedOption;
      _isAnswered = true;
      
      // Compare answers and update score immediately
      if (cleanSelectedAnswer.toLowerCase() == cleanCorrectAnswer.toLowerCase()) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_currentQuestionIndex < _quizQuestions.length - 1) {
            _currentQuestionIndex++;
            _isAnswered = false;
            _selectedOption = null;
          } else {
            _showQuizCompletionDialog();
          }
        });
      }
    });
  }

  void _showQuizCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha(30),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Quiz Completed! 🎉",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "You scored $_score/${_quizQuestions.length}!",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_quizQuestions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            "No questions available for this topic.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final currentQuestion = _quizQuestions[_currentQuestionIndex];
    final questionText = currentQuestion['question'];
    final options = List<String>.from(currentQuestion['options']);
    final correctAnswer = currentQuestion['answer'];

    return PopScope(
      canPop: !_isAnswered,
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Quiz",
            style: TextStyle(color: Colors.white, fontFamily: 'Bowl'),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Score: $_score",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _quizQuestions.length,
                    backgroundColor: Colors.white.withAlpha(20),
                    color: Colors.white,
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Question ${_currentQuestionIndex + 1}/${_quizQuestions.length}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(20),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    questionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final cleanOption = option.split(RegExp(r'\)\s*')).last.trim();
                      final cleanCorrectAnswer = correctAnswer.split(RegExp(r'\)\s*')).last.trim();
                      
                      final isCorrect = _isAnswered && 
                          cleanOption.toLowerCase() == cleanCorrectAnswer.toLowerCase();
                      final isSelected = _isAnswered && 
                          option.trim() == _selectedOption?.trim();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _isAnswered
                                ? (isCorrect 
                                    ? Colors.green.shade100
                                    : (isSelected ? Colors.red.shade100 : Colors.white.withAlpha(90)))
                                : Colors.white.withAlpha(90),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _isAnswered
                                  ? (isCorrect 
                                      ? Colors.green
                                      : (isSelected ? Colors.red : Colors.transparent))
                                  : Colors.transparent,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _isAnswered ? null : () => _handleOptionSelection(option),
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: isCorrect || isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}