import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class UploadItemCubit extends Cubit<UploadItemState> {
  UploadItemCubit() : super(UploadItemInitial());

  /// Upload item to Firestore
  void uploadItem({
    required String name,
    required String description,
    required DateTime availabilityDate,
    String? pictureURL,
  }) async {
    emit(UploadItemLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        emit(const UploadItemError("User not logged in"));
        return;
      }

      await FirebaseFirestore.instance.collection('items').add({
        'name': name,
        'description': description,
        'availabilityDate': availabilityDate.toIso8601String(),
        'pictureURL': pictureURL, // يمكن أن تكون null
        'ownerID': uid,
        'availability': true,
        'CreateAt': FieldValue.serverTimestamp(),
      });

      emit(UploadItemSuccess());
    } catch (e) {
      emit(UploadItemError("Failed to upload item: $e"));
    }
  }

  /// Pick and upload image from gallery
  Future<String?> pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      final fileName = path.basename(pickedFile.path);
      final ref = FirebaseStorage.instance.ref().child('items/$fileName');

      await ref.putFile(File(pickedFile.path));
      final downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      emit(UploadItemError('Image upload failed: $e'));
      return null;
    }
  }
}

// ---------------- STATES ----------------

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
