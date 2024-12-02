import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> getCurrentUser() async {
    // get logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;

    // no user is logged in
    if (firebaseUser == null) {
      return null;
    }

    // user exists
    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: '',
    );
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      // attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // create User
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: '');

      // save user data in firestore
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create User
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      // save user data in firestore
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } catch (e) {
      throw Exception('Register Failed: $e');
    }
  }

  @override
  Future<AppVendor?> getCurrentVendor() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    // Retrieve vendor data
    final docSnapshot = await firebaseFirestore
        .collection("vendors")
        .doc(firebaseUser.uid)
        .get();

    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data()!;
    return AppVendor(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
    );
  }

  @override
  Future<AppVendor?> loginVendorWithEmailPassword(
      String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final vendor = AppVendor(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
      );

      await firebaseFirestore
          .collection("vendors")
          .doc(vendor.uid)
          .set(vendor.toJson());

      return vendor;
    } catch (e) {
      throw Exception('Vendor Login Failed: $e');
    }
  }

  @override
  Future<AppVendor?> registerVendorWithEmailPassword(
      String name, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final vendor = AppVendor(
        uid: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await firebaseFirestore
          .collection("vendors")
          .doc(vendor.uid)
          .set(vendor.toJson());

      return vendor;
    } catch (e) {
      throw Exception('Vendor Registration Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
