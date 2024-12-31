import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potensiapp/mhs_rekap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MhsHome extends StatefulWidget {
  const MhsHome({super.key, required this.setPage});
  final Function(int) setPage;

  @override
  State<MhsHome> createState() => _MhsHomeState();
}

class _MhsHomeState extends State<MhsHome> {
  int? idMahasiswa;
  int? nim;
  String? nama;
  String? email;
  String? password;
  String? noHp;
  String? role;
  Map<String, dynamic>? jadwalData;
  bool isLoading = true;
  String? urlApi;

  @override
  void initState() {
    super.initState();
    loadData();
    loadDataAndFetchJadwal();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idMahasiswa = prefs.getInt('id_mahasiswa');
      nama = prefs.getString('nama');
      email = prefs.getString('email');
      password = prefs.getString('password');
      noHp = prefs.getString('noHp');
      role = prefs.getString('role');
      urlApi = prefs.getString('urlApi');
    });
  }

  Future<void> loadDataAndFetchJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    idMahasiswa = prefs.getInt('id_mahasiswa');
    if (idMahasiswa != null) {
      await fetchJadwal(idMahasiswa!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchJadwal(int idMahasiswa) async {
    try {
      final response = await http.post(
        Uri.parse('$urlApi/potensi_api/fetch_jadwal_mahasiswa.php'),
        body: {'id_mahasiswa': idMahasiswa.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response API: $data');
        if (data['status'] == 'success') {
          setState(() {
            jadwalData = data['data'];
            isLoading = false;
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String duaKalimat(String input) {
    List<String> words = input.split(' ');
    if (words.length > 2) {
      return words.sublist(0, 2).join(' ');
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight * 0.7,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bghome.jpg'),
                      colorFilter: ColorFilter.mode(
                          Color.fromARGB(80, 0, 0, 0), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Pagi',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16.0 * textScale,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  duaKalimat('$nama'),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22.0 * textScale,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    widget.setPage(3);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder()),
                                  child: const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/user.png'),
                                    radius: 25,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: jadwalData != null &&
                                  jadwalData!['kelas_berlangsung'] != null &&
                                  jadwalData!['kelas_berlangsung'].isNotEmpty
                              ? Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  color: Colors.white,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffFB8500),
                                              radius: 35,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    50)),
                                                        color: const Color(
                                                                0xffFFB703)
                                                            .withOpacity(0.4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2.0,
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          'On Going',
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xffFB8500),
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize:
                                                                11 * textScale,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: SizedBox(
                                                        width: screenWidth * 20,
                                                        child: Text(
                                                          '${jadwalData!['kelas_berlangsung'][0]['nama_mata_kuliah']}',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 13.0 *
                                                                textScale,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xfff0f0f0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        7),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        7),
                                                              ),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                '${jadwalData!['kelas_berlangsung'][0]['kelas']}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 10 *
                                                                        textScale),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xfff0f0f0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        7),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                '${jadwalData!['kelas_berlangsung'][0]['ruang']}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 10 *
                                                                        textScale),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 35,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    '${jadwalData!['kelas_berlangsung'][0]['jam_awal']} - ${jadwalData!['kelas_berlangsung'][0]['jam_akhir']}',
                                                    style: TextStyle(
                                                        fontSize:
                                                            12 * textScale,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  color: Colors.white,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Tidak ada Kelas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        Text(
                          'Kelas Selanjutnya',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0 * textScale,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: jadwalData != null &&
                                  jadwalData!['kelas_akan_datang'] != null &&
                                  jadwalData!['kelas_akan_datang'].isNotEmpty
                              ? Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  color: Colors.white,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff999999),
                                              radius: 35,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    50)),
                                                        color: const Color(
                                                                0xffc2c2c2)
                                                            .withOpacity(0.4),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2.0,
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          'Selanjutnya',
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xff858585),
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize:
                                                                11 * textScale,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: SizedBox(
                                                        width: screenWidth * 20,
                                                        child: Text(
                                                          'Pemrog. Visual',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 13.0 *
                                                                  textScale,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xfff0f0f0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        7),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        7),
                                                              ),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                'TI-2A',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 10 *
                                                                        textScale),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xfff0f0f0),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        7),
                                                                bottomRight:
                                                                    Radius
                                                                        .circular(
                                                                            7),
                                                              ),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3.0,
                                                                      horizontal:
                                                                          8.0),
                                                              child: Text(
                                                                'MST III/03',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins',
                                                                    fontSize: 10 *
                                                                        textScale),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 35,
                                                  color: Color(0xff737373),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child: Text(
                                                    '08.30 - 11.50',
                                                    style: TextStyle(
                                                        fontSize:
                                                            12 * textScale,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xff737373)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Card(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  color: Colors.white,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      'Tidak ada Kelas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
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
            height: screenHeight * 0.45,
            decoration: const BoxDecoration(
              color: Color(0xfff4f4f4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            hintText: 'Cari',
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins',
                                fontSize: 16 * textScale),
                            isDense: true,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(0),
                              child: Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 0.0),
                              child: Text(
                                'Menu',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14 * textScale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                buildElevatedButton(
                                    Icons.menu_book_rounded, "Rekap", () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Rekap()),
                                  );
                                }),
                                buildElevatedButton(Icons.work_outline, "Kelas",
                                    () {
                                  widget.setPage(1);
                                }),
                                buildElevatedButton(
                                    Icons.calendar_today_outlined, "Jadwal",
                                    () {
                                  widget.setPage(2);
                                }),
                                buildElevatedButton(
                                    Icons.more_horiz, "Lainnya", () {}),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 0.0),
                              child: Text(
                                'Pemberitahuan',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14 * textScale,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 0.0),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 6,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenHeight * 0.09,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Libur Natal',
                                                  style: TextStyle(
                                                    fontSize: 14 * textScale,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '31/12/2024',
                                                  style: TextStyle(
                                                    fontSize: 12 * textScale,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildElevatedButton(
    IconData icon, String label, VoidCallback onPressed) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(13),
          backgroundColor: Colors.white, // Background color of the button
          foregroundColor: Colors.orange, // Icon color
          shadowColor: Colors.black38,
          elevation: 4,
        ),
        onPressed: onPressed,
        child: Icon(
          icon,
          size: 35,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    ],
  );
}
