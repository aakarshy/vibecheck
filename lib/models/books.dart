import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String author;
  String? notes;
  final String categories;
  final String description;
  final String photoUrl;
  final String publishedDate;
  int? rating;
  final int pageCount;
  Timestamp? startedReading;
  Timestamp? finishedReading;
  final String userId;

  Book({
    this.id = '',
    this.title = '',
    this.author = '',
    this.notes,
    this.categories = '',
    this.description = '',
    this.photoUrl = '',
    this.publishedDate = '',
    this.rating,
    this.pageCount = 0,
    this.startedReading,
    this.finishedReading,
    this.userId = '',
  });
  factory Book.fromDocument(QueryDocumentSnapshot data) {
    // Map<String, dynamic> info = data.data() as Map<String, dynamic>;
    return Book(
        id: data.id,
        title: data.get('title'),
        author: data.get('author'),
        notes: data.get('notes'),
        categories: data.get('categories'),
        description: data.get('description'),
        photoUrl: data.get('photo_url'),
        publishedDate: data.get('published_date'),
        rating: (data.get('rating') != null) ? data.get('rating') : 0,
        pageCount: data.get('page_count'),
        startedReading: data.get('started_reading_at'),
        finishedReading: data.get('finished_reading_at'),
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
      'author': author,
      'notes': notes,
      'photo_url': photoUrl,
      'published_date': publishedDate,
      'rating': rating,
      'description': description,
      'page_count': pageCount,
      'started_reading_at': startedReading,
      'finished_reading_at': finishedReading,
      'categories': categories,
    };
  }
}
