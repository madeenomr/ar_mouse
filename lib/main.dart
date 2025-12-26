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
  // === 1. رقم الإصدار الحالي (عدله يدوياً عند كل تحديث) ===
  final String currentVersion = "1.0.2"; 
  
  // === 2. رابط ملف الإصدار (تأكد من تغيير USERNAME باسم حسابك) ===
  final String versionUrl = "https://raw.githubusercontent.com/USERNAME/ar_mouse/main/version.json";

  @override
  void initState() {
    super.initState();
    checkForUpdates(); // تشغيل الرادار
  }

  // دالة فحص التحديثات
  Future<void> checkForUpdates() async {
    try {
      final response = await http.get(Uri.parse(versionUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String serverVersion = data['version'];
        String downloadUrl = data['url'];

        // مقارنة الإصدارات
        if (serverVersion != currentVersion) {
          showUpdateDialog(downloadUrl);
        }
      }
    } catch (e) {
      print("خطأ في التحقق من التحديث: $e");
    }
  }

  // نافذة التنبيه
  void showUpdateDialog(String url) {
    showDialog(
      context: context,
      barrierDismissible: false, // يمنع إغلاق النافذة بالضغط خارجها
      builder: (context) => AlertDialog(
        title: const Text("تحديث جديد متوفر! 🚀"),
        content: const Text("تم إضافة ميزات جديدة وتحسين النصوص. هل تريد التحديث الآن؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("لاحقاً"),
          ),
          ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            child: const Text("تحديث الآن"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // لون خلفية هادئ
      appBar: AppBar(
        title: const Text("الماوس العربي", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView( // يسمح بالتمرير إذا كثرت الأزرار
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // === النصوص الترحيبية ===
              const Icon(Icons.touch_app, size: 80, color: Colors.teal),
              const SizedBox(height: 20),
              
              const Text(
                "السلام عليكم يا مدير النظام!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              
              Text(
                "الإصدار الحالي: $currentVersion",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              
              const SizedBox(height: 40),
              
              // === قائمة الأزرار ===
              
              // زر الماوس
              _buildMenuButton(Icons.mouse, "الماوس الذكي", () {
                // هنا سنضع كود الانتقال لصفحة الماوس
              }),
              
              const SizedBox(height: 15),
              
              // زر لوحة المفاتيح
              _buildMenuButton(Icons.keyboard, "لوحة المفاتيح", () {
                 // هنا سنضع كود الانتقال لصفحة الكيبورد
              }),
              
              const SizedBox(height: 15),
              
              // زر الوسائط (الجديد)
              _buildMenuButton(Icons.ondemand_video, "التحكم بالوسائط", () {
                 // هنا سنضع كود الانتقال لصفحة الوسائط
              }),
              
              // === مساحة لإضافة أزرار جديدة مستقبلاً ===
              
            ],
          ),
        ),
      ),
    );
  }

  // تصميم الزر الموحد
  Widget _buildMenuButton(IconData icon, String label, VoidCallback onTap) {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, 3)),
        ],
      ),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // الأيقونة والنص لليمين
          children: [
            Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(width: 15),
            Icon(icon, color: Colors.teal, size: 30),
          ],
        ),
      ),
    );
  }
}
