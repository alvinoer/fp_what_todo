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
    descriptionController =
        TextEditingController(text: widget.initialdescription);
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              buildLabel("Title"),
              buildDecoratedTextField(titleController),
              const SizedBox(height: 12),

              // Location Field
              buildLabel("Location"),
              buildDecoratedTextField(locationController),
              const SizedBox(height: 12),

              // Description Field
              buildLabel("Description"),
              buildDecoratedTextField(descriptionController, maxLines: 3),
              const SizedBox(height: 12),

              // Notes Field
              buildLabel("Notes"),
              buildDecoratedTextField(notesController, maxLines: 3),
              const SizedBox(height: 20),

              // Date and Time
              Text(
                'Date & Time: ${DateFormat('yyyy-MM-dd – HH:mm').format(dateTime)}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Save Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
                          updatednotes,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Label Widget
  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  // Decorated TextField
  Widget buildDecoratedTextField(TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
