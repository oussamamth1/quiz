import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/lobby/model/participant.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';

class LobbyRepository {
  LobbyRepository({
    FirebaseFirestore? firestore,
    InMemoryCache? cache,
  })  : _cache = cache ?? InMemoryCache(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final InMemoryCache _cache;

  Future<Lobby> createLobby(
    Lobby lobby, {
    bool isSoloMode = true,
  }) async {
    final user = _cache.read<AppUser>(key: 'user');
    final now = DateTime.now();

    final participant = Participant(participant: user!);
    final participants = List<Participant>.from(lobby.participants)
      ..add(participant);

    final shuffleQuestion = List<Question>.from(lobby.quiz.questions);
    shuffleQuestion.shuffle();

    final lobbyNew = lobby.copyWith(
      host: user,
      participants: participants,
      quiz: lobby.quiz.copyWith(
        questions: shuffleQuestion,
      ),
      startTime: now,
      code: isSoloMode ? null : _randomCode(),
    );

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobbyNew.toInfomation());

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .doc(user.id)
        .set(participant.toMap());

    return lobbyNew;
  }

  Future<void> startGame(Lobby lobby) async {
    final lobbyNew = lobby.copyWith(
      isStart: true,
    );
    final user = _cache.read<AppUser>(key: 'user');
    final participant = lobbyNew.participants
        .firstWhere((p) => p.participant.id == user!.id)
        .copyWith(score: 0);

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .set(lobbyNew.toMap());

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .doc(user!.id)
        .set(participant.toMap());
  }

  String _randomCode() {
    final rand = Random().nextInt(1000000);
    return rand.toString().padLeft(6, '0');
  }

  Future<Lobby?> enterLobby(String code) async {
    final lobbies = <Lobby>[];
    final user = _cache.read<AppUser>(key: 'user');
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('code', isEqualTo: code)
        .where('isStart', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (final lobby in querySnapshot.docs) {
        lobbies.add(Lobby.fromMap(lobby.data()));
      }
    });

    if (lobbies.isEmpty) {
      return null;
    }

    final participant = Participant(
      participant: user!,
    );

    final participants = List<Participant>.from(lobbies[0].participants)
      ..add(participant);

    final lobby = lobbies[0].copyWith(participants: participants);
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .doc(user.id)
        .set(participant.toMap());

    return lobby;
  }

  Stream<Lobby> lobby(Lobby lobby) {
    return _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('id', isEqualTo: lobby.id)
        .snapshots()
        .asyncMap((event) {
      return Lobby.fromMap(event.docs[0].data());
    });
  }

  Stream<List<Participant>> participants(Lobby lobby) {
    return _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .orderBy('score', descending: true)
        .snapshots()
        .asyncMap((event) {
      final participants = <Participant>[];
      for (final participant in event.docs) {
        participants.add(Participant.fromMap(participant.data()));
      }

      return participants;
    });
  }

  Future<void> updateScore(Lobby lobby, int score) async {
    final user = _cache.read<AppUser>(key: 'user');
    final participant = Participant(
      participant: user!,
      score: score,
    );

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .doc(user.id)
        .set(participant.toMap());
  }

  int getRank(Lobby lobby) {
    final user = _cache.read<AppUser>(key: 'user');
    final index = lobby.participants.indexWhere(
      (e) => user!.id == e.participant.id,
    );

    return index;
  }

  Future<List<Lobby>> soloHistory(Lobby lobby) async {
    var listLobby = <Lobby>[];
    // final participant = <Participant>[];

    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .where('isSolo', isEqualTo: true)
        .where('isCancelled', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        final firestoreLobby = Lobby.fromMap(doc.data());
        if (firestoreLobby.quiz.id == lobby.quiz.id) {
          listLobby.add(Lobby.fromMap(doc.data()));
        }
      }
    });

    for (int i = 0; i < listLobby.length; i++) {
      final lobby = listLobby[i];
      final participants = <Participant>[];
      await _firestore
          .collection(FirebaseDocumentConstants.lobby)
          .doc(lobby.id)
          .collection(FirebaseDocumentConstants.lobbyParticipant)
          .get()
          .then((querySnapshot) {
        final p = Participant.fromMap(querySnapshot.docs[0].data());
        participants.add(p);
        final newLobby = lobby.copyWith(participants: participants);
        listLobby[i] = newLobby;
      });
    }

    return listLobby;
  }

  Future<void> onCancelRoom(Lobby lobby) async {
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .update({'code': null});
  }

  Future<void> onLeaveRoom(Lobby lobby) async {
    final user = _cache.read<AppUser>(key: 'user') ?? AppUser.empty;
    await _firestore
        .collection(FirebaseDocumentConstants.lobby)
        .doc(lobby.id)
        .collection(FirebaseDocumentConstants.lobbyParticipant)
        .doc(user.id)
        .delete();
  }
}
