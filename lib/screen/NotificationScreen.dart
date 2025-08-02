import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dawwerha/screen/chatScreen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<String> getSenderName(String senderID) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(senderID)
              .get();
      return doc.data()?['name'] ?? 'Unknown user';
    } catch (_) {
      return 'Unknown user';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .where('receiverID', isEqualTo: currentUserID)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final senderID = data['senderID'] ?? '';
              final itemName = data['itemName'] ?? 'Unknown item';
              final docId = doc.id;

              return FutureBuilder<String>(
                future: getSenderName(senderID),
                builder: (context, snapName) {
                  final senderName =
                      (snapName.connectionState == ConnectionState.done)
                          ? (snapName.data ?? 'Unknown user')
                          : '...';

                  return Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request from $senderName to borrow $itemName',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  final chatRef = FirebaseFirestore.instance
                                      .collection('chats');
                                  final chatQuery =
                                      await chatRef
                                          .where(
                                            'participants',
                                            arrayContains: senderID,
                                          )
                                          .get();
                                  String chatID;

                                  if (chatQuery.docs.isNotEmpty) {
                                    // استخدم الشات الموجود
                                    chatID = chatQuery.docs.first.id;
                                  } else {
                                    // إنشاء شات جديد
                                    chatID = chatRef.doc().id;
                                    await chatRef.doc(chatID).set({
                                      'chatID': chatID,
                                      'participants': [currentUserID, senderID],
                                      'lastMessage': 'Request accepted 🎉',
                                      'timestamp': FieldValue.serverTimestamp(),
                                    });
                                    await chatRef
                                        .doc(chatID)
                                        .collection('messages')
                                        .add({
                                          'senderID': currentUserID,
                                          'receiverID': senderID,
                                          'message': 'Request accepted 🎉',
                                          'timestamp':
                                              FieldValue.serverTimestamp(),
                                        });
                                  }

                                  // حذف الإشعار
                                  await FirebaseFirestore.instance
                                      .collection('notifications')
                                      .doc(docId)
                                      .delete();

                                  // فتح صفحة الدردشة
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ChatPage(
                                            chatID: chatID,
                                            otherUserID: senderID,
                                          ),
                                    ),
                                  );
                                },
                                child: const Text('Accepet'),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('notifications')
                                      .doc(docId)
                                      .delete();
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
