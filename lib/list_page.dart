// list_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'detail_page.dart';
import 'activity.dart';

class ListPage extends StatefulWidget {
  final List<Activity> activities;

  ListPage({required this.activities});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Activity> activities;

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "Tidak ada pengingat";
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    activities = widget.activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Aktivitas (${activities.length})"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, activities);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            title: Text(activity.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Jam: ${activity.time}"),
                Text("Pengingat: ${formatDateTime(activity.reminder)}"),
              ],
            ),
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
