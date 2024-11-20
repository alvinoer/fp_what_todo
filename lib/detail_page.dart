// pages/detail_page.dart
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.activity.name);
    timeController = TextEditingController(text: widget.activity.time);
    detailsController = TextEditingController(text: widget.activity.details);
    noteController = TextEditingController(text: widget.activity.note);
  }

  void saveChanges() {
    setState(() {
      widget.activity.name = nameController.text;
      widget.activity.time = timeController.text;
      widget.activity.details = detailsController.text;
      widget.activity.note = noteController.text;
    });
    Navigator.pop(context, true);
  }

  void deleteActivity() {
    widget.onDelete();
    Navigator.pop(context, true);
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
          )
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
              onPressed: saveChanges,
              child: Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
