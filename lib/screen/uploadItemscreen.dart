import 'package:dawwerha/cubit/upload_item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadItemScreen extends StatefulWidget {
  const UploadItemScreen({super.key});

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _availabilityDate;
  String? _uploadedImageURL;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UploadItemCubit(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Add New Item",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<UploadItemCubit, UploadItemState>(
          listener: (context, state) {
            if (state is UploadItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item uploaded successfully')),
              );
              Navigator.pop(context);
            } else if (state is UploadItemError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Item Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed:
                              state is UploadItemLoading
                                  ? null
                                  : () async {
                                    try {
                                      final url =
                                          await context
                                              .read<UploadItemCubit>()
                                              .pickAndUploadImage();
                                      if (url != null) {
                                        setState(() {
                                          _uploadedImageURL = url;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Image uploaded"),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            e.toString().split(': ').last,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                          icon: const Icon(Icons.image_outlined),
                          iconSize: 30,
                          color: Colors.black,
                          tooltip: "Upload Image",
                        ),
                      ],
                    ),
                    if (_uploadedImageURL != null) ...[
                      const SizedBox(height: 10),
                      Image.network(
                        _uploadedImageURL!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ],
                    const SizedBox(height: 15),
                    TextField(
                      controller: _descController,
                      decoration: InputDecoration(
                        labelText: "Item Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Availability Date",
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _availabilityDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _availabilityDate = pickedDate;
                            _dateController.text =
                                "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed:
                            state is UploadItemLoading
                                ? null
                                : () {
                                  if (_availabilityDate == null ||
                                      _nameController.text.isEmpty ||
                                      _descController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please fill all fields'),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<UploadItemCubit>().uploadItem(
                                    name: _nameController.text.trim(),
                                    description: _descController.text.trim(),
                                    availabilityDate: _availabilityDate!,
                                    pictureURL:
                                        _uploadedImageURL ??
                                        '', // ✅ تمرير الصورة إن وجدت
                                  );
                                },
                        child:
                            state is UploadItemLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Upload Item",
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
