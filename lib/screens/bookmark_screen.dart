import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'answer_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<Map<String, dynamic>> savedQAs = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];

    setState(() {
      savedQAs = saved.map((entry) {
        final decoded = jsonDecode(entry);
        return {
          'question': decoded['question'],
          'answer': decoded['answer'],
          'audio': decoded['audio'],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: savedQAs.isEmpty
          ? const Center(child: Text("No saved questions yet"))
          : ListView.builder(
              itemCount: savedQAs.length,
              itemBuilder: (context, index) {
                final q = savedQAs[index]['question'] ?? '';
                final a = savedQAs[index]['answer'] ?? '';
                final audio = savedQAs[index]['audio'] ?? '';

                return ListTile(
                  title: Text(q),
                  subtitle: Text(
                    a,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnswerScreen(
                          question: q,
                          answer: a,
                          audioFile: audio,
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
