import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'answer_screen.dart';
import 'category_screen.dart';

class CategoryLandingScreen extends StatelessWidget {
  const CategoryLandingScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'icon': IconlyLight.activity,
      'title': 'Maternal Health',
      'subtitle': 'Uurka iyo Dhalmada',
      'color': Color(0xFF9C27B0),
    },
    {
      'icon': IconlyLight.calendar,
      'title': 'Menstrual Health',
      'subtitle': 'Caafimaadka Caadada',
      'color': Color(0xFFE91E63),
    },
    {
      'icon': IconlyLight.user_1,
      'title': 'Child Care',
      'subtitle': 'Daryeelka Ilmaha',
      'color': Color(0xFF3F51B5),
    },
  ];

  Future<List<Map<String, String>>> loadAllQuestions() async {
    final String jsonString = await rootBundle.loadString(
      'assets/health_data.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    final List<Map<String, String>> all = [];

    data.forEach((category, items) {
      for (var q in items) {
        all.add({
          'question': q['question'],
          'answer': q['answer'],
          'audio': q['audio'],
        });
      }
    });

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDE7F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Caawiye Caafimaad',
          style: TextStyle(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.purple),
            onPressed: () {
              showSearch(
                context: context,
                delegate: LazyQuestionSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            ...categories.map(
              (cat) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryScreen(category: cat['title']!),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (cat['color'] as Color).withOpacity(0.15),
                      ),
                      child: Icon(cat['icon'], color: cat['color']),
                    ),
                    title: Text(
                      cat['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      cat['subtitle'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    trailing: const Icon(IconlyLight.arrow_right_2),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                '💡 Tip: Ask the chatbot if you need private help',
                style: TextStyle(fontSize: 14, color: Colors.purple),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LazyQuestionSearchDelegate extends SearchDelegate {
  List<Map<String, String>> results = [];

  @override
  String get searchFieldLabel => 'Search questions...';

  Future<void> searchFromJson(String keyword) async {
    final jsonString = await rootBundle.loadString('assets/health_data.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    results.clear();
    data.forEach((_, questions) {
      for (var q in questions) {
        if (q['question'].toLowerCase().contains(keyword.toLowerCase())) {
          results.add({
            'question': q['question'],
            'answer': q['answer'],
            'audio': q['audio'],
          });
        }
      }
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchFromJson(query),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return const Center(child: Text('Type to search...'));
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (results.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              title: Text(item['question']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AnswerScreen(
                          question: item['question']!,
                          answer: item['answer']!,
                          audioFile: item['audio']!,
                        ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }
}
