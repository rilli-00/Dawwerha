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
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
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
                image: 'assets/lawn.png',
                text: 'Alex requested to borrow the "Lawn Mower".',
                date: 'Today',
              ),
              _notificationItem(
                image: 'assets/tent.png',
                text: 'You approved the "Tent" rental request.',
                date: 'Yesterday',
              ),
              _notificationItem(
                image: 'assets/bicycle.png',
                text: 'Jamie added "Bicycle" for rent. Price: 150﷼.',
                date: '05/09/2023',
              ),
              _notificationItem(
                image: 'assets/camping.png',
                text: 'Chris requested to borrow "Camping Gear".',
                date: '01/09/2023',
              ),
              _notificationItem(
                image: 'assets/skis.png',
                text: 'Morgan added "Skis" for rent. Price: 300﷼.',
                date: '31/08/2023',
              ),
              _notificationItem(
                image: 'assets/table.png',
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
            const SizedBox(width: 48), // Space for FAB
            IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _notificationItem({
    required String image,
    required String text,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 48, height: 48, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
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
          ),
        ],
      ),
    );
  }
}
