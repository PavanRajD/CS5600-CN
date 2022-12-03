import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';

class UserChat {
  String id;
  String photoUrl;
  String nickname;
  String aboutMe;
  String isDNDActivated;
  bool select = false;
  String ovverideContacts;

  UserChat({required this.id, required this.photoUrl, required this.nickname, required this.aboutMe, required this.isDNDActivated, this.ovverideContacts = ""});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.isDNDActivated: isDNDActivated,
      FirestoreConstants.overrideContacts: ovverideContacts,
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String aboutMe = "";
    String photoUrl = "";
    String nickname = "";
    String isDNDActivated = "false";
    String ovverideContacts = "";
    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    try {
      isDNDActivated = doc.get(FirestoreConstants.isDNDActivated);
    } catch (e) {}
    try {
      ovverideContacts = doc.get(FirestoreConstants.overrideContacts);
    } catch (e) {}
    return UserChat(
      id: doc.id,
      photoUrl: photoUrl,
      nickname: nickname,
      aboutMe: aboutMe,
      isDNDActivated: isDNDActivated,
      ovverideContacts: ovverideContacts,
    );
  }
}
