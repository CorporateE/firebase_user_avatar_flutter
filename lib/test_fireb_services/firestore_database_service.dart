import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreDatabaseService {
  FireStoreDatabaseService._();
  static final instance = FireStoreDatabaseService._();


  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('in setData FireStoreService printing path $path, data $data');
    await reference.setData(data);
  }

  Stream<List<T>> collectionStream<T> ({
    @required String path,
    @required T Function(Map<String,dynamic> data, String documentID) builder,
  })
  {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents.map(
          (snapshot) => builder(snapshot.data, snapshot.documentID),
    ).toList() //map return iterable collection, so do not forget to format it like here into list
    );
  }


}