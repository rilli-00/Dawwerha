import 'package:flutter/material.dart';
import 'package:dawwerha/screen/NotificationScreen.dart';
import 'package:dawwerha/screen/homeScreen.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        'name': 'Sarah',
        'message': 'تم الموافقة على طلبك 🎉',
        'time': 'الآن',
        'image': 'https://i.pravatar.cc/150?img=1',
      },
      {
        'name': 'Khaled',
        'message': 'هل المنتج لا زال متاح؟',
        'time': 'قبل 10 دقائق',
        'image': 'https://i.pravatar.cc/150?img=2',
      },
      {
        'name': 'Amina',
        'message': 'شكرًا لك، تم الاستلام 🙏',
        'time': 'أمس',
        'image': 'https://i.pravatar.cc/150?img=3',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'الدردشة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(chat['image']!),
              radius: 24,
            ),
            title: Text(
              chat['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chat['message']!),
            trailing: Text(
              chat['time']!,
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('فتح محادثة مع ${chat['name']}')),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
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
