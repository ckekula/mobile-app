import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/features/auth/domain/entities/app_vendor.dart';
import 'package:mobile_app/features/auth/domain/repos/auth_repo.dart';

class FirebaseVendorAuthRepo implements AuthRepo<AppVendor> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<AppVendor?> getCurrentUser() async {
    // get logged in vendor from firebase
    final firebaseVendor = firebaseAuth.currentUser;

    // no vendor is logged in
    if (firebaseVendor == null) {
      return null;
    }

    // vendor exists
    return AppVendor(
      uid: firebaseVendor.uid,
      email: firebaseVendor.email!,
      name: '',
    );
  }

  @override
  Future<AppVendor?> loginWithEmailPassword(
      String email, String password) async {
    try {
      // attempt sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // create Vendor
      AppVendor vendor =
          AppVendor(uid: userCredential.user!.uid, email: email, name: '');

      // save vendor data in firestore
      await firebaseFirestore
          .collection("vendors")
          .doc(vendor.uid)
          .set(vendor.toJson());

      return vendor;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppVendor?> registerWithEmailPassword(
      String name, String email, String password) async {
    try {
      // attempt sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create Vendor
      AppVendor vendor =
          AppVendor(uid: userCredential.user!.uid, email: email, name: name);

      return vendor;
    } catch (e) {
      throw Exception('Login Failed: $e');
    }
  }
}
