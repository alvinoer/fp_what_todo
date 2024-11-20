// pages/list_page.dart
import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'activity.dart'; // File model (lihat poin 3)

class ListPage extends StatefulWidget {
  final List<Activity> activities;

  ListPage({required this.activities});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Activity> activities;

  @override
  void initState() {
    super.initState();
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
