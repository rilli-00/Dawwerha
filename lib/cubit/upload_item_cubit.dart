import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UploadItemCubit extends Cubit<UploadItemState> {
  UploadItemCubit() : super(UploadItemInitial());

  Future<void> uploadItem({
    required String name,
    required String description,
    required DateTime availabilityDate,
    String? pictureURL,
  }) async {
    emit(UploadItemLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(const UploadItemError("المستخدم غير مسجّل دخول"));
        return;
      }
      await FirebaseFirestore.instance.collection('items').add({
        'name': name,
        'description': description,
        'availabilityDate': availabilityDate.toIso8601String(),
        'pictureURL': pictureURL ?? '',
        'ownerID': uid,
        'availability': true,
        'CreateAt': FieldValue.serverTimestamp(),
      });
      emit(UploadItemSuccess());
    } catch (e) {
      emit(UploadItemError("فشل رفع العنصر: $e"));
    }
  }

  Future<String?> pickAndUploadImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) throw Exception("لم يتم اختيار صورة");

      final fileName = path.basename(pickedFile.name);
      final ref = FirebaseStorage.instance.ref().child('items/$fileName');

      UploadTask uploadTask;

      if (kIsWeb) {
        final fileBytes = await pickedFile.readAsBytes();

        final extension = path.extension(pickedFile.name).toLowerCase();
        final contentType = extension == '.png' ? 'image/png' : 'image/jpeg';

        uploadTask = ref.putData(
          fileBytes,
          SettableMetadata(contentType: contentType),
        );
      } else {
        final file = io.File(pickedFile.path);
        uploadTask = ref.putFile(file);
      }

      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      print("✅ Uploaded image URL: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Image upload failed: $e");
      throw Exception("Image upload failed: $e");
    }
  }
}

// ---------- STATES ----------
abstract class UploadItemState extends Equatable {
  const UploadItemState();

  @override
  List<Object?> get props => [];
}

class UploadItemInitial extends UploadItemState {}

class UploadItemLoading extends UploadItemState {}

class UploadItemSuccess extends UploadItemState {}

class UploadItemError extends UploadItemState {
  final String message;
  const UploadItemError(this.message);

  @override
  List<Object?> get props => [message];
}
