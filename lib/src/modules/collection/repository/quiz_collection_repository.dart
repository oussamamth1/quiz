import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/common/utils/debouncer.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class QuizCollectionRepository {
  QuizCollectionRepository({
    FirebaseFirestore? firestore,
    Debouncer? debouncer,
    FirebaseStorage? storage,
    InMemoryCache? cache,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _debouncer = debouncer ?? Debouncer(),
        _storage = storage ?? FirebaseStorage.instance,
        _cache = cache ?? InMemoryCache();

  final FirebaseFirestore _firestore;
  final Debouncer _debouncer;
  final FirebaseStorage _storage;
  final InMemoryCache _cache;

  Future<List<QuizCollection>> fetchAllCollections({
    int limit = 10,
  }) async {
    final collections = <QuizCollection>[];
    await _firestore
        .collection(FirebaseDocumentConstants.collection)
        .orderBy('name')
        .get()
        .then((querySnapshot) {
      for (final collection in querySnapshot.docs) {
        collections.add(QuizCollection.fromMap(collection.data()));
      }
    });

    return collections;
  }

  Stream<List<QuizCollection>> listenAllCollections() {
    final collections = <QuizCollection>[];
    final user = _cache.read<AppUser>(key: 'user') ?? AppUser.empty;

    return _firestore
        .collection(FirebaseDocumentConstants.collection)
        .orderBy('name')
        .get()
        .asStream()
        .asyncMap((querySnapshot) {
      for (final collection in querySnapshot.docs) {
        final c = QuizCollection.fromMap(collection.data());
        if (c.owner == null && c.isVibility == null) {
          collections.add(c);
        }

        if (c.owner == user.id && c.isVibility!) {
          collections.add(c);
        }

        if (c.owner != user.id && (c.isVibility ?? false)) {
          collections.add(c);
        }
      }

      return collections;
    });
  }

  Future<List<QuizCollection>> _searchCollection(
    String value, [
    int limit = 10,
  ]) async {
    final collections = <QuizCollection>[];
    await _firestore
        .collection(FirebaseDocumentConstants.collection)
        .get()
        .then((querySnapshot) {
      for (final collection in querySnapshot.docs) {
        final quiz = QuizCollection.fromMap(collection.data());
        if (quiz.name.toLowerCase().contains(value.toLowerCase().trim())) {
          collections.add(QuizCollection.fromMap(collection.data()));
        }
      }
    });

    return collections;
  }

  Future<List<QuizCollection>> searchCollection(
    String value, [
    int limit = 10,
  ]) async {
    return _debouncer.debounce(
      callback: _searchCollection,
      args: [value, limit],
    );
  }

  Future<List<Quiz>> collectionByID(String collectionId) async {
    final quizzes = <Quiz>[];
    await _firestore
        .collection(FirebaseDocumentConstants.quiz)
        .where('collectionId', isEqualTo: collectionId)
        .get()
        .then((querySnapshot) {
      for (final quiz in querySnapshot.docs) {
        quizzes.add(Quiz.fromMap(quiz.data()));
      }
    });
    return quizzes;
  }

  Future<QuizCollection> addNewCollection({
    required String name,
    required Media media,
    required bool isPublic,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();
    final user = _cache.read<AppUser>(key: 'user') ?? AppUser.empty;

    final imageUrl =
        await _getDownloadUrl(path: 'collection/$id/$id.jpg', media: media);

    final collection = QuizCollection(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );

    final collectionExtra = <String, dynamic>{
      'isPublic': isPublic,
      'user': user.id,
    };

    collectionExtra.addAll(collection.toMap());

    await _firestore
        .collection(FirebaseDocumentConstants.collection)
        .doc(id)
        .set(collectionExtra);

    return collection;
  }

  Stream<List<QuizCollection>> ownCollection() {
    final user = _cache.read<AppUser>(key: 'user') ?? AppUser.empty;

    return _firestore
        .collection(FirebaseDocumentConstants.collection)
        .where('user', isEqualTo: user.id)
        .snapshots()
        .asyncMap((event) {
      final collections = <QuizCollection>[];
      for (final doc in event.docs) {
        collections.add(QuizCollection.fromMap(doc.data()));
      }

      return collections;
    });
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
