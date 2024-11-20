// pages/input_page.dart
import 'package:flutter/material.dart';
import 'list_page.dart';
import 'activity.dart'; // File model (lihat poin 3)

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final List<Activity> activities = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void addActivity() {
    if (nameController.text.isNotEmpty &&
        timeController.text.isNotEmpty &&
        detailsController.text.isNotEmpty) {
      setState(() {
        activities.add(
          Activity(
            name: nameController.text,
            time: timeController.text,
            details: detailsController.text,
            note: noteController.text,
          ),
        );
      });
      nameController.clear();
      timeController.clear();
      detailsController.clear();
      noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Aktivitas Anda"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Masukkan nama kegiatan anda"),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(labelText: "Masukkan jam kegiatan anda"),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: "Masukkan detail kegiatan anda"),
            ),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: "Masukkan note tambahan"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addActivity,
              child: Text("Tambahkan Aktivitas"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListPage(activities: activities),
                  ),
                );
              },
              child: Text("Lihat Aktivitas"),
            ),
          ],
        ),
      ),
    );
  }
}
