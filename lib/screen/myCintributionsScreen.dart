import 'package:flutter/material.dart';

class MyContributionsPage extends StatelessWidget {
  const MyContributionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample contributions (dummy data)
    final List<Map<String, String>> contributions = [
      {
        'title': 'Used Laptop for Sale',
        'status': 'Active',
        'date': '2025-07-25',
      },
      {
        'title': 'Offering Graphic Design Help',
        'status': 'Completed',
        'date': '2025-07-20',
      },
      {
        'title': 'Old Books Donation',
        'status': 'Pending Approval',
        'date': '2025-07-18',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white, // <-- خلفية بيضاء
      appBar: AppBar(
        title: const Text('My Contributions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: contributions.length,
        itemBuilder: (context, index) {
          final item = contributions[index];
          return Card(
            color: const Color(0xFFF2F2F2), // لون فاتح للبطاقات
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                item['title'] ?? '',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Status: ${item['status']} \nDate: ${item['date']}',
                style: const TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.edit, color: Colors.black54),
              onTap: () {
                // Open contribution details or edit page
              },
            ),
          );
        },
      ),
    );
  }
}
