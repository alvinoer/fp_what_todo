import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';
import 'detail_page.dart';

class ListActivityPage extends StatefulWidget {
  const ListActivityPage({super.key});

  @override
  State<ListActivityPage> createState() => _ListActivityPageState();
}

class _ListActivityPageState extends State<ListActivityPage> {
  final FirestoreService _firestoreService = FirestoreService();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> months = List.generate(12, (index) => DateFormat('MMMM').format(DateTime(2024, index + 1)));    List<int> years = List.generate(5, (index) => DateTime.now().year + index);
    
  String selectedMonth = DateFormat('MMMM').format(DateTime.now());
  int selectedYear = DateTime.now().year;

  List<int> getDaysInMonth() {
    DateTime firstDay = DateTime(selectedYear, months.indexOf(selectedMonth) + 1, 1);
    DateTime lastDay = DateTime(selectedYear, months.indexOf(selectedMonth) + 2, 0);
    return List.generate(lastDay.day, (index) => index + 1);
  }

  String getDayName(int day) {
    DateTime date = DateTime(selectedYear, months.indexOf(selectedMonth) + 1, day);
    return DateFormat('EEE').format(date); // Short weekday name
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 247, 246),
      appBar: AppBar(
        title: const Text('Activity List'),
        backgroundColor: Color.fromARGB(255, 147, 185, 255),
      ),
      body: Column(
        children: [
          // Dropdown untuk bulan dan tahun
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 147, 185, 255), Color.fromARGB(255, 74, 123, 219)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20), // Sudut kiri bawah melengkung
                bottomRight: Radius.circular(20), // Sudut kanan bawah melengkung
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DropdownButton<int>(
                      value: selectedYear,
                      items: years.map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(
                          '$year',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )).toList(),
                      onChanged: (value) => setState(() => selectedYear = value!),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<String>(
                      value: selectedMonth,
                      items: months.map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          month,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      )).toList(),
                      onChanged: (value) => setState(() => selectedMonth = value!),
                    ),
                  ],
                ),
                // Scroll Horizontal untuk Pemilihan Tanggal
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: getDaysInMonth().map((day) {
                      bool isSelected = day == selectedDate.day;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = DateTime(
                              selectedYear,
                              months.indexOf(selectedMonth) + 1,
                              day,
                            );
                          });
                        },
                        child: Container(
                          height: 26,
                          width: 50,
                          margin: const EdgeInsets.fromLTRB(7, 6, 7, 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color.fromARGB(255, 0, 74, 173)
                                : const Color.fromARGB(255, 158, 187, 225),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getDayName(day),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // List Aktivitas berdasarkan tanggal terpilih
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No activities found.'));
                }

                // Filter aktivitas berdasarkan tanggal terpilih
                final activities = snapshot.data!.docs.where((activity) {
                  final activityDate =
                      (activity['dateTime'] as Timestamp).toDate();
                  return activityDate.year == selectedDate.year &&
                      activityDate.month == selectedDate.month &&
                      activityDate.day == selectedDate.day;
                }).toList();

                return activities.isEmpty
                    ? const Center(child: Text('No activities for this day.'))
                    : ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailActivityPage(
                                    activityId: activity.id,
                                    initialtitle: activity['title'],
                                    initiallocation: activity['location'],
                                    initialdescription: activity['description'],
                                    initialnotes: activity['notes'],
                                    initialdateTime: activity['dateTime'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color.fromARGB(255, 147, 185, 255), Color.fromARGB(255, 74, 123, 219)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Checkbox
                                  Checkbox(
                                    value: activity['completed'] ?? false,
                                    onChanged: (value) async {
                                      await _firestoreService.updateActivityStatus(
                                        activity.id, value ?? false,
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(width: 10,),
                                  // Informasi Aktivitas
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activity['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '${activity['location']}, ${DateFormat('HH:mm').format((activity['dateTime'] as Timestamp).toDate())}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Tombol Flag dan Hapus
                                  IconButton(
                                    icon: Icon(
                                      activity['flagged'] == true
                                          ? Icons.flag
                                          : Icons.outlined_flag,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await _firestoreService.updateActivityFlag(
                                        activity.id, !(activity['flagged']),
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () async {
                                      await _firestoreService.deleteActivity(activity.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}
