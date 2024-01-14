import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ot_registration/data/network/utils/collections.dart';

class FirebaseReferences {
  static final _instance = FirebaseReferences._internal();
  factory FirebaseReferences() => _instance;
  FirebaseReferences._internal();

  static final firestore = FirebaseFirestore.instance;

  CollectionReference get userDB => firestore.collection(Collection.user);
  DocumentReference therapistDB(String uid) => firestore
      .collection(Collection.user)
      .doc(uid)
      .collection(Collection.details)
      .doc(Collection.therapist);
  DocumentReference organizationDB(String uid) => firestore
      .collection(Collection.user)
      .doc(uid)
      .collection(Collection.details)
      .doc(Collection.organization);
  CollectionReference get adminDB => firestore.collection(Collection.admin);
  CollectionReference get reportDB => firestore.collection(Collection.reported);
  CollectionReference get blogDB => firestore.collection(Collection.blogs);
  DocumentReference get bannerDoc =>
      firestore.collection(Collection.common).doc(Collection.banner);

  // static CollectionReference likedDB(String uid) => firestore
  //     .collection(Collection.user)
  //     .doc(uid)
  //     .collection(Collection.liked);
  CollectionReference likedDB(
    String blogId,
  ) =>
      blogDB.doc(blogId).collection(Collection.liked);

  static Reference storageReference(String uid) =>
      FirebaseStorage.instance.ref().child(uid);

  static Reference userDocumentStorage(String uid) =>
      FirebaseStorage.instance.ref('user/$uid/documents');

  static Reference blogStorage() => FirebaseStorage.instance.ref('blogs');
  static Reference bannerStorage() => FirebaseStorage.instance.ref('banners');
}
