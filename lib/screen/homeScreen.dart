import 'package:dawwerha/screen/itemDetailsScreen.dart';
import 'package:dawwerha/screen/NotificationScreen.dart';
import 'package:dawwerha/screen/uploadItemScreen.dart';
import 'package:dawwerha/screen/chatScreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dawwerha"),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.person, color: Colors.black),
            onSelected: (value) {
              // Handle menu actions
            },
            itemBuilder: (BuildContext context) {
              return ['حسابي', 'طلباتي', 'مساهماتي'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for items...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
                children: const [
                  _ItemCard(
                    image:
                        "https://cdn.pixabay.com/photo/2014/08/23/19/39/camera-425204_1280.jpg",
                    title: "Canon DSLR Camera",
                    availability: "متوفر من 1 أغسطس إلى 5 أغسطس",
                    description:
                        "كاميرا احترافية مناسبة لهواة التصوير، تشمل العدسات والحقيبة.",
                  ),
                  _ItemCard(
                    image:
                        "https://cdn.pixabay.com/photo/2016/05/18/23/30/books-1404387_1280.jpg",
                    title: "Stack of Novels",
                    availability: "متوفر من 10 أغسطس إلى 12 أغسطس",
                    description: "مجموعة روايات مشوقة للقراءة أثناء العطلة.",
                  ),
                  _ItemCard(
                    image:
                        "https://cdn.pixabay.com/photo/2017/01/20/00/30/knife-1999654_1280.jpg",
                    title: "Kitchen Knife Set",
                    availability: "متوفر من 3 أغسطس إلى 6 أغسطس",
                    description:
                        "مجموعة سكاكين مطبخ حادة وحديثة للطهي الاحترافي.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // زر + لإضافة منتج
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 70, // ارفعيه فوق البار
            right: 16, // جهة اليمين
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const UploadItemScreen()),
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'الدردشة'),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String availability;
  final String description;

  const _ItemCard({
    required this.image,
    required this.title,
    required this.availability,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ItemDetails(
                  image: image,
                  title: title,
                  availability: availability,
                  description: description,
                ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
