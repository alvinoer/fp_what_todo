// detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'activity.dart';

class DetailPage extends StatefulWidget {
  final Activity activity;
  final VoidCallback onDelete;

  DetailPage({required this.activity, required this.onDelete});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController nameController;
  late TextEditingController timeController;
  late TextEditingController detailsController;
  late TextEditingController noteController;

  DateTime? reminder;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Set Reminder";
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.activity.name);
    timeController = TextEditingController(text: widget.activity.time);
    detailsController = TextEditingController(text: widget.activity.details);
    noteController = TextEditingController(text: widget.activity.note);
    reminder = widget.activity.reminder;
  }

  void saveChanges() {
    setState(() {
      widget.activity.name = nameController.text;
      widget.activity.time = timeController.text;
      widget.activity.details = detailsController.text;
      widget.activity.note = noteController.text;
      widget.activity.reminder = reminder;
    });
    Navigator.pop(context, true);
  }

  void deleteActivity() {
    widget.onDelete();
    Navigator.pop(context, true);
  }

  void changeReminder() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: reminder ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminder ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          reminder = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Aktivitas"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteActivity,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Kegiatan"),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Jam Kegiatan"),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: "Detail Kegiatan"),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: "Catatan Tambahan"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: changeReminder,
              child: Text(formatDateTime(reminder)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
