import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/cache.dart';

import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class QuizRepository {
  QuizRepository({
    InMemoryCache? cache,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _cache = cache ?? InMemoryCache(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final InMemoryCache _cache;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  Future<void> createNewQuiz(Quiz quiz) async {
    const uuid = Uuid();
    final user = _cache.read<AppUser>(key: 'user');
    final quizId = quiz.id.isNotEmpty ? quiz.id : uuid.v4();
    final createdAt = DateTime.now();

    String quizImageUrl = await _getDownloadUrl(
      path: 'quiz/$quizId/cover.jpg',
      media: quiz.media,
    );

    final updatedQuestionList = await Future.wait(
      quiz.questions.map(
        (question) => _getDownloadUrl(
          path: 'quiz/$quizId/${question.id}/',
          media: question.media,
        ).then(
          (imageUrl) => question.copyWith(
            media: question.media.copyWith(imageUrl: imageUrl),
          ),
        ),
      ),
    );

    final newQuiz = quiz.copyWith(
      id: quizId,
      createdAt: createdAt,
      media: Media(
        imageUrl: quizImageUrl,
      ),
      questions: updatedQuestionList,
      author: user,
    );

    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quizId)
        .set(newQuiz.toMap());
  }

  Future<List<Quiz>> fetchAllQuizzes() async {
    final quiz = <Quiz>[];
    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(_cache.read<AppUser>(key: 'user')!.id)
        .collection(FirebaseDocumentConstants.quiz)
        .get()
        .then((querySnapshot) {
      for (final quizzes in querySnapshot.docs) {
        quiz.add(Quiz.fromMap(quizzes.data()));
      }
    });

    return quiz;
  }

  Stream<List<Quiz>> fetchAllQuizzes2() {
    final user = _cache.read<AppUser>(key: 'user');
    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .snapshots()
        .asyncMap((event) {
      final quizzes = <Quiz>[];
      for (final doc in event.docs) {
        final quiz = Quiz.fromMap(doc.data());
        if (quiz.author.id == user!.id) {
          quizzes.add(quiz);
        }
      }

      return quizzes;
    });
  }

  Stream<List<Quiz>> fetchListQuizzes() {
    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .where('isPublic', isEqualTo: true)
        .orderBy('played', descending: true)
        .snapshots()
        .asyncMap((event) {
      final quiz = <Quiz>[];
      for (final doc in event.docs) {
        quiz.add(Quiz.fromMap(doc.data()));
      }

      return quiz;
    });
  }

  Future<void> updateNumOfPlayer(Quiz quiz) async {
    final count = quiz.playedCount + 1;
    final newData = quiz.copyWith(
      playedCount: count,
    );
    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quiz.id)
        .set(newData.toMap());
  }

  Future<void> rating(Quiz quiz, double rating) async {
    final avg = quiz.rating == 0.0 ? rating : (quiz.rating + rating) / 2;

    return _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quiz.id)
        .update({'rating': avg});
  }

  Future<void> saveQuiz(
    Quiz quiz,
    QuizCollection? collection,
  ) async {
    final user = _cache.read<AppUser>(key: 'user');
    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(user!.id)
        .collection(FirebaseDocumentConstants.save)
        .doc(quiz.id)
        .set(quiz.toMap()..addAll({'belongsTo': collection?.id}));
  }

  Stream<List<Quiz>> fetchBookmarks() {
    final user = _cache.read<AppUser>(key: 'user');
    return _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(user!.id)
        .collection(FirebaseDocumentConstants.save)
        .snapshots()
        .asyncMap((event) {
      final bookmarks = <Quiz>[];
      for (final doc in event.docs) {
        final quiz = Quiz.fromMap(doc.data());
        bookmarks.add(quiz);
      }
      return bookmarks;
    });
  }

  Future<Quiz> getQuizById(Quiz quiz) async {
    Quiz newQuiz = quiz;
    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quiz.id)
        .get()
        .then((querySnapshot) {
      final quiz = Quiz.fromMap(querySnapshot.data()!);
      newQuiz = quiz;
    });

    return newQuiz;
  }

  Future<List<Quiz>> fetchQuizByCollection(String collectionId) async {
    final quizzies = <Quiz>[];
    final user = _cache.read<AppUser>(key: 'user') ?? AppUser.empty;
    await _firestore
        .collection(FirebaseDocumentConstants.user)
        .doc(user.id)
        .collection(FirebaseDocumentConstants.save)
        .where('belongsTo', isEqualTo: collectionId)
        .get()
        .then((querySnapshot) async {
      for (final quiz in querySnapshot.docs) {
        final q = Quiz.fromMap(quiz.data());
        final q2 = await getQuizById(q);
        quizzies.add(q2);
      }
    });

    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .where('collectionId', isEqualTo: collectionId)
        .get()
        .then((querySnapshot) {
      for (final snapshot in querySnapshot.docs) {
        final quiz = Quiz.fromMap(snapshot.data());
        if (!quizzies.contains(quiz)) {
          quizzies.add(quiz);
        }
      }
    });

    return quizzies;
  }

  Future<void> removeQuiz(Quiz quiz) async {
    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .doc(quiz.id)
        .delete();
  }

  Future<String> _getDownloadUrl({
    required String path,
    required Media media,
  }) async {
    if (media.type == AttachType.online) return media.imageUrl!;
    if (media.type == AttachType.none) return '';

    final file = File(media.imageUrl!);
    final uploadTask = _storage.ref().child(path).putFile(file);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
