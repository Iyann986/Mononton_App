import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/models/users/users.dart';
import 'package:mononton_app/view/movie/category_view_model.dart';
import 'package:mononton_app/view/movie/movie_detail.dart';
import 'package:mononton_app/view/movie/movie_view_model.dart';
import 'package:provider/provider.dart';

import '../../models/genre.dart';
import '../../models/movie_model.dart';

class CategoryMovie extends StatefulWidget {
  final Users user;
  final int selectedGenre;
  const CategoryMovie({super.key, required this.user, this.selectedGenre = 28});

  @override
  State<CategoryMovie> createState() => _CategoryMovieState();
}

class _CategoryMovieState extends State<CategoryMovie> {
  int? selectedGenre;

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
    Provider.of<MovieViewModel>(context, listen: false)
        .getCurrentPlayMovies(selectedGenre!);
    Provider.of<CategoryViewModel>(context, listen: false).getGenreList();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieViewModel>(context);
    final categoryProvider = Provider.of<CategoryViewModel>(context);

    return movieProvider.movies.isEmpty
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Genre genre = categoryProvider.genres[index];
                              selectedGenre = genre.id;
                              movieProvider
                                  .getCurrentPlayMovies(selectedGenre!);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xffC1232F),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: (categoryProvider.genres[index].id ==
                                      selectedGenre)
                                  ? const Color(0xffC1232F)
                                  : const Color(0xFFFFFFFF),
                            ),
                            child: Text(
                              categoryProvider.genres[index].name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: (categoryProvider.genres[index].id ==
                                        selectedGenre)
                                    ? const Color(0xFFFFFFFF)
                                    : const Color(0xffC1232F),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const VerticalDivider(
                    color: Colors.transparent,
                    width: 5,
                  ),
                  itemCount: categoryProvider.genres.length,
                ),
              ),
              SizedBox(
                child: Text(
                  'New Playing'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Movie movie = movieProvider.movies[index];
                    // ignore: unnecessary_null_comparison
                    return movie == null
                        ? const CircularProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return MovieDetailScreen(
                                            movie: movie, user: widget.user);
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        final tween = Tween(
                                            begin: const Offset(0, 5),
                                            end: Offset.zero);
                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        width: 100,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      width: 100,
                                      height: 150,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 100,
                                child: Text(
                                  movie.title!.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14,
                                    ),
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 14,
                                    ),
                                    Text(
                                      movie.voteAverage!.toString().toString(),
                                      // movie.voteAverage!.toString(),
                                      style: const TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                  },
                  separatorBuilder: (context, index) => const VerticalDivider(
                    color: Colors.transparent,
                    width: 15,
                  ),
                  itemCount: movieProvider.movies.length,
                ),
              )
            ],
          );
  }
}
