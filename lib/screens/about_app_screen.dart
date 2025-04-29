import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    const primaryColor = Color(0xFF9C27B0); // Your Caawiye purple

    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer's Info"),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo
            ZoomIn(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF9C27B0), // Caawiye purple
                ),
                child: Image.asset(
                  'assets/ok.png',
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            FadeInDown(
              child: Text(
                "Caawiye",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Description
            FadeIn(
              duration: const Duration(milliseconds: 600),
              child: Text(
                "Caawiye is a next-generation Somali health assistant app designed to provide accessible, trusted guidance on maternal, menstrual, and child health. Experience friendly support and timely answers through our AI-powered chatbot.",
                style: TextStyle(
                  fontSize: 15,
                  color: subTextColor,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),

            // Section Title
            const Text(
              "Developer's Info",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),

            const SizedBox(height: 20),

            // Developer Avatar
            BounceInDown(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/salma.jpg"),
              ),
            ),

            const SizedBox(height: 20),

            // Name
            Text(
              "Salma Mukhtar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 12),

            // Contact Card
            FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black26
                              : Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.phone, color: Colors.purple),
                        SizedBox(width: 8),
                        Text("+252617157083", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.email, color: Colors.purple),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "salmam.mohyadiin@gmail.com",
                            style: TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
