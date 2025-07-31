import 'package:flutter/material.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample request data
    final List<Map<String, String>> requests = [
      {'id': '1234', 'status': 'In Progress', 'date': '2025-07-30'},
      {'id': '1235', 'status': 'Delivered', 'date': '2025-07-28'},
      {'id': '1236', 'status': 'Canceled', 'date': '2025-07-20'},
    ];

    return Scaffold(
      backgroundColor: Colors.white, // <-- خلفية بيضاء
      appBar: AppBar(
        title: const Text('My Requests'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            color: const Color(0xFFF2F2F2), // لون ناعم بدل الأبيض الشفاف
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                'Order ID: ${request['id']}',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'Status: ${request['status']} \nDate: ${request['date']}',
                style: const TextStyle(color: Colors.black87),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
              onTap: () {
                // Optional: navigate to request details page
              },
            ),
          );
        },
      ),
    );
  }
}
