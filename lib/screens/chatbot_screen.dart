import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final apiKey = dotenv.env['OPENROUTER_API_KEY'];

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('chat_history');
    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      setState(() {
        _messages.clear();
        _messages.addAll(
          decoded.map<Map<String, String>>(
              (item) => Map<String, String>.from(item as Map)).toList(),
        );
      });
    }
  }

  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', jsonEncode(_messages));
  }

  Future<void> sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();
    await saveMessages();

    final response = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
        "HTTP-Referer": "https://caawiye.app",
        "X-Title": "Caawiye Somali Chatbot"
      },
      body: jsonEncode({
        "model": "openai/gpt-3.5-turbo",
        "messages": [
          {"role": "system", "content": "You are a helpful Somali health assistant."},
          {"role": "user", "content": userMessage}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final reply = decoded['choices'][0]['message']['content'];

      setState(() {
        _messages.add({'role': 'bot', 'text': reply.trim()});
        _isTyping = false;
      });
      await saveMessages();
      _scrollToBottom();
    } else {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Error: ${response.statusCode} - ${response.body}',
        });
        _isTyping = false;
      });
      await saveMessages();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> startNewConversation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('chat_history');

    if (savedData != null) {
      final List<dynamic> decoded = jsonDecode(savedData);
      final List<Map<String, String>> history = decoded
          .map<Map<String, String>>((item) => Map<String, String>.from(item as Map))
          .toList();

      final allDataString = prefs.getString('chat_conversations');
      List<List<Map<String, String>>> conversations = [];

      if (allDataString != null) {
        conversations = (jsonDecode(allDataString) as List)
            .map((item) => (item as List)
                .map((e) => Map<String, String>.from(e as Map))
                .toList())
            .toList();
      }

      conversations.add(history);
      await prefs.setString('chat_conversations', jsonEncode(conversations));
    }

    await prefs.remove('chat_history');
    setState(() => _messages.clear());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Previous conversation saved. Starting new one.")),
    );
  }

  Future<void> viewHistoryDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('chat_history');

    if (savedData == null) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Chat History"),
          content: Text("No saved chat found."),
        ),
      );
      return;
    }

    final List<dynamic> decoded = jsonDecode(savedData);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chat History"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: decoded.length,
            itemBuilder: (context, index) {
              final entry = decoded[index];
              final role = entry['role'];
              final text = entry['text'];

              return ListTile(
                leading: Icon(
                  role == 'user' ? Icons.person : Icons.smart_toy,
                  color: role == 'user' ? Colors.blue : Colors.purple,
                ),
                title: Text(
                  role == 'user' ? "👤 You: $text" : "🤖 Bot: $text",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      _messages.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Chat history cleared.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userBubbleColor = isDark ? Colors.deepPurple.shade700 : Colors.purple.shade100;
    final botBubbleColor = isDark ? Colors.grey.shade800 : Colors.white;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF6F0FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Caawiye Chatbot'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Colors.purple,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            tooltip: "Start New Chat",
            onPressed: startNewConversation,
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.purple),
            onPressed: viewHistoryDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: clearHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Typing...",
                        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser ? userBubbleColor : botBubbleColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text'] ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Chat with Caawiye...',
                      filled: true,
                      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.purple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
