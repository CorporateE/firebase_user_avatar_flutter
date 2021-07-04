import 'package:firebase_user_avatar_flutter/services/firestore_service.dart';
import 'package:firebase_user_avatar_flutter/test_fireb_services/firestore_database_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_user_avatar_flutter/test_fireb_services/api_service.dart';
import 'package:firebase_user_avatar_flutter/test_fireb_services/job_model.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIDFromCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FireStoreDatabaseService.instance;

  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
