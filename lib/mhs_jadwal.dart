import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MhsJadwal extends StatefulWidget {
  const MhsJadwal({super.key});

  @override
  _MhsJadwalState createState() => _MhsJadwalState();
}

class _MhsJadwalState extends State<MhsJadwal> {
  late Future<Map<String, dynamic>> futureJadwal;
  String selectedDay = 'Senin';
  String? studentName;
  bool isLoading = true;
  int? idMahasiswa;
  String? urlApi;

  @override
  void initState() {
    super.initState();
    futureJadwal = fetchJadwal();
  }

  Future<Map<String, dynamic>> fetchJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idMahasiswa = prefs.getInt('id_mahasiswa');
      urlApi = prefs.getString('urlApi');
    });
    final response = await http.get(
      Uri.parse(
          '$urlApi/potensi_api/jadwal_mahasiswa.php?id_mahasiswa=$idMahasiswa'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureJadwal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!['jadwal'] != null) {
            final data = snapshot.data!;
            final jadwal = data['jadwal'];

            String currentDate =
                DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now());

            return Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 40),
                  _buildCurrentDate(currentDate),
                  const SizedBox(height: 10),
                  _buildDayButtons(jadwal),
                  const SizedBox(height: 10),
                  _buildTimelineHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: MhsScheduleDay(
                        day: selectedDay,
                        scheduleData: jadwal[selectedDay] ?? [],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 270,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bgjadwal.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Jadwal Mahasiswa',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCurrentDate(String currentDate) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: Text(
        currentDate,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: const Text(
        'Timeline',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildDayButtons(Map<String, dynamic> jadwal) {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _dayButton(DateFormat('d', 'id_ID').format(monday), "Senin",
            selectedDay == "Senin", jadwal["Senin"] ?? []),
        _dayButton(
            DateFormat('d', 'id_ID')
                .format(monday.add(const Duration(days: 1))),
            "Selasa",
            selectedDay == "Selasa",
            jadwal["Selasa"] ?? []),
        _dayButton(
            DateFormat('d', 'id_ID')
                .format(monday.add(const Duration(days: 2))),
            "Rabu",
            selectedDay == "Rabu",
            jadwal["Rabu"] ?? []),
        _dayButton(
            DateFormat('d', 'id_ID')
                .format(monday.add(const Duration(days: 3))),
            "Kamis",
            selectedDay == "Kamis",
            jadwal["Kamis"] ?? []),
        _dayButton(
            DateFormat('d', 'id_ID')
                .format(monday.add(const Duration(days: 4))),
            "Jumat",
            selectedDay == "Jumat",
            jadwal["Jumat"] ?? []),
      ],
    );
  }

  Widget _dayButton(
      String date, String dayName, bool isSelected, List<dynamic> schedule) {
    int courseCount = schedule.length;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = dayName; // Update the selected day
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 9, 51, 85)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color.fromARGB(255, 0, 51, 93)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              if (courseCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$courseCount',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class MhsScheduleDay extends StatelessWidget {
  final String day;
  final List<dynamic> scheduleData;

  const MhsScheduleDay(
      {super.key, required this.day, required this.scheduleData});

  @override
  Widget build(BuildContext context) {
    final List<Color> cardColors = [
      Colors.white,
    ];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: scheduleData.asMap().entries.map((entry) {
          final index = entry.key;
          final course = entry.value;
          return Card(
            elevation: 4,
            color: cardColors[
                index % cardColors.length], // Pilih warna berdasarkan indeks
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['nama_mata_kuliah'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.meeting_room, size: 18),
                      const SizedBox(width: 8),
                      Text(course['nama_ruang']),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18),
                      const SizedBox(width: 8),
                      Text('${course['jam_awal']} - ${course['jam_akhir']}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.school, size: 18),
                      const SizedBox(width: 8),
                      Text('${course['nama_dosen']}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ScheduleTile extends StatelessWidget {
  final String courseName;
  final String room;
  final String time;
  final String className;

  const ScheduleTile({
    super.key,
    required this.courseName,
    required this.room,
    required this.time,
    required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        alignment: Alignment.center, // Untuk penempatan di tengah
        child: Text(
          courseName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.meeting_room,
                  size: 18, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 12),
              Text(
                room,
                style: const TextStyle(
                    color: Colors.black87, fontFamily: 'Poppins'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time,
                  size: 18, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 12),
              Text(
                time,
                style: const TextStyle(
                    color: Colors.black87, fontFamily: 'Poppins'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.class_,
                  size: 18, color: Color.fromARGB(255, 0, 0, 0)),
              const SizedBox(width: 12),
              Text(
                className,
                style: const TextStyle(
                    color: Colors.black87, fontFamily: 'Poppins'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
