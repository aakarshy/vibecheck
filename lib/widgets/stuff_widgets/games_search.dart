import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/stuff_widgets/searched_game_details.dart';
import '../../models/user.dart';
import '../input_decoration.dart';
import '../../models/games.dart';

class GamesSearchPage extends StatefulWidget {
  @override
  State<GamesSearchPage> createState() => _GamesSearchPageState();
}

class _GamesSearchPageState extends State<GamesSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Game> listOfGames = [];
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
      Container(child: Text('Games Search')),
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
                                    label: 'Search', hintText: 'Halo'))),
                      ),
                    ),
                    SizedBox(height: 12),
                    (listOfGames != null && listOfGames.isNotEmpty)
                        ? Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: createGameCards(
                                            listOfGames, context),
                                      ))),
                            ],
                          )
                        : Center(child: Text('')),
                    Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(username)
                                .collection('usergames')
                                .snapshots(),
                            builder: (context, snapshot) {
                              print(username);
                              if (!snapshot.hasData)
                                return const Text("Loading...");
                              else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                final gamesListStream =
                                    snapshot.data!.docs.map((game) {
                                  return Games.fromDocument(game);
                                }).toList();

                                return Expanded(
                                    flex: 1,
                                    child: (gamesListStream.length > 0)
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              height: 300,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    gamesListStream.length,
                                                itemBuilder: (context, index) {
                                                  Games game =
                                                      gamesListStream[index];
                                                  return InkWell(
                                                      child: Container(
                                                    width: 100,
                                                    height: 180,
                                                    child: Column(children: [
                                                      Image.network(
                                                          game.photoUrl
                                                              as String,
                                                          width: 70,
                                                          height: 140),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          game.gameTitle
                                                              as String,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   child: Text(game.summary
                                                      //       as String),
                                                      // )
                                                    ]),
                                                  ));
                                                },
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text("No Games Added!")));
                              }
                            }))
                  ]))))
    ]));
  }

  void _search() async {
    await fetchGames(_searchTextController.text).then((value) {
      setState(() {
        listOfGames = value;
      });
    }, onError: (val) {
      throw Exception('Failed to load games ${val.toString()}');
    });
  }

  Future<List<Game>> fetchGames(String query) async {
    List<Game> games = [];
    APIService apiService = APIService();
    GetGameCover getGameCover = GetGameCover();

    var body = await apiService.get(endpoint: '/v4/games/', gamequery: query);

    // var body = future as dynamic;
    //print(body);
    final Iterable list = body;
    var count = 0;
    //print(list);
    for (var item in list) {
      count++;
      print(item);
      String title = item['name'] == null ? 'N/A' : item['name'];
      String summary = item['summary'] == null ? "N/A" : item['summary'];
      print(item['id']);
      var image = await getGameCover.get(
          endpoint: '/v4/covers/', imagequery: item['id']);

      print(image);
      String thumbNail = image == null
          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
          : image[0]['url'] as String;

      Game searchedGame =
          new Game(title: title, summary: summary, photoUrl: thumbNail);

      games.add(searchedGame);
      if (count == 5) break;
    }
    // print(games);
    return games;
  }

  List<Widget> createGameCards(List<Game> games, BuildContext context) {
    List<Widget> children = [];
    final _gameCollectionReference =
        FirebaseFirestore.instance.collection('games');
    for (var game in games) {
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
                    (game.photoUrl == null ||
                            game.photoUrl!.isEmpty ||
                            game.photoUrl == 'N/A')
                        ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                        : game.photoUrl as String,
                    height: 100,
                    width: 160),
                ListTile(
                  title: Text(game.title,
                      style: TextStyle(color: HexColor('#5d48b6')),
                      overflow: TextOverflow.ellipsis),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SearchedGameDetailDialog(
                              game: game,
                              gameCollectionReference:
                                  _gameCollectionReference);
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

class APIService {
  // API key
  static const ClientID = "fn0i0w2dak1xfwdnfv5pofg8x3dmsm";
  // Base API url
  static const String _baseUrl = "api.igdb.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "Client-ID": ClientID,
    "Authorization": "Bearer 38fudl9b5ckhgthf0lzb0l3e87z4iu"
  };

  // Base API request to get response
  Future<dynamic> get({
    String? endpoint,
    String? gamequery,
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint as String);
    final response = await http.post(uri,
        headers: _headers,
        body:
            "search \"" + (gamequery as String) + "\"; fields name, summary;");
    // print(response.body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
      //return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}

class GetGameCover {
  // API key
  static const ClientID = "fn0i0w2dak1xfwdnfv5pofg8x3dmsm";
  // Base API url
  static const String _baseUrl = "api.igdb.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "Client-ID": ClientID,
    "Authorization": "Bearer 38fudl9b5ckhgthf0lzb0l3e87z4iu"
  };

  // Base API request to get response
  Future<dynamic> get({String? endpoint, int? imagequery}) async {
    Uri uri = Uri.https(_baseUrl, endpoint as String);
    final response = await http.post(uri,
        headers: _headers,
        body: "fields url; where game = " + (imagequery.toString()) + ";");
    print(response.body);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
      //return response.body;
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load json data');
    }
  }
}
