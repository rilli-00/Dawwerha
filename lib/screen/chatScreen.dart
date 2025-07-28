import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("الدردشة"),
        backgroundColor: Colors.black,
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
              // هنا مستقبلاً تروح لصفحة الرسائل بين المستخدمين
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('فتح محادثة مع ${chat['name']}')),
              );
            },
          );
        },
      ),
    );
  }
}
