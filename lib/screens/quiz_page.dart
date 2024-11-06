import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/models/selection_state.dart';
import 'package:vietnam_history/utils/dio_client.dart';
import 'package:collection/collection.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_card.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  final List<dynamic> quizData = [];
  final _dio = DioClient.instance;
  bool isLoading = false;
  final Map<int, List<String>> selectedAnswers = {};
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateQuiz();
  }

  void generateQuiz() async {
    // get data on provided topics
    var filter = Provider.of<SelectionState>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    var url = '/api/v1/conversations/generate-quiz';
    try {
      final response = await _dio.post(
        url,
        data: {
          'topic': filter.selectedTopic,
          'era': filter.selectedEra,
          'place': filter.selectedPlace,
          'figure': filter.selectedFigure,
          'artifact': filter.selectedArtifact,
          'limit': 10
        },
      );

      if (response.statusCode == 201) {
        setState(() {
          quizData.addAll(response.data['data']);
        });
      }
    } catch (e) {
      // Handle error if needed
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void submitAnswers() {
    score = 0;
    for (var i = 0; i < quizData.length; i++) {
      if (const ListEquality()
          .equals(selectedAnswers[i] ?? [], quizData[i]['answers'])) {
        score++;
      }
    }
    // open dialog to show score
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Result'),
          content: Text('You scored $score out of ${quizData.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: !isLoading,
        child: Scaffold(
            appBar: const CustomAppBar(title: 'Quiz'),
            body: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: quizData.length,
                          itemBuilder: (context, index) {
                            final question = quizData[index];
                            return CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question['question'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  const SizedBox(height: 10),
                                  ...question['options'].map<Widget>((option) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: CheckboxListTile(
                                        title: Text(option),
                                        value: selectedAnswers[index]
                                                ?.contains(option) ??
                                            false,
                                        onChanged: (isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              selectedAnswers[index] =
                                                  (selectedAnswers[index] ?? [])
                                                    ..add(option);
                                            } else {
                                              selectedAnswers[index]
                                                  ?.remove(option);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () => {
                            // map through selected answers and check if exists 1 or more answers in at least 1 question
                            if (selectedAnswers.values
                                .any((element) => element.isNotEmpty))
                              {submitAnswers()}
                            else
                              {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Please answer all questions before submitting.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
                          }, // Call submit function
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  )));
  }
}
