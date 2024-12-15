import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_what_todo/firestore.dart';
import 'package:fp_what_todo/input_page.dart';
import 'package:intl/intl.dart';
import 'list_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  int tasksCompleted = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activities'),
        backgroundColor: const Color.fromARGB(255, 237, 247, 246),
      ),
      backgroundColor: const Color.fromARGB(255, 237, 247, 246),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getActivities(),
        builder: (context, snapshot) {
          final activities = snapshot.data!.docs;
          List completedActivities = activities.where((activity) => activity['completed'] == true).toList();
          List flaggedActivities = activities.where((activity) => activity['flagged'] == true).toList();
      
          return SingleChildScrollView(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!snapshot.hasData || snapshot.data!.docs.isNotEmpty)
                    Container(
                      width: double.infinity, // Lebar kontainer penuh layar
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What's coming next?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(
                            builder: (context) { // Urutkan aktivitas
                              final nearestActivity = activities.first;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nearestActivity['title'] ?? 'No Title',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow
                                          .ellipsis, // Potong teks jika terlalu panjang
                                    ),
                                    maxLines: 1, // Maksimal 1 baris
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('yyyy-MM-dd – HH:mm').format(
                                    (nearestActivity['dateTime'] as Timestamp).toDate(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity, // Lebar kontainer penuh layar
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "You Don't Have Any Activities",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'List',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ListActivityPage()));
                          },
                          child: const Text(
                            'See All',
                            style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InfoCard(
                        title: 'Total Tasks', value: activities.length.toString()),
                      InfoCard(
                        title: 'Progress',
                        value: '${completedActivities.length}/${activities.length}'),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Flagged Task',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    ),
                  ),
                  if (flaggedActivities.isNotEmpty)
                    Container(
                      height: 230,
                      margin: EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: ListView.builder(
                        itemCount: flaggedActivities.length,
                        itemBuilder: (context, index) {
                          final flaggedActivity = flaggedActivities[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailActivityPage(
                                    activityId: flaggedActivity.id,
                                    initialtitle: flaggedActivity['title'],
                                    initiallocation: flaggedActivity['location'],
                                    initialdescription: flaggedActivity['description'],
                                    initialnotes: flaggedActivity['notes'],
                                    initialdateTime: flaggedActivity['dateTime'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.redAccent, Colors.red],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        flaggedActivity['title'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.white70,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat('HH:mm').format(
                                              (flaggedActivity['dateTime'] as Timestamp).toDate(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]),
                      child: const Center(
                        child: Text(
                          "No flagged tasks yet.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                ],
              )
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddActivityPage()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
