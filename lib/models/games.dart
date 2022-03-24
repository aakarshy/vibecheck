import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String title;
  String? summary;
  String? photoUrl;
  String? userId;

  Game(
      {this.id = '',
      this.title = '',
      this.summary,
      this.photoUrl,
      this.userId});
  factory Game.fromDocument(QueryDocumentSnapshot data) {
    // Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return Game(
        id: data.id,
        title: data.get('title'),
        summary: data.get('summary'),
        photoUrl: data.get('photo_url'),
        userId: data.get('user_id'));
  }
  // factory Book.fromDocument(QueryDocumentSnapshot data) {
  //   return Book(
  //       id: data.id,
  //       title: data.get('title'),
  //       author: data.get('author'),
  //       notes: data.get('notes'),
  //       photoUrl: data.get('photo_url'),
  //       categories: data.get('categories'),
  //       publishedDate: data.get('published_date'),
  //       rating: double.parse(data.get('rating')),
  //       description: data.get('description'),
  //       pageCount: data.get('page_count'),
  //       startedReading: data.get('started_reading_at'),
  //       finishedReading: data.get('finished_reading_at'),
  //       userId: data.get('user_id'));
  // }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'user_id': userId,
      'summary': summary,
      'photo_url': photoUrl,
    };
  }
}
