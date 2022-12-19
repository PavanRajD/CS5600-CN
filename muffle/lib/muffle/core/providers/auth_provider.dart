import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../models/model.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.prefs,
    required this.firebaseFirestore,
  });

  String? getUserFirebaseId() {
    return prefs.getString(FirestoreConstants.id);
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString(FirestoreConstants.id)?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore.collection(FirestoreConstants.pathUserCollection).where(FirestoreConstants.id, isEqualTo: firebaseUser.uid).get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          // Writing data to server because here is a new user
          firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUser.uid).set({
            FirestoreConstants.nickname: firebaseUser.displayName,
            FirestoreConstants.photoUrl: firebaseUser.photoURL,
            FirestoreConstants.id: firebaseUser.uid,
            FirestoreConstants.createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
            FirestoreConstants.chattingWith: null,
            FirestoreConstants.aboutMe: "Available",
            FirestoreConstants.isDNDActivated: "false",
            FirestoreConstants.overrideContacts: "",
            FirestoreConstants.notAvilableEndTime: "",
            FirestoreConstants.notAvilableStartTime: "",
          });

          // Write data to local storage
          User? currentUser = firebaseUser;
          await prefs.setString(FirestoreConstants.id, currentUser.uid);
          await prefs.setString(FirestoreConstants.nickname, currentUser.displayName ?? "");
          await prefs.setString(FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
          await prefs.setString(FirestoreConstants.aboutMe, "Available");
          await prefs.setString(FirestoreConstants.isDNDActivated, "false");
          await prefs.setString(FirestoreConstants.overrideContacts, "");
          await prefs.setString(FirestoreConstants.notAvilableEndTime, "");
          await prefs.setString(FirestoreConstants.notAvilableStartTime, "");
        } else {
          // Already sign up, just get data from firestore
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs.setString(FirestoreConstants.id, userChat.id);
          await prefs.setString(FirestoreConstants.nickname, userChat.nickname);
          await prefs.setString(FirestoreConstants.photoUrl, userChat.photoUrl);
          await prefs.setString(FirestoreConstants.aboutMe, userChat.aboutMe);
          await prefs.setString(FirestoreConstants.isDNDActivated, userChat.isDNDActivated);
          await prefs.setString(FirestoreConstants.overrideContacts, userChat.ovverideContacts);
          await prefs.setString(FirestoreConstants.notAvilableEndTime, userChat.notAvilableEndTime);
          await prefs.setString(FirestoreConstants.notAvilableStartTime, userChat.notAvilableStartTime);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateDNDStatus(bool isDNDActivated) async {
    var firebaseUserId = getUserFirebaseId();
    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUserId).update({
      FirestoreConstants.isDNDActivated: isDNDActivated.toString(),
    });
  }

  Future<void> updateReplyMessage(String autoReplyMessage) async {
    var firebaseUserId = getUserFirebaseId();
    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUserId).update({
      FirestoreConstants.aboutMe: autoReplyMessage,
    });
  }

  Future<void> updateNonAvilableTimings(String startTime, String endTime) async {
    var firebaseUserId = getUserFirebaseId();
    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUserId).update({
      FirestoreConstants.notAvilableStartTime: startTime,
      FirestoreConstants.notAvilableEndTime: endTime,
    });
  }

  Future<void> updateOvverideListMessage(String overrideContacts) async {
    var firebaseUserId = getUserFirebaseId();
    firebaseFirestore.collection(FirestoreConstants.pathUserCollection).doc(firebaseUserId).update({
      FirestoreConstants.overrideContacts: overrideContacts,
    });
  }

  void handleException() {
    _status = Status.authenticateException;
    notifyListeners();
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await prefs.clear();
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }
}
