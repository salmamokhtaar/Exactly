import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'category_screen.dart';

class CategoryLandingScreen extends StatelessWidget {
  const CategoryLandingScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = const [
    {
      'icon': IconlyLight.activity,
      'title': 'Maternal Health',
      'subtitle': 'Uurka iyo Dhalmada',
    },
    {
      'icon': IconlyLight.calendar,
      'title': 'Menstrual Health',
      'subtitle': 'Caafimaadka Caadada',
    },
    {
      'icon': IconlyLight.user_1,
      'title': 'Child Care',
      'subtitle': 'Daryeelka Ilmaha',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caawiye Caafimaad'),
        centerTitle: true,
      ),
     body: SingleChildScrollView(
  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24), // ⬅ top margin added here
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: categories.map((cat) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(cat['icon'], color: Colors.purple),
          title: Text(cat['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(cat['subtitle']),
          trailing: const Icon(IconlyLight.arrow_right_2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryScreen(category: cat['title']!),
              ),
            );
          },
        ),
      );
    }).toList(),
  ),
),

    );
  }
}
