import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:mononton_app/models/users/users.dart';
import 'package:provider/provider.dart';

import '../movie/movie_detail.dart';
import 'search_view_model.dart';

class SearchScreen extends StatefulWidget {
  final Users user;
  const SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final seacrhController = TextEditingController();

  @override
  void dispose() {
    seacrhController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<SearchViewModel>(context, listen: false).movies.clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movie'),
        centerTitle: true,
        backgroundColor: const Color(0xffC1232F),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Form(
                  child: TextFormField(
                    controller: seacrhController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: const Color(0xffC1232F),
                      hintText: 'Search Movie ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    textInputAction: TextInputAction.go,
                    onChanged: (value) {
                      searchProvider.movies.clear();
                      searchProvider.getMovies(seacrhController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: body(searchProvider))
        ],
      ),
    );
  }

  Widget body(SearchViewModel viewModel) {
    final isLoading = viewModel.state == SearchViewState.loading;
    final isError = viewModel.state == SearchViewState.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return const Center(
        child: Text("Can't get the data"),
      );
    }

    return _searchWidget(viewModel);
  }

  Widget _searchWidget(SearchViewModel viewModel) {
    return viewModel.movies.isEmpty
        ? const Center(
            child: Text('Tidak ada data'),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              final movie = viewModel.movies[index];
              return ListTile(
                leading: movie.backdropPath == null
                    ? Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/ic_noImage.png'))),
                      )
                    : ClipPath(
                        child: ClipRRect(
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                          ),
                        ),
                      ),
                title: Text(movie.title!),
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return MovieDetailScreen(
                            movie: movie, user: widget.user);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        final tween =
                            Tween(begin: const Offset(0, 5), end: Offset.zero);
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              );
            },
            itemCount: viewModel.movies.length);
  }
}
