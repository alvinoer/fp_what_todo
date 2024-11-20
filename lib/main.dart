import 'package:flutter/material.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: InputPage(),
    );
  }
}

// Model aktivitas
class Activity {
  String name;
  String time;
  String details;
  String note;

  Activity({
    required this.name,
    required this.time,
    required this.details,
    required this.note,
  });
}

// Halaman Input Aktivitas
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

// Halaman Daftar Aktivitas
class ListPage extends StatefulWidget {
  final List<Activity> activities;

  ListPage({required this.activities});

  @override
  _ListPageState createState() => _ListPageState(); // Wajib diimplementasikan
  }

  class _ListPageState extends State<ListPage> {
    late List<Activity> activities;

    @override
    void initState() {
    super.initState();
    // Salin data dari widget ke state lokal
    activities = widget.activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Aktivitas"),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.name),
            subtitle: Text(activity.time),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    activity: activity,
                    onDelete: () {
                      setState(() {
                        activities.removeAt(index);
                      });
                    },
                  ),
                ),
              );
              if (result == true) {
                setState(() {});
              }
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  activities.removeAt(index);
                });
              },
            ),
          );
        },
      ),
    );
  }
}

// Halaman Detail Aktivitas
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