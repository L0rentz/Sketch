import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userInfosCollection =
      FirebaseFirestore.instance.collection('profils');

  // Insert data
  Future updateUserProfil(
      String firstname, String lastname, String picture) async {
    return await userInfosCollection.doc(uid).set({
      'firstname': firstname,
      'lastname': lastname,
      'picture': picture,
    });
  }

  // Check if document exist
  Future<bool> checkProfilExist() async {
    DocumentSnapshot ds = await userInfosCollection.doc(uid).get();
    return (ds.exists);
  }

  // Get data
  Future getUserProfil() async {
    return await userInfosCollection.doc(uid).get();
  }

  // Get data stream
  Stream<QuerySnapshot> get profils {
    return userInfosCollection.snapshots();
  }
}
