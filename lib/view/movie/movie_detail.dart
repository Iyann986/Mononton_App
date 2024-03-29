import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mononton_app/view/movie/movie_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/cast_list.dart';
import '../../models/images.dart';
import '../../models/movie_model.dart';
import '../../models/users/users.dart';
import 'detail_view_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Users user;
  final Movie movie;
  const MovieDetailScreen({super.key, required this.user, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool readMore = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<DetailViewModel>(context, listen: false)
          .getMovieDetail(widget.movie.id!);
    });
  }

  bool getButton(int id, List movie) {
    bool found = false;
    for (int i = 0; i < movie.length; i++) {
      if (movie[i] == id) {
        found = true;
      }
    }
    return found;
  }

  @override
  Widget build(BuildContext context) {
    final detailProvider = Provider.of<DetailViewModel>(context);

    return Scaffold(
      body: body(detailProvider),
    );
  }

  Widget body(DetailViewModel viewModel) {
    final isLoading = viewModel.state == DetailViewState.loading;
    final isError = viewModel.state == DetailViewState.error;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return const Center(
        child: Text("Can't get the data"),
      );
    }

    return _detailMovie(viewModel);
  }

  Widget _detailMovie(DetailViewModel viewModel) {
    return viewModel.movieDetail == null
        ? const Center(child: CircularProgressIndicator())
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        _imageMovie(viewModel),
                        _trailerMovie(viewModel),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: Text(
                        viewModel.movieDetail!.title!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                      child: Text(
                        'Overview',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Text(
                        viewModel.movieDetail!.overview!,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.justify,
                        maxLines: readMore ? 20 : 3,
                        overflow: readMore
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              readMore = !readMore;
                            });
                          },
                          child: Text(
                            readMore ? 'read less' : 'read more',
                            style: const TextStyle(color: Color(0xffC1232F)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Release date'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                Text(
                                  viewModel.movieDetail!.releaseDate!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: const Color(0xffC1232F),
                                          fontSize: 12),
                                ),
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'run time'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                Text(
                                  viewModel.movieDetail!.runtime!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: const Color(0xffC1232F),
                                          fontSize: 12),
                                ),
                              ]),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'budget'.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                ),
                                Text(
                                  viewModel.movieDetail!.budget!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: const Color(0xffC1232F),
                                          fontSize: 12),
                                ),
                              ]),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Text(
                        'Screenshots',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    _listImages(viewModel),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                      child: Text(
                        'Cast',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                      child: SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Cast cast = viewModel.movieDetail!.castList![index];
                            return SizedBox(
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    elevation: 3,
                                    child: cast.profilePath == null
                                        ? const Image(
                                            image: AssetImage(
                                                'assets/images/ic_avatar.png'),
                                            height: 80,
                                            width: 80,
                                          )
                                        : ClipRRect(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                              imageBuilder:
                                                  (context, imageBuilder) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  100)),
                                                      image: DecorationImage(
                                                        image: imageBuilder,
                                                        fit: BoxFit.cover,
                                                      )),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  const SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    child: Center(
                                      child: Text(
                                        cast.name!.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      cast.character!.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const VerticalDivider(
                            color: Colors.transparent,
                            width: 5,
                          ),
                          itemCount: viewModel.movieDetail!.castList!.length,
                        ),
                      ),
                    ),
                    Center(
                      child: getButton(int.parse(viewModel.movieDetail!.id!),
                              widget.user.movieWatch!)
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffC1232F),
                                    ),
                                  ),
                                  child: const Text(
                                    'Added To Watch List',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : getButton(int.parse(viewModel.movieDetail!.id!),
                                  widget.user.movieDropped!)
                              ? ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffC1232F),
                                    ),
                                  ),
                                  child: const Text(
                                    'This movie is dropped',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : getButton(int.parse(viewModel.movieDetail!.id!),
                                      widget.user.movieFinish!)
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xffC1232F),
                                        ),
                                      ),
                                      child: const Text(
                                        'You finish watching this movie',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        List movie = [];
                                        movie.add(int.parse(
                                            viewModel.movieDetail!.id!));
                                        final docUser = FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(widget.user.id);
                                        docUser.update({
                                          "movieWatch":
                                              FieldValue.arrayUnion(movie)
                                        });
                                        Navigator.pushAndRemoveUntil(
                                            (context),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MovieScreen()),
                                            (route) => false);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color(0xffC1232F),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add to Watchlist',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                    )
                  ],
                ),
              ),
            );
          });
  }

  Widget _imageMovie(DetailViewModel viewModel) {
    return viewModel.movieDetail!.backdropPath == null
        ? Container(
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/noImage.jpeg'),
                    fit: BoxFit.cover)),
          )
        : ClipPath(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/original/${viewModel.movieDetail!.backdropPath}',
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            ),
          );
  }

  Widget _trailerMovie(DetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        onTap: () async {
          Uri youtubeUrl = Uri.parse(
              'https://www.youtube.com/embed/${viewModel.movieDetail!.trailerId}');
          await launchUrl(youtubeUrl);
        },
        child: Center(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              const Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 65,
              ),
              Text(
                'play trailer'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listImages(DetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: SizedBox(
        height: 130,
        child: viewModel.movieDetail!.backdropPath == null
            ? const Image(
                image: AssetImage('assets/images/noImage.png'),
                height: 100,
                width: 100,
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Images image =
                      viewModel.movieDetail!.movieImage.backdrops![index];
                  return Column(
                    children: [
                      ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w200${image.imagePath}',
                          imageBuilder: (context, imageBuilder) {
                            return Container(
                              width: 230,
                              height: 130,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageBuilder,
                                    fit: BoxFit.cover,
                                  )),
                            );
                          },
                          placeholder: (context, url) => const SizedBox(
                            width: 100,
                            height: 100,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: viewModel.movieDetail!.movieImage.backdrops!.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const VerticalDivider(
                  color: Colors.transparent,
                  width: 12,
                ),
              ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buttonWatchList(DetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: ElevatedButton(
          onPressed: () {
            List movie = [];
            movie.add(int.parse(viewModel.movieDetail!.id!));
            final docUser = FirebaseFirestore.instance
                .collection('users')
                .doc(widget.user.id);
            docUser.update({"movieWatch": FieldValue.arrayUnion(movie)});
            Navigator.pushAndRemoveUntil(
                (context),
                MaterialPageRoute(builder: (context) => const MovieScreen()),
                (route) => false);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xffC1232F)),
          ),
          child: const Text(
            'Add to Watchlist',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
