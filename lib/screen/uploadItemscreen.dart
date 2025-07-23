import 'package:flutter/material.dart';

class UploadItemScreen extends StatelessWidget {
  const UploadItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Item"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: "Price per day",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text(
                "Upload Item",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
