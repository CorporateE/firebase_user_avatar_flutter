import 'package:firebase_user_avatar_flutter/test_fireb_services/job_model.dart';
import 'package:flutter/material.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job, this.onTap}) : super(key: key);
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name, style: TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
      tileColor: Colors.indigo,
      leading: Text(job.ratePerHour.toString(), style: TextStyle(color: Colors.white, fontSize: 18)),
      trailing: Icon(Icons.check_box_outline_blank, color:Colors.white),
    );
  }
}
