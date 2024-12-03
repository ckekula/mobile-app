import 'package:mobile_app/features/profile/domain/entities/vendor_profile.dart';

abstract class SearchState {}

// initial
class SearchInitial extends SearchState {}

// loading
class SearchLoading extends SearchState {}

// loaded
class SearchLoaded extends SearchState {
  final List<VendorProfile> vendors;

  SearchLoaded(this.vendors);
}

// Error
class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
