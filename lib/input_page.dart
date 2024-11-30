// input_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'list_page.dart';
import 'activity.dart';

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

  DateTime? selectedReminder;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Set Reminder";
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

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
            reminder: selectedReminder,
          ),
        );
      });
      selectedReminder = null;
      nameController.clear();
      timeController.clear();
      detailsController.clear();
      noteController.clear();
    }
  }

  void setReminder() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          selectedReminder = DateTime(
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
              onPressed: setReminder, // Tombol untuk mengatur pengingat
              child: Text(formatDateTime(selectedReminder)),
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
