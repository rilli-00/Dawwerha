import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('notifications')
                .where('senderID', isEqualTo: currentUser!.uid)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No requests yet.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final itemName = data['itemName'] ?? 'Unknown';
              final status = data['status'] ?? 'Pending';
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedDate =
                  timestamp != null
                      ? DateFormat('yyyy-MM-dd').format(timestamp.toDate())
                      : 'Unknown';

              return Card(
                color: const Color(0xFFF2F2F2),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    'Product: $itemName',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Status: $status\nDate: $formattedDate',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black54,
                  ),
                  onTap: () {
                    // ممكن تضيف صفحة تفاصيل الطلب هنا لاحقًا
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
