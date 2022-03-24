import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/stuff_widgets/searched_movie_detail.dart';
import '../../models/user.dart';
import '../input_decoration.dart';
import '../../models/movies.dart';

class MovieSearchPage extends StatefulWidget {
  @override
  State<MovieSearchPage> createState() => _MovieSearchPageState();
}

class _MovieSearchPageState extends State<MovieSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Movie> listOfMovies = [];
  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var authUser = Provider.of<User?>(context);
    var username = authUser!.email.toString().split('@')[0];
    return Container(
        child: Column(children: [
      Container(child: Text('Movie Search')),
      Container(
          child: Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                            child: TextField(
                                onSubmitted: (value) {
                                  _search();
                                },
                                controller: _searchTextController,
                                decoration: inputDecoration(
                                    label: 'Search',
                                    hintText: 'flutter development'))),
                      ),
                    ),
                    SizedBox(height: 12),
                    (listOfMovies != null && listOfMovies.isNotEmpty)
                        ? Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: createMovieCards(
                                            listOfMovies, context),
                                      ))),
                            ],
                          )
                        : Center(child: Text('')),
                    Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(username)
                                .collection('usermovies')
                                .snapshots(),
                            builder: (context, snapshot) {
                              print(username);
                              if (!snapshot.hasData)
                                return const Text("Loading...");
                              else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                final movieListStream =
                                    snapshot.data!.docs.map((movie) {
                                  return Movies.fromDocument(movie);
                                }).toList();

                                return Expanded(
                                    flex: 1,
                                    child: (movieListStream.length > 0)
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              height: 300,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    movieListStream.length,
                                                itemBuilder: (context, index) {
                                                  Movies movie =
                                                      movieListStream[index];
                                                  return InkWell(
                                                      child: Container(
                                                    width: 100,
                                                    height: 180,
                                                    child: Column(children: [
                                                      Image.network(
                                                          movie.photoUrl
                                                              as String,
                                                          width: 70,
                                                          height: 140),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          movie.movieTitle
                                                              as String,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ]),
                                                  ));
                                                },
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text("No Books Added!")));
                              }
                            }))
                  ]))))
    ]));
  }

  void _search() async {
    await fetchMovies(_searchTextController.text).then((value) {
      setState(() {
        listOfMovies = value;
      });
    }, onError: (val) {
      throw Exception('Failed to load movies ${val.toString()}');
    });
  }

  Future<List<Movie>> fetchMovies(String query) async {
    List<Movie> movies = [];
    http.Response response = await http
        .get(Uri.parse('https://www.omdbapi.com/?s={$query}&apikey=5772cbf5'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      print(body);
      final Iterable list = body['Search'];
      for (var item in list) {
        String title = item['Title'] == null ? 'N/A' : item['Title'];
        String type = item['Type'] == null ? "N/A" : item['Type'];
        String year = item['Year'] == null ? 'N/A' : item['Year'];
        String thumbNail = item['Poster'] == null
            ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
            : item['Poster'];
        Movie searchedMovie = new Movie(
          title: title,
          type: type,
          photoUrl: thumbNail,
          year: year,
        );

        movies.add(searchedMovie);
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }
    return movies;
  }

  List<Widget> createMovieCards(List<Movie> movies, BuildContext context) {
    List<Widget> children = [];
    final _movieCollectionReference =
        FirebaseFirestore.instance.collection('movies');
    for (var movie in movies) {
      children.add(
        Container(
          width: 160,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Card(
            elevation: 5,
            color: HexColor('#f6f4ff'),
            child: Wrap(
              children: [
                Image.network(
                    (movie.photoUrl == null ||
                            movie.photoUrl!.isEmpty ||
                            movie.photoUrl == 'N/A')
                        ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                        : movie.photoUrl as String,
                    height: 100,
                    width: 160),
                ListTile(
                  title: Text(movie.title,
                      style: TextStyle(color: HexColor('#5d48b6')),
                      overflow: TextOverflow.ellipsis),
                  subtitle: Text(movie.year as String,
                      overflow: TextOverflow.ellipsis),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SearchedMovieDetailDialog(
                              movie: movie,
                              movieCollectionReference:
                                  _movieCollectionReference);
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }
    return children;
  }
}
