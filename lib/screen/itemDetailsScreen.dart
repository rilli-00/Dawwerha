import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetails extends StatelessWidget {
  final String itemId;

  const ItemDetails({
    super.key,
    required this.itemId,
    required String image,
    required String title,
    required String availability,
    required String description,
    required String ownerID,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('items').doc(itemId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('المنتج غير موجود'));
          }

          final data = snapshot.data!;
          final image = data['pictureURL'] ?? '';
          final title = data['name'] ?? '';
          final availability = data['availabilityDate'] ?? '';
          final description = data['description'] ?? '';
          final ownerID = data['ownerID'] ?? '';

          String formattedDate = '';
          if (availability is Timestamp) {
            formattedDate = DateFormat(
              'yyyy-MM-dd',
            ).format(availability.toDate());
          } else if (availability is String) {
            formattedDate = availability.split('T').first;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      image.isNotEmpty
                          ? Image.network(
                            image,
                            height: 230,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 230,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 80,
                            ),
                          ),
                ),
                const SizedBox(height: 20),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'متاح من: $formattedDate',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "الوصف:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(description, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 40),

                if (currentUser != null && currentUser.uid != ownerID)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        // أضف الطلب في كولكشن requests
                        final requestDoc = await FirebaseFirestore.instance
                            .collection('requests')
                            .add({
                              'senderID': currentUser.uid,
                              'receiverID': ownerID,
                              'itemID': itemId,
                              'itemName': title,
                              'status': 'active',
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                        // ثم أضف الإشعار مع requestID
                        await FirebaseFirestore.instance
                            .collection('notifications')
                            .add({
                              'senderID': currentUser.uid,
                              'receiverID': ownerID,
                              'itemID': itemId,
                              'itemName': title,
                              'requestID':
                                  requestDoc.id, // ✅ ربط الإشعار بالطلب
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم إرسال الطلب")),
                        );
                      },
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "اطلب الآن",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      'لا يمكنك طلب منتجك الخاص',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
