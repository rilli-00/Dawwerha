import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dawwerha/screen/NotificationScreen.dart';
import 'package:dawwerha/screen/homeScreen.dart';
import 'package:dawwerha/screen/messagePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required otherUserID, required String chatID});

  Future<String> getUserName(String userId) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('user').doc(userId).get();
      if (userDoc.exists && userDoc.data()!.containsKey('name')) {
        return userDoc['name'];
      }
    } catch (e) {
      debugPrint("Error getting username: $e");
    }
    return 'مستخدم غير معروف';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('chats')
                .where('participants', arrayContains: currentUser.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد دردشات بعد'));
          }

          final chats = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final chatID = chats[index].id;
              final participants = List<String>.from(chat['participants']);
              final otherUserID = participants.firstWhere(
                (id) => id != currentUser.uid,
                orElse: () => 'Unknown',
              );

              return FutureBuilder<String>(
                future: getUserName(otherUserID),
                builder: (context, snapshot) {
                  final userName = snapshot.data ?? '...';

                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      radius: 24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(chat['lastMessage'] ?? ''),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MessagePage(
                                chatID: chatID,
                                otherUserID: otherUserID,
                              ),
                        ),
                      );
                    },
                  );
                },
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
