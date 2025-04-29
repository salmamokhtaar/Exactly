import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      final List decoded = jsonDecode(savedData);
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.cast<Map<String, String>>());
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
    await saveMessages();
    _scrollToBottom();

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
          {"role": "user", "content": userMessage},
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
        _messages.add({'role': 'bot', 'text': 'Error: ${response.statusCode}'});
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final inputBg = isDark ? Colors.grey.shade900 : Colors.white;
    final userBubble = isDark ? Colors.purple.shade700 : Colors.purple.shade100;
    final botBubble = isDark ? Colors.grey.shade800 : Colors.pink.shade50;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Caawiye Caafimaad'),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.white,
        foregroundColor: Colors.purple,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.green),
            onPressed: () => setState(() => _messages.clear()),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: isDark ? Colors.purple.shade900 : Colors.purple.shade100,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Lahadal Caawiye si uu ku caawiyo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _chatBubble('...', isUser: false, color: botBubble);
                }
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return _chatBubble(msg['text']!, isUser: isUser, color: isUser ? userBubble : botBubble);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'Chat with Caawiye...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: inputBg,
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

  Widget _chatBubble(String text, {required bool isUser, required Color color}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
