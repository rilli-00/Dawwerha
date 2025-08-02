import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyContributionsPage extends StatelessWidget {
  const MyContributionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Contributions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('items')
                .where('ownerID', isEqualTo: uid)
                // تم حذف orderBy لتجنب مشكلة الـ index
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You haven't contributed any items."),
            );
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final data = items[index].data() as Map<String, dynamic>;

              return Card(
                color: const Color(0xFFF2F2F2),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['name'] ?? 'No name'),
                  subtitle: Text(
                    'Status: ${data['availability'] == true ? "Active" : "Inactive"}\n'
                    'Date: ${data['availabilityDate']?.toString().split("T").first ?? "No date"}',
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.black54),
                  onTap: () {
                    // فتح تفاصيل العنصر أو تعديل
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
