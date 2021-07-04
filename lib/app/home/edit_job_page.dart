import 'package:firebase_user_avatar_flutter/test_fireb_services/database.dart';
import 'package:firebase_user_avatar_flutter/test_fireb_services/job_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditJobPage(
              database: database,
              job: job,
            ),
        fullscreenDialog: true));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if(widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          // showAlertDialog(context,
          //     title: 'Name already used',
          //     content: 'Please choose a different name',
          //     defaultActionText: 'OK');
        } else {
          final id = widget.job?.id ?? documentIDFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } catch (e) {
        print(e);
        // showExceptionAlertDialog(context,
        //     title: 'Operation failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
              onPressed: _submit,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: _buildContents() ,
    );
  }


  Widget _buildContents() {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
      
    ),
  );
  }

Widget _buildForm() {
  return Form(
    key: _formKey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: _buildChildrenForm(),
),
  );
}

List<Widget> _buildChildrenForm() {
  return [
    TextFormField(
      decoration: InputDecoration(labelText: 'Job Name'),
      initialValue: _name,
      validator: (value) => value.isNotEmpty? null : 'Name can\`t be empty',
      onSaved: (value) => _name = value,
    ),
    TextFormField(
      decoration: InputDecoration(labelText: 'Rate per hour'),
      initialValue: '$_ratePerHour',
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
    ),
  ];

}
}