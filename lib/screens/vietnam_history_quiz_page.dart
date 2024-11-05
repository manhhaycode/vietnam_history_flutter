import 'package:flutter/material.dart';

class VietnamHistoryQuizPage extends StatefulWidget {
  final List<dynamic> quizData;

  const VietnamHistoryQuizPage({super.key, required this.quizData});

  @override
  _VietnamHistoryQuizPageState createState() => _VietnamHistoryQuizPageState();
}

class _VietnamHistoryQuizPageState extends State<VietnamHistoryQuizPage> {
  int _currentQuestionIndex = 0;
  late final List<dynamic> _questions;

  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _questions = widget.quizData;
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedOption = null; // Reset selected option for the next question
      } else {
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hoàn thành Quiz'),
        content: const Text('Bạn đã hoàn thành quiz về lịch sử Việt Nam!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Lịch Sử Việt Nam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['question'] as String,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ...(question['options']).map((option) {
              return ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: _selectedOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedOption == null ? null : _nextQuestion,
              child: const Text('Tiếp theo'),
            ),
          ],
        ),
      ),
    );
  }
}
