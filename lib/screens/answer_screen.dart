import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';

class AnswerScreen extends StatefulWidget {
  final String question;
  final String answer;
  final String audioFile;

  const AnswerScreen({
    super.key,
    required this.question,
    required this.answer,
    required this.audioFile,
  });

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  bool isBookmarked = false;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  void checkIfBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    final current = jsonEncode({
      'question': widget.question,
      'answer': widget.answer,
      'audio': widget.audioFile,
    });
    setState(() {
      isBookmarked = saved.contains(current);
    });
  }

  void toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    final current = jsonEncode({
      'question': widget.question,
      'answer': widget.answer,
      'audio': widget.audioFile,
    });

    if (isBookmarked) {
      saved.remove(current);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed')),
      );
    } else {
      saved.add(current);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to bookmarks')),
      );
    }

    await prefs.setStringList('bookmarks', saved);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> speakAnswer() async {
    await flutterTts.setLanguage("en");
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(widget.answer);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.purple.shade100;
    final answerBorderColor = isDark ? Colors.white10 : Colors.pink.shade100;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
            title: const Text(
              "Caawiye Caafimaad",
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.purple),
            actions: [
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.amber : Colors.grey,
                ),
                onPressed: toggleBookmark,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Block
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.help_outline, color: Colors.purple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Answer Block
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: answerBorderColor, width: 1.2),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.answer,
                    style: TextStyle(fontSize: 15.5, color: textColor),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.volume_up),
                    label: const Text("Akhri Jawaabta"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: speakAnswer,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text("Jooji"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: stopSpeaking,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
