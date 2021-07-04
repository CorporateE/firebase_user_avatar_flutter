import 'package:meta/meta.dart';

class Job {
  Job({@required this.id, this.name, this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'ratePerHour' :ratePerHour,
    };
  }

  factory Job.fromMap(Map<String, dynamic> data, String documentID) {
    if (data == null) { // make sure it is == or you will get a not null error
      return null;
    }
    final String name = data['name'];
    final int ratePerHour= data["ratePerHour"];
    return Job(
      id: documentID,
      name:name,
      ratePerHour: ratePerHour,
    );
  }



}