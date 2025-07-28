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
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _bottomNavItem(
                icon: Icons.home,
                label: 'Home',
                onTap: () {},
                isActive: false,
              ),
              _bottomNavItem(
                icon: Icons.notifications,
                label: 'Notifications',
                onTap: () {},
                isActive: true,
              ),
              _bottomNavItem(
                icon: Icons.chat,
                label: 'Chat',
                onTap: () {},
                isActive: false,
              ),
            ],
          ),
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

  Widget _bottomNavItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final iconColor = isActive ? Colors.white : Colors.grey[700];
    final bgColor = isActive ? Colors.black : Colors.transparent;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: iconColor),
          ),
        ],
      ),
    );
  }
}
