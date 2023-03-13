// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:birthday_scheduler/core/constants/firebase_constants.dart';
import 'package:birthday_scheduler/core/failure.dart';
import 'package:birthday_scheduler/core/providers/firebase_providers.dart';
import 'package:birthday_scheduler/core/type_defs.dart';
import 'package:birthday_scheduler/models/birthday_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final birthdayRepositoryProvider = Provider((ref) {
  return BirthdayRepository(firestore: ref.watch(firestoreProvider));
});

class BirthdayRepository {
  final FirebaseFirestore _firestore;
  BirthdayRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid scheduleBirthday(Birthday birthday) async {
    try {
      return right(_birthdays.doc(birthday.id).set(birthday.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Birthday>> getScheduledBirthdaysOnDate(String date) {
    return _birthdays.where('date', isEqualTo: date).snapshots().map((event) {
      List<Birthday> birthdays = [];
      for (var doc in event.docs) {
        birthdays.add(Birthday.fromMap(doc.data() as Map<String, dynamic>));
      }
      return birthdays;
    });
  }

  // golden boy

  //FutureEither<UserModel> signInWithGoogle() async {..
  FutureEither<Birthday> getBirthdayById(String id) async {
    try {
      Birthday birthday = await getBirthdayData(id).first;
      return right(birthday);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Stream<UserModel> getUserData(String uid) {
  //   return _users.doc(uid).snapshots().map(
  //       (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  // }
  Stream<Birthday> getBirthdayData(String id) {
    return _birthdays
        .doc(id)
        .snapshots()
        .map((event) => Birthday.fromMap(event.data() as Map<String, dynamic>));
  }

  CollectionReference get _birthdays =>
      _firestore.collection(FirebaseConstants.birthdaysCollection);
}
