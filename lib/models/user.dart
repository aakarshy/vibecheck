import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/annotation.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MUser {
  String? id;
  String? uid;
  String? displayName;
  String? username;
  int? code;
  String? otherlink;
  String? instahandle;
  String? avatarUrl;
  // Books? books;

  MUser({
    this.id,
    this.uid,
    this.displayName,
    this.username,
    this.code = 0,
    this.instahandle = "",
    this.otherlink = "",
    this.avatarUrl = "",
    //this.books
  });

  factory MUser.fromDocument(data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;

    return MUser(
      id: data.id,
      username: info['username'],
      uid: info['uid'],
      displayName: info['display_name'],
      instahandle: info['instahandle'],
      otherlink: info['otherlink'],
      avatarUrl: info['avatar_url'],
      code: info['code'],
      //books: info['books']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'display_name': displayName,
      'instahandle': instahandle,
      'otherlink': otherlink,
      'avatar_url': avatarUrl,
      'code': code,
      //'books': books
    };
  }
}

@JsonSerializable()
class Books {
  String? bookTitle;
  String? photoUrl;
  String? category;

  Books({this.bookTitle, this.photoUrl, this.category});

  factory Books.fromDocument(data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;

    return Books(
        bookTitle: info['bookTitle'],
        photoUrl: info['photoUrl'],
        category: info['category']);
  }
}

@JsonSerializable()
class Movies {
  String? movieTitle;
  String? photoUrl;
  String? type;
  String? year;

  Movies({this.movieTitle, this.photoUrl, this.type, this.year});

  factory Movies.fromDocument(data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;

    return Movies(
        movieTitle: info['movieTitle'],
        photoUrl: info['photoUrl'],
        type: info['type'],
        year: info['year']);
  }
}

@JsonSerializable()
class Music {
  String? artistTitle;
  String? photoUrl;
  String? artistURL;

  Music({this.artistTitle, this.photoUrl, this.artistURL});

  factory Music.fromDocument(data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;

    return Music(
      artistTitle: info['artistTitle'],
      photoUrl: info['photoUrl'],
      artistURL: info['artistURL'],
    );
  }
}

@JsonSerializable()
class Games {
  String? gameTitle;
  String? photoUrl;
  String? summary;

  Games({this.gameTitle, this.photoUrl, this.summary});

  factory Games.fromDocument(data) {
    Map<String, dynamic> info = data.data() as Map<String, dynamic>;

    return Games(
      gameTitle: info['gameTitle'],
      photoUrl: info['photoUrl'],
      summary: info['summary'],
    );
  }
}

// class _Book {
//   String? photoUrl;
//   String? category;

//   _Book({this.photoUrl, this.category});
// }

@Collection<MUser>('users')
@Collection<Books>('users/*/userbooks')
@Collection<Movies>('users/*/usermovies')
@Collection<Music>('users/*/usermusic')
@Collection<Music>('users/*/usergames')
final UserRef = MUser();
