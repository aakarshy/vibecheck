import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../input_decoration.dart';
import 'searched_book_detail.dart';
import '../../models/books.dart';

class BookSearchPage extends StatefulWidget {
  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  List<Book> listOfBooks = [];
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
      Container(child: Text('Book Search')),
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
                    (listOfBooks != null && listOfBooks.isNotEmpty)
                        ? Row(
                            children: [
                              Expanded(
                                  child: SizedBox(
                                      width: 300,
                                      height: 200,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: createBookCards(
                                            listOfBooks, context),
                                      ))),
                            ],
                          )
                        : Center(child: Text('')),
                    Container(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(username)
                                .collection('userbooks')
                                .snapshots(),
                            builder: (context, snapshot) {
                              print(username);
                              if (!snapshot.hasData)
                                return const Text("Loading...");
                              else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else {
                                final bookListStream =
                                    snapshot.data!.docs.map((book) {
                                  return Books.fromDocument(book);
                                }).toList();

                                return Expanded(
                                    flex: 1,
                                    child: (bookListStream.length > 0)
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              height: 300,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    bookListStream.length,
                                                itemBuilder: (context, index) {
                                                  Books book =
                                                      bookListStream[index];
                                                  return InkWell(
                                                      child: Container(
                                                    width: 100,
                                                    height: 180,
                                                    child: Column(children: [
                                                      Image.network(
                                                          book.photoUrl
                                                              as String,
                                                          width: 70,
                                                          height: 140),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Text(
                                                          book.bookTitle
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
    await fetchBooks(_searchTextController.text).then((value) {
      setState(() {
        listOfBooks = value;
      });
    }, onError: (val) {
      throw Exception('Failed to load books ${val.toString()}');
    });
  }

  Future<List<Book>> fetchBooks(String query) async {
    List<Book> books = [];
    http.Response response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q={$query}'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final Iterable list = body['items'];
      for (var item in list) {
        String title = item['volumeInfo']['title'] == null
            ? 'N/A'
            : item['volumeInfo']['title'];
        String author = item['volumeInfo']['authors'] == null
            ? "N/A"
            : item['volumeInfo']['authors'][0];
        String description = item['volumeInfo']['description'] == null
            ? 'N/A'
            : item['volumeInfo']['description'];
        String thumbNail = item['volumeInfo']['imageLinks'] == null
            ? "N/A"
            : item['volumeInfo']['imageLinks']['thumbnail'];
        String publishedDate = item['volumeInfo']['publishedDate'] == null
            ? 'N/A'
            : item['volumeInfo']['publishedDate'];
        int pageCount = item['volumeInfo']['pageCount'] == null
            ? 0
            : item['volumeInfo']['pageCount'];
        String categories = item['volumeInfo']['categories'] == null
            ? 'N/A'
            : item['volumeInfo']['categories'][0];
        Book searchedBook = new Book(
            title: title,
            author: author,
            photoUrl: thumbNail,
            description: description,
            publishedDate: publishedDate,
            pageCount: pageCount,
            categories: categories);

        books.add(searchedBook);
      }
    } else {
      throw ('error ${response.reasonPhrase}');
    }
    return books;
  }

  List<Widget> createBookCards(List<Book> books, BuildContext context) {
    List<Widget> children = [];
    final _bookCollectionReference =
        FirebaseFirestore.instance.collection('books');
    for (var book in books) {
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
                    (book.photoUrl == null ||
                            book.photoUrl.isEmpty ||
                            book.photoUrl == 'N/A')
                        ? 'https://media.istockphoto.com/photos/blue-book-picture-id1281955543'
                        : book.photoUrl,
                    height: 100,
                    width: 160),
                ListTile(
                  title: Text(book.title,
                      style: TextStyle(color: HexColor('#5d48b6')),
                      overflow: TextOverflow.ellipsis),
                  subtitle: Text(book.author, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SearchedBookDetailDialog(
                              book: book,
                              bookCollectionReference:
                                  _bookCollectionReference);
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
