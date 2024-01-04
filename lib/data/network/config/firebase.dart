
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Collection {
  static const String user = 'User';
  static const String admin = 'Admin';
  static const String config = 'Config';
  static const String banner = 'Banner';
  static const String blogs = 'Blogs';
  static const String liked = 'Liked';
  static const String reported = 'Reported';
}
class FirebaseClient {
  
  FirebaseClient._internal();
  static final _instance = FirebaseClient._internal();
  factory FirebaseClient() => _instance;

  Future<void> init() async{

    await Firebase.initializeApp(
        options: const FirebaseOptions(
            projectId: 'kannada-medical-connect',
            apiKey: 'AIzaSyCWkCdLRbCuLReJRUnbArKpjzV2oeRJZoY',
            messagingSenderId: '605104113407',
            appId: '1:605104113407:android:a8c76394377ddabd446eca'
        )
    );

  }

  final firestore = FirebaseFirestore.instance;
  
  User? getUser(){
    return FirebaseAuth.instance.currentUser;
  }

  CollectionReference get userDB => firestore.collection(Collection.user);
  CollectionReference get adminDB => firestore.collection(Collection.admin);
  CollectionReference get reportDB => firestore.collection(Collection.reported);
  CollectionReference get blogDB => firestore.collection(Collection.blogs);
  DocumentReference get bannerDoc => firestore.collection(Collection.config).doc(Collection.banner);

  CollectionReference get likedDB => firestore.collection(Collection.user).doc(getUser()!.uid).collection(Collection.liked);
  Reference get storageReference => FirebaseStorage.instance.ref().child(getUser()!.uid);

  Reference get userDocumentStorage => FirebaseStorage.instance.ref('user/${FirebaseAuth.instance.currentUser!.uid}/documents');

}