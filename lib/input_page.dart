import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firestore.dart';

class AddActivityPage extends StatefulWidget {
  const AddActivityPage({super.key});

  @override
  State<AddActivityPage> createState() => _AddActivityPageState();
}

class _AddActivityPageState extends State<AddActivityPage> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> months = List.generate(12, (index) => DateFormat('MMMM').format(DateTime(2024, index + 1)));
  List<int> years = List.generate(5, (index) => DateTime.now().year + index);
  
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
      appBar: AppBar(
        title: const Text('Add New Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: const Color.fromARGB(255, 237, 247, 246),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16), // Sudut kiri bawah melengkung
                  bottomRight: Radius.circular(16), // Sudut kanan bawah melengkung
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
                  _buildSectionContainer('Title', _titleController),
                  _buildSectionContainer('Location', _locationController),
                  _buildSectionContainer('Description', _descriptionController, maxLines: 3),
                  _buildSectionContainer('Notes', _notesController, maxLines: 2),
                ],
              ),
            ),
            const SizedBox(height: 16),


           Container(
              padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Section
                  const Text('Select Date', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: selectedMonth,
                        items: months.map((month) => DropdownMenuItem(value: month, child: Text(month))).toList(),
                        onChanged: (value) => setState(() => selectedMonth = value!),
                      ),
                      const SizedBox(width: 20),
                      DropdownButton<int>(
                        value: selectedYear,
                        items: years.map((year) => DropdownMenuItem(value: year, child: Text('$year'))).toList(),
                        onChanged: (value) => setState(() => selectedYear = value!),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: getDaysInMonth().map((day) {
                        bool isSelected = day == selectedDate.day;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = DateTime(selectedYear, months.indexOf(selectedMonth) + 1, day);
                            });
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Color.fromARGB(255, 0, 74, 173) : Color.fromARGB(255, 158, 187, 225),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getDayName(day),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.black,
                                  ),
                                ),
                                Text(
                                  '$day',
                                  style: TextStyle(
                                    fontSize: 25,
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
                  const SizedBox(height: 16),

                  // Time Section
                  const Text('Select Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 60,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(7, 8, 7, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Color.fromARGB(255, 158, 187, 225),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (index) {
                              setState(() => selectedTime = TimeOfDay(hour: index, minute: selectedTime.minute));
                            },
                            itemExtent: 40,
                            perspective: 0.005,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 24,
                              builder: (context, index) {
                                bool isSelected = index == selectedTime.hour;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Text('Hr', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 100,
                        width: 60,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(7, 8, 7, 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            color: Color.fromARGB(255, 158, 187, 225),
                          ),
                          child: ListWheelScrollView.useDelegate(
                            onSelectedItemChanged: (index) {
                              setState(() => selectedTime = TimeOfDay(hour: selectedTime.hour, minute: index));
                            },
                            itemExtent: 40,
                            perspective: 0.005,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 60,
                              builder: (context, index) {
                                bool isSelected = index == selectedTime.minute;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isSelected ? Colors.white : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const Text('Min', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Save Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (_titleController.text.isNotEmpty) {
                    DateTime dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    
                    final title = _titleController.text;
                    final location = _locationController.text;
                    final description = _descriptionController.text;
                    final notes = _notesController.text;
                    
                    await _firestoreService.createActivity(
                      title,
                      location,
                      description,
                      notes,
                      dateTime
                      );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save Activity',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ubah warna teks menjadi putih
              shadows: [
                Shadow(
                  offset: Offset(2, 2), // Jarak bayangan ke bawah dan ke kanan
                  blurRadius: 4, // Efek kabur pada bayangan
                  color: Colors.black54, // Warna bayangan
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
