import 'package:flutter/material.dart';
import 'package:dawwerha/screen/chatScreen.dart';
import 'package:dawwerha/screen/homeScreen.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              NotificationRequest(
                name: 'Alex',
                item: 'Lawn Mower',
                date: 'Today',
                duration: 'من 1 أغسطس إلى 3 أغسطس',
              ),
              NotificationRequest(
                name: 'Chris',
                item: 'Camping Gear',
                date: '01/09/2023',
                duration: 'من 5 سبتمبر إلى 7 سبتمبر',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردشة'),
        ],
      ),
    );
  }
}

class NotificationRequest extends StatelessWidget {
  final String name;
  final String item;
  final String date;
  final String duration;

  const NotificationRequest({
    super.key,
    required this.name,
    required this.item,
    required this.date,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$name طلب استعارة "$item".',
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            'المدة: $duration',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // قبول الطلب
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('قبول'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // رفض الطلب
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('رفض'),
              ),
            ],
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
