import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_app_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const SettingsScreen({super.key, required this.onThemeToggle});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool somaliLang = true;
  bool notifications = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      darkMode = prefs.getBool('darkMode') ?? false;
      somaliLang = prefs.getBool('somaliLang') ?? true;
      notifications = prefs.getBool('notifications') ?? true;
    });
  }

  void updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    setState(() {
      if (key == 'darkMode') darkMode = value;
      if (key == 'somaliLang') somaliLang = value;
      if (key == 'notifications') notifications = value;
    });

    if (key == 'darkMode') widget.onThemeToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.purple)),
        backgroundColor: const Color(0xFFEDE7F6),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Preferences",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            value: darkMode,
            title: const Text("🌙 Dark Mode"),
            onChanged: (val) => updateSetting('darkMode', val),
          ),
          SwitchListTile(
            value: somaliLang,
            title: const Text("🌐 Somali Language"),
            onChanged: (val) => updateSetting('somaliLang', val),
          ),
          SwitchListTile(
            value: notifications,
            title: const Text("🔔 Notifications"),
            onChanged: (val) => updateSetting('notifications', val),
          ),
          const Divider(height: 40),
          const Text(
            "About App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("App Version"),
            subtitle: Text("1.0.0"),
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text("Privacy Policy"),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Dev & App"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutAppScreen()),
              );
            },
          ),
          const Divider(height: 40),

          // ✅ Fixed: removed `const` from here
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text("Rate the App"),
            onTap: () async {
              final Uri url = Uri.parse(
                  'https://play.google.com/store/apps/details?id=com.caawiye.app');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not open store link")),
                );
              }
            },
          ),

          const ListTile(
            leading: Icon(Icons.system_update_alt),
            title: Text("Check for Updates"),
          ),
        ],
      ),
    );
  }
}
