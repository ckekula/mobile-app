import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/search/presentation/components/user_tile.dart';
import 'package:mobile_app/features/search/presentation/cubits/search_cubits.dart';
import 'package:mobile_app/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchVendors(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(
      //APP BAR
      appBar: AppBar(
        // Search text field
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ),

      // search results
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no users
            if (state.vendors.isEmpty) {
              return const Center(
                child: Text("No results found"),
              );
            }

            // list of vendors
            return ListView.builder(
              itemCount: state.vendors.length,
              itemBuilder: (context, index) {
                final vendor = state.vendors[index];
                return UserTile(vendor: vendor);
              },
            );
          }

          // loading
          if (state is SearchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // error
          if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          }

          // default
          return const Center(
            child: Text("search for vendors"),
          );
        },
      ),
    );
  }
}
