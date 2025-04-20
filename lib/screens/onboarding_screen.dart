import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(bool) onThemeToggle;
  const OnboardingScreen({super.key, required this.onThemeToggle});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/on-board.png',
      'title': 'Welcome to Caawiye App',
      'desc': 'Your trusted Somali health helper.\nAsk, listen, and learn easily.',
    },
    {
      'image': 'assets/ok.png',
      'title': 'Maternal Health',
      'desc': 'Reliable guidance for safe pregnancy and motherhood.',
    },
    {
      'image': 'assets/menstrual.png',
      'title': 'Menstrual Health',
      'desc': 'Understand your cycle, hygiene, and health with ease.',
    },
    {
      'image': 'assets/child.png',
      'title': 'Child Care',
      'desc': 'Daryeel buuxa oo ku saabsan caafimaadka ilmahaaga.',
    },
  ];

  void _checkAndFinish() {
    if (_currentPage == _slides.length - 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(onThemeToggle: widget.onThemeToggle),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0FA),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _slides.length,
          onPageChanged: (index) {
            setState(() => _currentPage = index);
            _checkAndFinish();
          },
          itemBuilder: (context, index) {
            final slide = _slides[index];

            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      // Skip button
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomeScreen(onThemeToggle: widget.onThemeToggle),
                              ),
                            );
                          },
                          child: const Text("Skip", style: TextStyle(color: Colors.purple)),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Logo and name (first screen only)
                      if (index == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.medical_services_outlined, color: Colors.purple, size: 28),
                            SizedBox(width: 8),
                            Text(
                              'Caawiye',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Title
                      Text(
                        slide['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Image
                      Image.asset(
                        slide['image']!,
                        width: MediaQuery.of(context).size.width * 0.85,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 20),

                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          slide['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == i ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? Colors.purple : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
