import 'package:flutter/material.dart';

class UploadItemScreen extends StatefulWidget {
  const UploadItemScreen({super.key});

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  DateTime? availabilityDate;
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // يخلي السهم أبيض
        title: const Text(
          "Add New Item",
          style: TextStyle(color: Colors.white), // عنوان أبيض
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // صف فيه اسم المنتج + أيقونة الصورة
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Item Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // أيقونة الصورة
                  IconButton(
                    onPressed: () {
                      // تفعيل اختيار الصورة
                    },
                    icon: const Icon(Icons.image_outlined),
                    iconSize: 30,
                    color: Colors.black,
                    tooltip: "Upload Image",
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // وصف المنتج
              TextField(
                decoration: InputDecoration(
                  labelText: "Item Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // اختيار التاريخ
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Availability Date",
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: availabilityDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      availabilityDate = pickedDate;
                      dateController.text =
                          "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                    });
                  }
                },
              ),
              const SizedBox(height: 25),

              // زر الرفع
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  // تنفيذ عملية الرفع
                },
                child: const Text(
                  "Upload Item",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
