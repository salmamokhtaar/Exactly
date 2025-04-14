import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AnswerScreen extends StatefulWidget {
  final String question;
  final String answer;
  final String audioFile;

  const AnswerScreen({
    Key? key,
    required this.question,
    required this.answer,
    required this.audioFile,
  }) : super(key: key);

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  bool isBookmarked = false;

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
      'audio': widget.audioFile
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
      'audio': widget.audioFile
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Answer"),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
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
            Text(
              widget.question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              widget.answer,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            // Future: add audio playback here
          ],
        ),
      ),
    );
  }
}
