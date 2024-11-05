import 'package:flutter/material.dart';

class QuizHistoryPage extends StatelessWidget {
  const QuizHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final quizHistory = [
      {'title': 'Quiz Toán', 'score': 85, 'date': '2023-10-01'},
      {'title': 'Quiz Khoa Học', 'score': 90, 'date': '2023-10-05'},
      {'title': 'Quiz Lịch Sử', 'score': 78, 'date': '2023-10-10'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch Sử Quiz'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: quizHistory.length,
          itemBuilder: (context, index) {
            final quiz = quizHistory[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListTile(
                title: Text(quiz['title'] as String,
                    style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(
                    'Điểm: ${quiz['score'] as int} - Ngày: ${quiz['date'] as String}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
