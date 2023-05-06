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
    // Provider.of<DetailViewModel>(context, listen: false)
    //     .getMovieDetail(widget.movie.id!);
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

  // Widget _detailMovie(DetailViewModel viewModel) {
  //   return Stack(
  //     children: [
  //       viewModel.movieDetail!.backdropPath! == 'null'
  //           ? Container(
  //               height: MediaQuery.of(context).size.height / 3,
  //               width: double.infinity,
  //               decoration: const BoxDecoration(
  //                   image: DecorationImage(
  //                       image: AssetImage('assets/images/noImage.png'),
  //                       fit: BoxFit.cover)),
  //             )
  //           : ClipPath(
  //               child: ClipRRect(
  //                 child: CachedNetworkImage(
  //                   imageUrl:
  //                       'https://image.tmdb.org/t/p/original/${viewModel.movieDetail!.backdropPath}',
  //                   height: MediaQuery.of(context).size.height / 3,
  //                   width: double.infinity,
  //                   fit: BoxFit.cover,
  //                   placeholder: (context, url) => CircularProgressIndicator(),
  //                 ),
  //                 borderRadius: const BorderRadius.only(
  //                   bottomLeft: Radius.circular(30),
  //                   bottomRight: Radius.circular(30),
  //                 ),
  //               ),
  //             ),
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           AppBar(
  //             backgroundColor: Colors.transparent,
  //             elevation: 0,
  //           ),
  //           Container(
  //             padding: EdgeInsets.only(top: 25),
  //             child: GestureDetector(
  //               onTap: () async {
  //                 Uri youtubeUrl = Uri.parse(
  //                     'https://www.youtube.com/embed/${viewModel.movieDetail!.trailerId}');
  //                 await launchUrl(youtubeUrl);
  //               },
  //               child: Center(
  //                 child: Column(
  //                   children: [
  //                     const Icon(
  //                       Icons.play_circle_outline,
  //                       color: Colors.white,
  //                       size: 65,
  //                     ),
  //                     Text(
  //                       viewModel.movieDetail!.title!.toUpperCase(),
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //           SizedBox(
  //             height: 60,
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'Overview'.toUpperCase(),
  //                           style: Theme.of(context)
  //                               .textTheme
  //                               .bodySmall!
  //                               .copyWith(fontWeight: FontWeight.bold),
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ]),
  //                 ),
  //                 SizedBox(
  //                   height: 5,
  //                 ),
  //                 Container(
  //                   height: 60,
  //                   child: Text(
  //                     viewModel.movieDetail!.overview!,
  //                     maxLines: 3,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Release date'.toUpperCase(),
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodySmall!
  //                                 .copyWith(fontWeight: FontWeight.bold),
  //                           ),
  //                           Text(
  //                             viewModel.movieDetail!.releaseDate!,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .titleSmall!
  //                                 .copyWith(
  //                                     color: Color(0xffC1232F), fontSize: 12),
  //                           ),
  //                         ]),
  //                     Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'run time'.toUpperCase(),
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodySmall!
  //                                 .copyWith(fontWeight: FontWeight.bold),
  //                           ),
  //                           Text(
  //                             viewModel.movieDetail!.runtime!,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .titleSmall!
  //                                 .copyWith(
  //                                     color: Color(0xffC1232F), fontSize: 12),
  //                           ),
  //                         ]),
  //                     Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'budget'.toUpperCase(),
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .bodySmall!
  //                                 .copyWith(fontWeight: FontWeight.bold),
  //                           ),
  //                           Text(
  //                             viewModel.movieDetail!.budget!,
  //                             style: Theme.of(context)
  //                                 .textTheme
  //                                 .titleSmall!
  //                                 .copyWith(
  //                                     color: Color(0xffC1232F), fontSize: 12),
  //                           ),
  //                         ]),
  //                   ],
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text(
  //                   'Screenshots'.toUpperCase(),
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .bodySmall!
  //                       .copyWith(fontWeight: FontWeight.bold),
  //                 ),
  //                 Container(
  //                   height: 150,
  //                   child: viewModel.movieDetail!.backdropPath == 'null'
  //                       ? Container(
  //                           height: MediaQuery.of(context).size.height / 3,
  //                           width: double.infinity,
  //                           decoration: const BoxDecoration(
  //                               image: DecorationImage(
  //                                   image:
  //                                       AssetImage('assets/images/noImage.png'),
  //                                   fit: BoxFit.cover)),
  //                         )
  //                       : ListView.separated(
  //                           scrollDirection: Axis.horizontal,
  //                           itemBuilder: (context, index) {
  //                             Images image = viewModel
  //                                 .movieDetail!.movieImage.backdrops![index];
  //                             return Container(
  //                               child: Card(
  //                                 elevation: 3,
  //                                 borderOnForeground: true,
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 child: ClipRRect(
  //                                   borderRadius: BorderRadius.circular(8),
  //                                   child: CachedNetworkImage(
  //                                     imageUrl:
  //                                         'https://image.tmdb.org/t/p/w500${image.imagePath}',
  //                                     fit: BoxFit.cover,
  //                                     placeholder: (context, url) => Center(
  //                                       child: CircularProgressIndicator(),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                           separatorBuilder: (context, index) =>
  //                               const VerticalDivider(
  //                             color: Colors.transparent,
  //                             width: 5,
  //                           ),
  //                           itemCount: viewModel
  //                               .movieDetail!.movieImage.backdrops!.length,
  //                         ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Text(
  //                   'Casts'.toUpperCase(),
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .bodySmall!
  //                       .copyWith(fontWeight: FontWeight.bold),
  //                 ),
  //                 Container(
  //                   height: 120,
  //                   child: ListView.separated(
  //                     scrollDirection: Axis.horizontal,
  //                     itemBuilder: (context, index) {
  //                       Cast cast = viewModel.movieDetail!.castList![index];
  //                       return Container(
  //                         child: Column(
  //                           children: [
  //                             Card(
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(100),
  //                               ),
  //                               elevation: 3,
  //                               child: cast.profilePath == null
  //                                   ? const Image(
  //                                       image: AssetImage(
  //                                           'assets/images/ic_avatar.png'),
  //                                       height: 80,
  //                                       width: 80,
  //                                     )
  //                                   : ClipRRect(
  //                                       child: CachedNetworkImage(
  //                                         imageUrl:
  //                                             'https://image.tmdb.org/t/p/w200${cast.profilePath}',
  //                                         imageBuilder:
  //                                             (context, imageBuilder) {
  //                                           return Container(
  //                                             width: 80,
  //                                             height: 80,
  //                                             decoration: BoxDecoration(
  //                                                 borderRadius:
  //                                                     BorderRadius.all(
  //                                                         Radius.circular(100)),
  //                                                 image: DecorationImage(
  //                                                   image: imageBuilder,
  //                                                   fit: BoxFit.cover,
  //                                                 )),
  //                                           );
  //                                         },
  //                                         placeholder: (context, url) =>
  //                                             Container(
  //                                           width: 80,
  //                                           height: 80,
  //                                           child: Center(
  //                                             child:
  //                                                 CircularProgressIndicator(),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     ),
  //                             ),
  //                             Container(
  //                               child: Center(
  //                                 child: Text(
  //                                   cast.name!.toUpperCase(),
  //                                   style: const TextStyle(
  //                                     color: Colors.black54,
  //                                     fontSize: 12,
  //                                   ),
  //                                   maxLines: 1,
  //                                 ),
  //                               ),
  //                             ),
  //                             Container(
  //                               child: Text(
  //                                 cast.character!.toUpperCase(),
  //                                 style: const TextStyle(
  //                                   color: Colors.black54,
  //                                   fontSize: 12,
  //                                 ),
  //                                 maxLines: 1,
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                     separatorBuilder: (context, index) =>
  //                         const VerticalDivider(
  //                       color: Colors.transparent,
  //                       width: 5,
  //                     ),
  //                     itemCount: viewModel.movieDetail!.castList!.length,
  //                   ),
  //                 ),
  //                 SizedBox(height: 10),
  //                 Center(
  //                   child: getButton(int.parse(viewModel.movieDetail!.id!),
  //                           widget.user.movieWatch!)
  //                       ? ElevatedButton(
  //                           onPressed: () {},
  //                           child: const Text(
  //                             'Added To Watch List',
  //                             style: TextStyle(color: Colors.black45),
  //                           ),
  //                           style: ButtonStyle(
  //                             backgroundColor: MaterialStateProperty.all(
  //                               Color(0xffC1232F),
  //                             ),
  //                           ),
  //                         )
  //                       : getButton(int.parse(viewModel.movieDetail!.id!),
  //                               widget.user.movieDropped!)
  //                           ? ElevatedButton(
  //                               onPressed: () {},
  //                               child: const Text(
  //                                 'This movie is dropped',
  //                                 style: TextStyle(color: Colors.black45),
  //                               ),
  //                               style: ButtonStyle(
  //                                 backgroundColor: MaterialStateProperty.all(
  //                                   Color(0xffC1232F),
  //                                 ),
  //                               ),
  //                             )
  //                           : getButton(int.parse(viewModel.movieDetail!.id!),
  //                                   widget.user.movieFinish!)
  //                               ? ElevatedButton(
  //                                   onPressed: () {},
  //                                   child: const Text(
  //                                     'You finish watching this movie',
  //                                     style: TextStyle(color: Colors.black45),
  //                                   ),
  //                                   style: ButtonStyle(
  //                                     backgroundColor:
  //                                         MaterialStateProperty.all(
  //                                       Color(0xffC1232F),
  //                                     ),
  //                                   ),
  //                                 )
  //                               : ElevatedButton(
  //                                   onPressed: () {
  //                                     List movie = [];
  //                                     movie.add(int.parse(
  //                                         viewModel.movieDetail!.id!));
  //                                     final docUser = FirebaseFirestore.instance
  //                                         .collection('users')
  //                                         .doc(widget.user.id);
  //                                     docUser.update({
  //                                       "movieWatch":
  //                                           FieldValue.arrayUnion(movie)
  //                                     });
  //                                     Navigator.pushAndRemoveUntil(
  //                                         (context),
  //                                         MaterialPageRoute(
  //                                             builder: (context) =>
  //                                                 MovieScreen()),
  //                                         (route) => false);
  //                                   },
  //                                   child: const Text(
  //                                     'Add to Watchlist',
  //                                     style: TextStyle(
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                   style: ButtonStyle(
  //                                     backgroundColor:
  //                                         MaterialStateProperty.all(
  //                                       Color(0xffC1232F),
  //                                     ),
  //                                   ),
  //                                 ),
  //                 )
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

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
                                          color: Color(0xffC1232F),
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
                                          color: Color(0xffC1232F),
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
                                          color: Color(0xffC1232F),
                                          fontSize: 12),
                                ),
                              ]),
                        ],
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(20, 0, 0, 8),
                    //   child: Text(
                    //     'Genre',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black),
                    //   ),
                    // ),
                    // _listGenre(viewModel),
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    //   child: Text(
                    //     'Cast',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black),
                    //   ),
                    // ),
                    // _listActors(viewModel),
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
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    //   child: Text(
                    //     'Similar Movies',
                    //     style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black),
                    //   ),
                    // ),
                    // _listMovies(viewModel.movieDetail!.similarMovies),
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
                      child: Container(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Cast cast = viewModel.movieDetail!.castList![index];
                            return Container(
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
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      image: DecorationImage(
                                                        image: imageBuilder,
                                                        fit: BoxFit.cover,
                                                      )),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  Container(
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
                                  Container(
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
                                  Container(
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
                    // _listMovies(viewModel.movieDetail!.recomendationMovies),
                    // getButton(int.parse(viewModel.movieDetail!.id!),
                    //         widget.user.movieWatch!)
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(20),
                    //         child: Container(
                    //           height: 50,
                    //           width: double.infinity,
                    //           child: ElevatedButton(
                    //             onPressed: () {},
                    //             style: ButtonStyle(
                    //               backgroundColor: MaterialStateProperty.all(
                    //                 Color(0xffC1232F),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               'Add to Watchlist',
                    //               style: TextStyle(color: Colors.white),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : _buttonWatchList(viewModel),
                    Center(
                      child: getButton(int.parse(viewModel.movieDetail!.id!),
                              widget.user.movieWatch!)
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 50,
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Added To Watch List',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xffC1232F),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : getButton(int.parse(viewModel.movieDetail!.id!),
                                  widget.user.movieDropped!)
                              ? ElevatedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'This movie is dropped',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Color(0xffC1232F),
                                    ),
                                  ),
                                )
                              : getButton(int.parse(viewModel.movieDetail!.id!),
                                      widget.user.movieFinish!)
                                  ? ElevatedButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'You finish watching this movie',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Color(0xffC1232F),
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
                                                    MovieScreen()),
                                            (route) => false);
                                      },
                                      child: const Text(
                                        'Add to Watchlist',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Color(0xffC1232F),
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
              child: CachedNetworkImage(
                imageUrl:
                    'https://image.tmdb.org/t/p/original/${viewModel.movieDetail!.backdropPath}',
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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

  // Widget _listGenre(DetailViewModel viewModel) {
  //   return Container(
  //     padding: const EdgeInsets.only(left: 20),
  //     height: 45,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.white),
  //             borderRadius: const BorderRadius.all(Radius.circular(25)),
  //           ),
  //           child: Center(
  //               child: Text(
  //             viewModel.movieDetail!.genres![index].name,
  //             style: const TextStyle(color: Colors.white),
  //           )),
  //         );
  //       },
  //       separatorBuilder: (BuildContext context, int index) =>
  //           const VerticalDivider(
  //         color: Colors.transparent,
  //         width: 12,
  //       ),
  //       itemCount: viewModel.movieDetail!.genres!.length,
  //     ),
  //   );
  // }

  // Widget _listActors(DetailViewModel viewModel) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
  //     child: Container(
  //       height: 140,
  //       child: ListView.separated(
  //         scrollDirection: Axis.horizontal,
  //         itemBuilder: (BuildContext context, int index) {
  //           Cast cast = viewModel.movieDetail!.castList![index];
  //           return GestureDetector(
  //             onTap: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => CastDetailScreen(
  //                             id: cast.id!,
  //                             user: widget.user,
  //                           )));
  //             },
  //             child: Column(
  //               children: [
  //                 cast.profilePath == null
  //                     ? const Image(
  //                         image: AssetImage('assets/images/user.png'),
  //                         height: 100,
  //                         width: 100,
  //                       )
  //                     : ClipRRect(
  //                         child: CachedNetworkImage(
  //                           imageUrl:
  //                               'https://image.tmdb.org/t/p/w200${cast.profilePath}',
  //                           imageBuilder: (context, imageBuilder) {
  //                             return Container(
  //                               width: 100,
  //                               height: 100,
  //                               decoration: BoxDecoration(
  //                                   borderRadius: const BorderRadius.all(
  //                                       Radius.circular(12)),
  //                                   image: DecorationImage(
  //                                     image: imageBuilder,
  //                                     fit: BoxFit.cover,
  //                                   )),
  //                             );
  //                           },
  //                           placeholder: (context, url) => Container(
  //                             width: 100,
  //                             height: 100,
  //                             child: const Center(
  //                               child: CircularProgressIndicator(),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                 const SizedBox(
  //                   height: 12,
  //                 ),
  //                 Container(
  //                   width: 100,
  //                   child: Center(
  //                     child: Text(
  //                       cast.name!.toUpperCase(),
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 12,
  //                       ),
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //         itemCount: viewModel.movieDetail!.castList!.length,
  //         separatorBuilder: (BuildContext context, int index) =>
  //             const VerticalDivider(
  //           color: Colors.transparent,
  //           width: 12,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _listImages(DetailViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Container(
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
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            child: const Center(
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
                MaterialPageRoute(builder: (context) => MovieScreen()),
                (route) => false);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffC1232F)),
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

  // Widget _listMovies(List<Movie> movies) {
  //   return movies.isEmpty
  //       ? const Center(
  //           child: CircularProgressIndicator(),
  //         )
  //       : Padding(
  //           padding: const EdgeInsets.only(left: 20),
  //           child: Container(
  //             height: 200,
  //             child: ListView.separated(
  //                 scrollDirection: Axis.horizontal,
  //                 itemBuilder: (context, index) {
  //                   Movie movie = movies[index];
  //                   return Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => MovieDetailScreen(
  //                                 movie: movie,
  //                                 user: widget.user,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         child: movie.backdropPath == null
  //                             ? Container(
  //                                 height: 160,
  //                                 width: 200,
  //                                 decoration: const BoxDecoration(
  //                                     image: DecorationImage(
  //                                         image: AssetImage(
  //                                             'assets/images/noImage.png'),
  //                                         fit: BoxFit.contain)),
  //                               )
  //                             : ClipRRect(
  //                                 child: CachedNetworkImage(
  //                                   imageUrl:
  //                                       'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
  //                                   imageBuilder: (context, imageProvider) {
  //                                     return Container(
  //                                       width: 200,
  //                                       height: 160,
  //                                       decoration: BoxDecoration(
  //                                         borderRadius: const BorderRadius.all(
  //                                           Radius.circular(12),
  //                                         ),
  //                                         image: DecorationImage(
  //                                           image: imageProvider,
  //                                           fit: BoxFit.cover,
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                   placeholder: (context, url) => Container(
  //                                     width: 190,
  //                                     height: 150,
  //                                     child: const Center(
  //                                       child: CircularProgressIndicator(),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Container(
  //                         width: 200,
  //                         child: Text(
  //                           movie.title!.toUpperCase(),
  //                           style: const TextStyle(
  //                               fontSize: 12,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.bold),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Row(
  //                           children: [
  //                             const Icon(
  //                               Icons.star,
  //                               color: Colors.yellow,
  //                               size: 14,
  //                             ),
  //                             const Icon(
  //                               Icons.star,
  //                               color: Colors.yellow,
  //                               size: 14,
  //                             ),
  //                             const Icon(
  //                               Icons.star,
  //                               color: Colors.yellow,
  //                               size: 14,
  //                             ),
  //                             const Icon(
  //                               Icons.star,
  //                               color: Colors.yellow,
  //                               size: 14,
  //                             ),
  //                             const Icon(
  //                               Icons.star,
  //                               color: Colors.yellow,
  //                               size: 14,
  //                             ),
  //                             Text(movie.voteAverage!,
  //                                 style: const TextStyle(
  //                                   color: Colors.white,
  //                                 ))
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   );
  //                 },
  //                 separatorBuilder: (context, index) => const VerticalDivider(
  //                       color: Colors.transparent,
  //                       width: 15,
  //                     ),
  //                 itemCount: movies.length),
  //           ),
  //         );
  // }
}
