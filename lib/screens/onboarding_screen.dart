import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final void Function(bool) onThemeToggle;
  const OnboardingScreen({super.key, required this.onThemeToggle});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/on-board.png',
      'title': 'Kusoo dhawoow Caawiye App',
      'desc': 'Caawiye waa saaxiibkaaga caafimaadka af Soomaaliga ku hadla — weydii, dhagayso, oo wax ka baro si fudud.',
    },
    {
      'image': 'assets/ok.png',
      'title': 'Caafimaadka Hooyada',
      'desc': 'Talooyin ammaan ah iyo tilmaamo caafimaad oo kusaabsan uurka iyo daryeelka hooyonimada.',
    },
    {
      'image': 'assets/menstrual.png',
      'title': 'Caafimaadka Caadada',
      'desc': 'Bar nadaafadda caadada, wareeggeeda, iyo caafimaadka dumarka.',
    },
    {
      'image': 'assets/child.png',
      'title': 'Daryeelka Ilmaha',
      'desc': 'Ka hel talooyin caafimaad iyo daryeel ku habboon ilmahaaga.',
    },
  ];

  void _checkAndFinish() {
    if (_pageIndex == _slides.length - 1) {
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
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD6C1E9), Color(0xFFF5EAFE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Skip button only
          Positioned(
            top: 60,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(onThemeToggle: widget.onThemeToggle),
                  ),
                );
              },
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // PageView
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() => _pageIndex = index);
              _checkAndFinish();
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Column(
                children: [
                  const Spacer(),

                  // Image
                  Image.asset(
                    slide['image']!,
                    height: 280,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 30),

                  // Title
                  Text(
                    slide['title']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      slide['desc']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

                  // Dots (closer to description now)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _pageIndex == i ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _pageIndex == i ? Colors.purple : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
