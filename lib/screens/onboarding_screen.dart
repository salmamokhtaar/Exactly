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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Skip button (top-right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
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
                      ],
                    ),

                    // App icon and name (only on first screen)
                    if (index == 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.medical_services_outlined, color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                              'Caawiye',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Title
                    Text(
                      slide['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Image with soft background
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Image.asset(
                        slide['image']!,
                        width: MediaQuery.of(context).size.width * 0.85,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Description
                    Text(
                      slide['desc']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: _currentPage == i ? 22 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _currentPage == i ? Colors.purple : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
