import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart'; // ✅ NEW
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
  final FlutterTts flutterTts = FlutterTts(); // ✅ TTS Instance

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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Bookmark removed')));
    } else {
      saved.add(current);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Saved to bookmarks')));
    }

    await prefs.setStringList('bookmarks', saved);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> speakAnswer() async {
    await flutterTts.setLanguage("en"); // Or use "so-SO" if Somali supported
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(widget.answer);
  }

  @override
  void dispose() {
    flutterTts.stop(); // ✅ Stop when screen is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3E5F5),
        title: const Text("Answer", style: TextStyle(color: Colors.purple)),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.help_outline, color: Colors.purple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Full Answer Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    widget.answer,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // TTS Button
            Align(
              alignment: Alignment.bottomLeft,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.volume_up),
                label: const Text("Read Answer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: speakAnswer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
