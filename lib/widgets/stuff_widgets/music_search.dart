import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:vibe_check_snipe_v1/widgets/stuff_widgets/searched_artist_detail.dart';
import '../../models/user.dart';
import '../input_decoration.dart';
import '../../models/artist.dart';

class MusicSearchPage extends StatefulWidget {
  @override
  State<MusicSearchPage> createState() => _MusicSearchPageState();
}

class _MusicSearchPageState extends State<MusicSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Artist> listOfArtists = [];
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
      Container(child: Text('Artist Search')),
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
                                    label: 'Search', hintText: 'Eminem'))),
                      ),
                    ),
                    SizedBox(height: 12),
                    (listOfArtists != null && listOfArtists.isNotEmpty)
                        ? Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: createArtistCards(
                                            listOfArtists, context),
                                      ))),
                            ],
                          )
                        : Center(child: Text('')),
                    Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(username)
                                .collection('usermusic')
                                .snapshots(),
                            builder: (context, snapshot) {
                              print(username);
                              if (!snapshot.hasData)
                                return const Text("Loading...");
                              else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                final artistListStream =
                                    snapshot.data!.docs.map((artist) {
                                  return Music.fromDocument(artist);
                                }).toList();

                                return Expanded(
                                    flex: 1,
                                    child: (artistListStream.length > 0)
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              height: 300,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    artistListStream.length,
                                                itemBuilder: (context, index) {
                                                  Music artist =
                                                      artistListStream[index];
                                                  return InkWell(
                                                      child: Container(
                                                    width: 100,
                                                    height: 180,
                                                    child: Column(children: [
                                                      Image.network(
                                                          artist.photoUrl
                                                              as String,
                                                          width: 70,
                                                          height: 140),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          artist.artistTitle
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
                                            child: Text("No Artists Added!")));
                              }
                            }))
                  ]))))
    ]));
  }

  void _search() async {
    await fetchArtists(_searchTextController.text).then((value) {
      setState(() {
        listOfArtists = value;
      });
    }, onError: (val) {
      throw Exception('Failed to load artists ${val.toString()}');
    });
  }

  Future<List<Artist>> fetchArtists(String query) async {
    List<Artist> artists = [];
    APIService apiService = APIService();

    var body = await apiService.get(
        endpoint: '/search/', artistquery: {"q": query, "type": "artists"});

    // var body = future as dynamic;
    // print(body);
    final Iterable list = body['artists']['items'];
    print(list);
    for (var item in list) {
      String title = item['data']['profile']['name'] == null
          ? 'N/A'
          : item['data']['profile']['name'];
      String artistURL =
          item['data']['uri'] == null ? "N/A" : item['data']['uri'];
      String thumbNail = item['data']['visuals']['avatarImage'] == null
          ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
          : item['data']['visuals']['avatarImage']['sources'] == null
              ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
              : item['data']['visuals']['avatarImage']['sources'][0]['url'] ==
                      null
                  ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                  : item['data']['visuals']['avatarImage']['sources'][0]['url'];

      Artist searchedArtist =
          new Artist(title: title, artistURL: artistURL, photoUrl: thumbNail);

      artists.add(searchedArtist);
    }
    print(artists);
    return artists;
  }

  List<Widget> createArtistCards(List<Artist> artists, BuildContext context) {
    List<Widget> children = [];
    final _artistCollectionReference =
        FirebaseFirestore.instance.collection('artists');
    for (var artist in artists) {
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
                    (artist.photoUrl == null ||
                            artist.photoUrl!.isEmpty ||
                            artist.photoUrl == 'N/A')
                        ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                        : artist.photoUrl as String,
                    height: 100,
                    width: 160),
                ListTile(
                  title: Text(artist.title,
                      style: TextStyle(color: HexColor('#5d48b6')),
                      overflow: TextOverflow.ellipsis),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SearchedArtistDetailDialog(
                              artist: artist,
                              artistCollectionReference:
                                  _artistCollectionReference);
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
  static const _api_key = "ad637fee5emsh0af395030bd1515p1b786ajsncb89275915bf";
  // Base API url
  static const String _baseUrl = "spotify23.p.rapidapi.com";
  // Base headers for Response url
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "x-rapidapi-host": "spotify23.p.rapidapi.com",
    "x-rapidapi-key": _api_key,
  };

  // Base API request to get response
  Future<dynamic> get({
    String? endpoint,
    Map<String, String>? artistquery,
  }) async {
    Uri uri = Uri.https(_baseUrl, endpoint as String, artistquery);
    final response = await http.get(uri, headers: _headers);
    //print(response.body);
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
