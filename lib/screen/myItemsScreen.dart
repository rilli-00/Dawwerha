import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyItemsPage extends StatelessWidget {
  const MyItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserID == null) {
      return const Scaffold(body: Center(child: Text('User not logged in')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('items')
                .where('ownerID', isEqualTo: currentUserID)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("You haven't added any items."));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final data = item.data() as Map<String, dynamic>;
              final itemID = item.id;
              final title = data['name'] ?? 'Unnamed';
              final date =
                  data['availabilityDate']?.toString().split("T").first ??
                  'No date';
              final image = data['pictureURL'] ?? '';

              return Card(
                color: const Color(0xFFF2F2F2),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading:
                      image.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                          : const Icon(Icons.image_not_supported, size: 40),
                  title: Text(title),
                  subtitle: Text('Date: $date'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Delete Item"),
                              content: const Text(
                                "Are you sure you want to delete this item?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('items')
                            .doc(itemID)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Item deleted")),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
