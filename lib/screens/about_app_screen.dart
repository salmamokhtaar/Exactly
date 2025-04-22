import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1F1F1F) : Colors.white;
    final borderColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    Widget buildInfoCard({
      required String emoji,
      required String title,
      required String description,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$emoji  $title",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey[300] : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Caawiye Caafimaad"),
        backgroundColor: isDark ? Colors.black : const Color(0xFFEDE7F6),
        foregroundColor: Colors.purple,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildInfoCard(
                    emoji: "📱",
                    title: "App Name",
                    description: "Caawiye Caafimaad",
                  ),
                  buildInfoCard(
                    emoji: "🎯",
                    title: "Goal",
                    description:
                        "To provide easy access to Somali health guidance — in your language, at your fingertips.",
                  ),
                  buildInfoCard(
                    emoji: "🤔",
                    title: "Why this App?",
                    description:
                        "Many Somalis lack reliable health information. Caawiye bridges the gap with trusted answers and a friendly chatbot.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  "Made with ❤️ in Somalia",
                  style: TextStyle(
                    color: Colors.purple,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Developed by Salma",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                // Cards below...
              ],
            ),
          ],
        ),
      ),
    );
  }
}
