import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Rekap(),
  ));
}

class Rekap extends StatefulWidget {
  const Rekap({super.key});

  @override
  State<Rekap> createState() => _RekapState();
}

class _RekapState extends State<Rekap> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Color.fromARGB(70, 0, 0, 0), BlendMode.darken),
                        image: AssetImage('images/bgapproval.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.white),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          SizedBox(
                            width: screenWidth * 0.6,
                            child: Text(
                              'Rekap Presensi',
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
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.75,
              decoration: const BoxDecoration(
                color: Color(0xfff4f4f4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 28,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detail Rekap',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18 * textScale,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: screenHeight * 0.35,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Semester 1',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16 * textScale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.005,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.032,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(35))),
                                          builder: (BuildContext context) {
                                            return SizedBox(
                                              height: screenHeight * 0.3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 25),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(Icons
                                                              .arrow_back_ios_new_rounded),
                                                          iconSize: 26,
                                                        ),
                                                        const Text(
                                                          'Filter by',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          screenHeight * 0.01,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .trending_up_rounded,
                                                                size: 20,
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    screenWidth *
                                                                        0.040,
                                                              ),
                                                              const Text(
                                                                'Semester',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SemesterDropdown()
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          screenHeight * 0.03,
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height:
                                                          screenHeight * 0.05,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xffFB8500)),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            'Simpan',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff023047),
                                    ),
                                    child: Text(
                                      'Filter',
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 11 * textScale,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.004,
                                ),
                                const Icon(
                                  Icons.filter_alt_outlined,
                                  color: Color(0xff023047),
                                  size: 32,
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            SizedBox(
                              height: screenHeight * 0.2,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 10,
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                            toY: 5,
                                            color: const Color(0xffFFB703),
                                            width: screenWidth * 0.15,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                            toY: 2,
                                            color: const Color(0xffFFB703),
                                            width: screenWidth * 0.15,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 2,
                                      barRods: [
                                        BarChartRodData(
                                            toY: 1,
                                            color: const Color(0xffFFB703),
                                            width: screenWidth * 0.15,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5))),
                                      ],
                                    ),
                                  ],
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                                fontSize: 12 * textScale,
                                                fontFamily: 'Poppins',
                                                color: Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget:
                                            (double value, TitleMeta meta) {
                                          switch (value.toInt()) {
                                            case 0:
                                              return Text(
                                                'Sakit',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12 * textScale,
                                                    color: Colors.grey),
                                              );
                                            case 1:
                                              return Text(
                                                'Izin',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12 * textScale,
                                                    color: Colors.grey),
                                              );
                                            case 2:
                                              return Text(
                                                'Alpha',
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12 * textScale,
                                                    color: Colors.grey),
                                              );
                                            default:
                                              return const Text('');
                                          }
                                        },
                                      ),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Data Rekap',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18 * textScale,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.11,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hadir',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14 * textScale,
                                        color: const Color(0xff919191),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '50',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 32 * textScale,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.11,
                            alignment: Alignment.topCenter,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Tidak Hadir',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14 * textScale,
                                        color: const Color(0xff919191),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '8',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 32 * textScale,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        'Hasil',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18 * textScale,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(116, 124, 255, 98),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border(
                          top: BorderSide(color: Color(0xff005807), width: 2),
                          bottom:
                              BorderSide(color: Color(0xff005807), width: 2),
                          left: BorderSide(color: Color(0xff005807), width: 2),
                          right: BorderSide(color: Color(0xff005807), width: 2),
                        ),
                      ),
                      height: screenHeight * 0.07,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff005807),
                              size: 32,
                            ),
                            SizedBox(
                              width: screenWidth * 0.001,
                            ),
                            Text(
                              'Anda dinyatakan Aman',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14 * textScale,
                                  color: const Color(0xff005807),
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SemesterDropdown extends StatefulWidget {
  const SemesterDropdown({super.key});

  @override
  State<SemesterDropdown> createState() => _SemesterDropdownState();
}

class _SemesterDropdownState extends State<SemesterDropdown> {
  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8'
  ];

  // Nilai default dropdown
  String? _selectedSemester = 'Semester 1';
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.05,
      decoration: const BoxDecoration(
        color: Color(0xffE9E9E9),
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              "Pilih Semester",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14 * textScale,
                fontWeight: FontWeight.w600,
              ),
            ),
            value: _selectedSemester,
            borderRadius: BorderRadius.circular(10),
            style: TextStyle(fontSize: 12 * textScale, color: Colors.black),
            padding: const EdgeInsets.all(0),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSemester = newValue;
              });
            },
            items: _semesters.map<DropdownMenuItem<String>>((String semester) {
              return DropdownMenuItem<String>(
                value: semester,
                child: Text(semester),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
