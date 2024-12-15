import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';

class DetailActivityPage extends StatefulWidget {
  final String activityId;
  final String initialtitle;
  final String initiallocation;
  final String initialdescription;
  final String initialnotes;
  final Timestamp initialdateTime;

  const DetailActivityPage({
    super.key,
    required this.activityId,
    required this.initialtitle,
    required this.initiallocation,
    required this.initialdescription,
    required this.initialnotes,
    required this.initialdateTime,
  });

  @override
  State<DetailActivityPage> createState() => _DetailActivityPageState();
}

class _DetailActivityPageState extends State<DetailActivityPage> {
  late TextEditingController titleController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController notesController;
  late DateTime dateTime;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialtitle);
    locationController = TextEditingController(text: widget.initiallocation);
    descriptionController = TextEditingController(text: widget.initialdescription);
    notesController = TextEditingController(text: widget.initialnotes);
    dateTime = (widget.initialdateTime as Timestamp).toDate();
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Activity'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Date & Time ${DateFormat('yyyy-MM-dd – HH:mm').format(dateTime)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedtitle = titleController.text;
                final updatedlocation = locationController.text;
                final updateddescription = descriptionController.text;
                final updatednotes = notesController.text;

                if (titleController.text.isNotEmpty) {
                  await _firestoreService.updateActivity(
                    widget.activityId, 
                    updatedtitle, 
                    updatedlocation, 
                    updateddescription, 
                    updatednotes
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
