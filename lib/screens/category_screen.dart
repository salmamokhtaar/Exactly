import 'package:flutter/material.dart';
import 'answer_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<Map<String, String>> questions;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.questions,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<Map<String, String>> questions;

  @override
  void initState() {
    super.initState();
    questions = widget.questions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final hintColor = isDark ? Colors.white70 : Colors.black54;
    final borderColor = Colors.purple.shade100;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isDark ? Colors.white12 : Colors.white, width: 1.2)),
          ),
          child: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              widget.category,
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.purple),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: borderColor, width: 1.2),
            right: BorderSide(color: borderColor, width: 1.2),
          ),
        ),
        child: questions.isEmpty
            ? Center(
                child: Text(
                  'Su’aalo lama helin.',
                  style: TextStyle(color: hintColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.2),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnswerScreen(
                              question: q['question']!,
                              answer: q['answer']!,
                              audioFile: q['audio']!,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              q['question']!,
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w500,
                                color: textColor,
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.purple),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
