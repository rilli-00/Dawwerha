import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEFEFEF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _notificationItem(
                text: 'Alex requested to borrow the "Lawn Mower".',
                date: 'Today',
              ),
              _notificationItem(
                text: 'You approved the "Tent" rental request.',
                date: 'Yesterday',
              ),
              _notificationItem(
                text: 'Jamie added "Bicycle" for rent. Price: 150﷼.',
                date: '05/09/2023',
              ),
              _notificationItem(
                text: 'Chris requested to borrow "Camping Gear".',
                date: '01/09/2023',
              ),
              _notificationItem(
                text: 'Morgan added "Skis" for rent. Price: 300﷼.',
                date: '31/08/2023',
              ),
              _notificationItem(
                text: 'You added "Table" for community lending.',
                date: '31/08/2023',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () {}),
            IconButton(icon: const Icon(Icons.chat), onPressed: () {}),
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem({
    required String text,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }
}
