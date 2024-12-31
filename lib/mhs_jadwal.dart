import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MhsJadwal extends StatefulWidget {
  const MhsJadwal({super.key});

  @override
  State<MhsJadwal> createState() => _MhsJadwalState();
}

class _MhsJadwalState extends State<MhsJadwal> {
  int selectedDayIndex = 0;
  final List<String> days = ["Sen", "Sel", "Rab", "Kam", "Jum"];
  Map<String, dynamic> schedule = {};
  String? urlApi;
  int? idMahasiswa;
  bool isLoading = true;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void dispose() {
    isInitialized = false; // Prevent any future setState calls
    super.dispose();
  }

  Future<void> initializeData() async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUrlApi = prefs.getString('urlApi');
      final storedidMahasiswa = prefs.getInt('id_mahasiswa');

      if (!mounted) return;

      if (storedUrlApi != null && storedidMahasiswa != null) {
        setState(() {
          urlApi = storedUrlApi;
          idMahasiswa = storedidMahasiswa;
          isInitialized = true;
        });
        await fetchSchedule();
      } else {
        setState(() {
          isLoading = false;
          isInitialized = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isInitialized = true;
      });
      debugPrint('Error initializing data: $e');
    }
  }

  Future<void> fetchSchedule() async {
    if (!mounted || !isInitialized || urlApi == null || idMahasiswa == null)
      return;

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
            '$urlApi/potensi_api/jadwal_mahasiswa.php?id_mahasiswa=$idMahasiswa'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data['jadwal'] != null) {
            // Convert the keys to match your days array
            final Map<String, dynamic> formattedSchedule = {
              'Sen': data['jadwal']['Senin'] ?? [],
              'Sel': data['jadwal']['Selasa'] ?? [],
              'Rab': data['jadwal']['Rabu'] ?? [],
              'Kam': data['jadwal']['Kamis'] ?? [],
              'Jum': data['jadwal']['Jumat'] ?? []
            };
            schedule = formattedSchedule;
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        debugPrint('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching schedule: $e');
    }
  }

  List<DateTime> getDatesInWeek() {
    DateTime now = DateTime.now();
    int currentWeekDay = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekDay - 1));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  Widget buildScheduleList() {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (urlApi == null || idMahasiswa == null) {
      return const Center(child: Text('Configuration missing'));
    }

    String selectedDay = days[selectedDayIndex];
    List<dynamic> selectedDaySchedule = schedule[selectedDay] ?? [];

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (selectedDaySchedule.isEmpty) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/empty_schedule.png',
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          const Text(
            'Tidak ada kelas',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xff023047)),
          )
        ],
      ));
    }

    return ListView.builder(
      itemCount: selectedDaySchedule.length,
      itemBuilder: (context, index) =>
          buildScheduleCard(selectedDaySchedule[index]),
    );
  }

  Widget buildScheduleCard(dynamic item) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(64, 85, 198, 255),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item['nama_dosen'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: const Color(0xff023047),
                      fontSize: textScale * 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                truncateText(item['nama_mata_kuliah'] ?? '', 20),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontSize: textScale * 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ruang',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: const Color.fromARGB(255, 74, 74, 74),
                          fontSize: textScale * 12,
                        ),
                      ),
                      Text(
                        truncateText(item['nama_ruang'] ?? '', 10),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontSize: textScale * 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildTimeColumn(
                          'Mulai', item['jam_awal'] ?? '', textScale),
                      SizedBox(width: screenWidth * 0.06),
                      _buildTimeColumn(
                          'Selesai', item['jam_akhir'] ?? '', textScale),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time, double textScale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: const Color.fromARGB(255, 74, 74, 74),
            fontSize: textScale * 12,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: textScale * 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> datesInWeek = getDatesInWeek();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/bgkelas.jpg'),
                  colorFilter: ColorFilter.mode(
                    Color.fromARGB(65, 0, 0, 0),
                    BlendMode.darken,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.06),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: Text(
                        'Jadwal Mata Kuliah',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 30.0 * textScale,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: screenHeight * 0.68,
            decoration: const BoxDecoration(
              color: Color(0xfff4f4f4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 18,
                right: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(days.length, (index) {
                      String formattedDate =
                          DateFormat('dd', 'id_ID').format(datesInWeek[index]);
                      bool isSelected = selectedDayIndex == index;
                      return SizedBox(
                        height: screenHeight * 0.1,
                        width: screenWidth * 0.15,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedDayIndex = index;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : const Color(0xff023047),
                                width: 2.0,
                              ),
                            ),
                            backgroundColor: isSelected
                                ? const Color(0xff023047)
                                : Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xff023047),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: textScale * 20,
                                ),
                              ),
                              Text(
                                days[index],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xff023047),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: textScale * 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(child: buildScheduleList()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
