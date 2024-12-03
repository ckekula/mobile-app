import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/search/domain/search_repo.dart';
import 'package:mobile_app/features/search/presentation/cubits/search_cubits.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> SearchVendors(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final vendors = await searchRepo.searchVendors(query);
      emit(SearchLoaded(vendors));
    } catch (e) {
      emit(SearchError("Error fetching search results"));
    }
  }
}
