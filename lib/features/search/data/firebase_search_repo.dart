import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';
import 'package:mobile_app/features/search/domain/search_repo.dart';

class FirebaseSearchRepo implements SearchRepo {
  @override
  Future<List<VendorProfile>> searchVendors(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection("vendors")
          .where("name", isGreaterThanOrEqualTo: query)
          .where("name", isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => VendorProfile.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error searching users: $e");
    }
  }
}
