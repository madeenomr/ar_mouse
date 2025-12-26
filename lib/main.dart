import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainMenu(),
  ));
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  // === هذا هو المتغير الذي ستغيره يدوياً في كل تحديث ===
  final String currentVersion = "1.0.0"; 
  
  // === رابط ملف الإصدار (غير USERNAME باسمك في GitHub) ===
  final String versionUrl = "https://raw.githubusercontent.com/USERNAME/ar_mouse/main/version.json";

  @override
  void initState() {
    super.initState();
    checkForUpdates(); // تشغيل الرادار عند فتح التطبيق
  }

  // === دالة الرادار: تفحص هل يوجد تحديث ===
  Future<void> checkForUpdates() async {
    try {
      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String serverVersion = data['version'];
        String downloadUrl = data['url'];

        // إذا كان الإصدار في الموقع أحدث من التطبيق
        if (serverVersion != currentVersion) {
          showUpdateDialog(downloadUrl);
        }
      }
    } catch (e) {
      print("فشل التحقق من التحديث: $e");
    }
  }

  // === نافذة التنبيه بالتحديث ===
  void showUpdateDialog(String url) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تحديث جديد متوفر! 🚀"),
        content: const Text("توجد نسخة جديدة ومحسنة من التطبيق. هل تريد تحميلها؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("لاحقاً"),
          ),
          ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
            child: const Text("تحديث الآن"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة التحكم"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      // === هنا يبدأ تصميمك يا مبرمج ===
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "مرحباً بك في مشروعك الجديد",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            
            // مثال لزر القائمة (يمكنك تكراره وتغيير الأيقونات)
            _buildMenuButton(Icons.mouse, "الماوس", () {
              // هنا سننتقل لصفحة الماوس
            }),
            
            const SizedBox(height: 20),
            
            _buildMenuButton(Icons.keyboard, "لوحة المفاتيح", () {
              // هنا سننتقل لصفحة الكيبورد
            }),
            
             const SizedBox(height: 20),
            
             _buildMenuButton(Icons.ondemand_video, "التحكم بالوسائط", () {
              // صفحة الوسائط
            }),
          ],
        ),
      ),
    );
  }

  // === دالة مساعدة لصنع زر جميل ===
  Widget _buildMenuButton(IconData icon, String label, VoidCallback onTap) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          elevation: 5,
          alignment: Alignment.centerRight, // محاذاة لليمين لأننا عرب
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
