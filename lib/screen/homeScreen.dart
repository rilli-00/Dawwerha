import 'package:dawwerha/screen/uploadItemscreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildCategoryButton("All"),
                const SizedBox(width: 8),
                _buildCategoryButton("Electronics"),
                const SizedBox(width: 8),
                _buildCategoryButton("Books"),
              ],
            ),
            const SizedBox(height: 12),

            // الأغراض
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
                    price: "\$15/day",
                  ),
                  _ItemCard(
                    image:
                        "https://cdn.pixabay.com/photo/2016/05/18/23/30/books-1404387_1280.jpg",
                    title: "Stack of Novels",
                    price: "\$5/day",
                  ),
                  _ItemCard(
                    image:
                        "https://cdn.pixabay.com/photo/2017/01/20/00/30/knife-1999654_1280.jpg",
                    title: "Kitchen Knife Set",
                    price: "\$8/day",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadItemScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategoryButton(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {},
      child: Text(title),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const _ItemCard({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
