import 'package:birthday_scheduler/core/constants/constants.dart';
import 'package:birthday_scheduler/core/constants/firebase_constants.dart';
import 'package:birthday_scheduler/core/failure.dart';
import 'package:birthday_scheduler/core/providers/firebase_providers.dart';
import 'package:birthday_scheduler/core/type_defs.dart';
import 'package:birthday_scheduler/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

// Check if user is authorized
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.authorizedUsersCollection)
          .where('email', isEqualTo: googleUser?.email)
          .get();
      if (snapshot.docs.isEmpty) {
        await _googleSignIn.signOut();
        return left(
            Failure('You are not authorized to use this Activity app.'));
      }

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print(userCredential.user?.email);

      UserModel userModel;

      print(userCredential.additionalUserInfo!.isNewUser);
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "No Name",
          email: userCredential.user!.email!,
          description: "description...nessto",
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
