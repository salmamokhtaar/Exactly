import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'answer_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String jsonString =
        await rootBundle.loadString('assets/health_data.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    setState(() {
      questions = data[widget.category] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                return ListTile(
                  title: Text(q['question']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnswerScreen(
                          question: q['question'],
                          answer: q['answer'],
                          audioFile: q['audio'], // for later audio playback
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
