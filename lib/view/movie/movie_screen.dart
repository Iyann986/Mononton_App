import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mononton_app/models/users/users.dart';
import 'package:mononton_app/view/drawer_screen.dart';
import 'package:mononton_app/view/movie/movie_category.dart';
import 'package:mononton_app/view/movie/movie_detail.dart';
import 'package:mononton_app/view/movie/movie_view_model.dart';
import 'package:mononton_app/view/movie/person_view_model.dart';
import 'package:mononton_app/view/search/search.dart';
import 'package:provider/provider.dart';

import '../../models/movie_model.dart';
import '../../models/person.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});
  static const String route = "/movie_screen";

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = Users.fromMap(value.data()!);
      setState(() {});
    });
    Provider.of<MovieViewModel>(context, listen: false).getCurrentPlayMovies(0);
    Provider.of<PersonViewModel>(context, listen: false).getTrendingPerson();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieViewModel>(context);
    final personProvider = Provider.of<PersonViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffC1232F),
        title: const Text('Movie Screen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(user: loggedInUser),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      // ignore: unnecessary_null_comparison
      drawer: loggedInUser == null
          ? const CircularProgressIndicator()
          : DrawerScreen(
              user: loggedInUser,
            ),
      body: movieProvider.movies.isEmpty
          ? const CircularProgressIndicator()
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider.builder(
                          itemCount: movieProvider.movies.length,
                          itemBuilder: (BuildContext context, int index,
                              int pageViewIndex) {
                            Movie movie = movieProvider.movies[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) {
                                      return MovieDetailScreen(
                                          movie: movie, user: loggedInUser);
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
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 15,
                                      left: 15,
                                    ),
                                    child: Text(
                                      movieProvider.movies[index].title!
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          options: CarouselOptions(
                            // height: 250.0,
                            aspectRatio: 16 / 9,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            pauseAutoPlayOnTouch: true,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              const SizedBox(height: 12),
                              CategoryMovie(
                                user: loggedInUser,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Trending persons on this week'.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 130,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        Person persons =
                                            personProvider.persons[index];
                                        return SizedBox(
                                          child: Column(
                                            children: [
                                              Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                elevation: 3,
                                                child:
                                                    persons.profilePath ==
                                                            'null'
                                                        ? const Image(
                                                            image: AssetImage(
                                                                'assets/images/ic_avatar.png'),
                                                            height: 80,
                                                            width: 80,
                                                          )
                                                        : ClipRRect(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  'https://image.tmdb.org/t/p/w500${persons.profilePath}',
                                                              imageBuilder:
                                                                  (context,
                                                                      imageProvider) {
                                                                return Container(
                                                                  width: 70.0,
                                                                  height: 70.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          imageProvider,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                              ),
                                              SizedBox(
                                                child: Center(
                                                  child: Text(persons.name!
                                                      .toUpperCase()),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Center(
                                                  child: Text(persons
                                                      .knowForDepartment!
                                                      .toUpperCase()),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const VerticalDivider(),
                                      itemCount: personProvider.persons.length,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
