import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  void loadUser() async {
    emit(AccountLoading());
    try {
      final doc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      final data = doc.data();

      if (data != null) {
        emit(
          AccountLoaded(
            name: data['name'] ?? '',
            phone: data['phone'] ?? '',
            email: data['email'] ?? '',
            requestCount: data['requestCount'] ?? 0,
            contributionsCount: data['contributionsCount'] ?? 0,
          ),
        );
      } else {
        emit(AccountError('No user data found'));
      }
    } catch (e) {
      print('🔥 Error in loadUser: $e');
      emit(AccountError('Failed to load user data: $e'));
    }
  }

  void updateUser({required String name, required String phone}) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'name': name,
        'phone': phone,
      }, SetOptions(merge: true));
      emit(AccountSuccess('Updated successfully'));
      loadUser();
    } catch (e) {
      print('🔥 Error in updateUser: $e');
      emit(AccountError('Failed to update user: $e'));
    }
  }
}

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final String name;
  final String phone;
  final String email;
  final int requestCount;
  final int contributionsCount;

  AccountLoaded({
    required this.name,
    required this.phone,
    required this.email,
    required this.requestCount,
    required this.contributionsCount,
  });
}

class AccountSuccess extends AccountState {
  final String message;
  AccountSuccess(this.message);
}

class AccountError extends AccountState {
  final String error;
  AccountError(this.error);
}
