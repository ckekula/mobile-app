import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';

abstract class SearchRepo {
  Future<List<VendorProfile>> searchVendors(String query);
}
