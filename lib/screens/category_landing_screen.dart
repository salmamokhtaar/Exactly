import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'category_screen.dart';

class CategoryLandingScreen extends StatelessWidget {
  const CategoryLandingScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'icon': IconlyLight.activity,
      'title': 'Uurka & Dhalmada',
      'subtitle': 'Caafimaadka Hooyada',
      'key': 'Maternal Health',
      'color': Color(0xFF9C27B0),
    },
    {
      'icon': IconlyLight.calendar,
      'title': 'Caadada Dumarka',
      'subtitle': 'Caafimaadka Caadada',
      'key': 'Menstrual Health',
      'color': Color(0xFFE91E63),
    },
    {
      'icon': IconlyLight.user_1,
      'title': 'Daryeelka Ilmaha',
      'subtitle': 'Caafimaadka Ilmaha',
      'key': 'Child Care',
      'color': Color(0xFF3F51B5),
    },
  ];

  final List<Map<String, dynamic>> tips = const [
    {
      'icon': IconlyLight.chat,
      'text': 'Weydii chatbot-ka haddii aad rabto caawimaad gaar ah.',
    },
    {
      'icon': IconlyLight.bookmark,
      'text': 'Akhriso su’aalaha ugu badan ee haweenku qabaan.',
    },
  ];

  Future<List<Map<String, String>>> loadCategoryQuestions(String categoryKey) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/health_data.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<Map<String, String>> questions = [];

      if (data.containsKey(categoryKey)) {
        for (var q in data[categoryKey]) {
          questions.add({
            'question': q['question'] ?? '',
            'answer': q['answer'] ?? '',
            'audio': q['audio'] ?? '',
          });
        }
      }
      return questions;
    } catch (e) {
      debugPrint('Error loading questions: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final hintColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Soo dhowow Caawiye 👋',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 6),
          Text(
            'Dooro qaybta aad rabto inaad wax ka barato.',
            style: TextStyle(fontSize: 15, color: hintColor),
          ),
          const SizedBox(height: 24),

          ...categories.map(
            (cat) => GestureDetector(
              onTap: () async {
                final questions = await loadCategoryQuestions(cat['key']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryScreen(
                      category: cat['title'],
                      questions: questions,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cat['color'], width: 1.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cat['color'].withOpacity(0.1),
                        ),
                        child: Icon(cat['icon'], color: cat['color'], size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['title'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat['subtitle'],
                              style: TextStyle(fontSize: 13, color: hintColor),
                            ),
                          ],
                        ),
                      ),
                      Icon(IconlyLight.arrow_right_2, color: hintColor),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          Text(
            '💡 Talooyin Faa’iido leh',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purple),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(tip['icon'], color: Colors.purple, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip['text'],
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
