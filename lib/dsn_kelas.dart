import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DsnKelas extends StatefulWidget {
  const DsnKelas({super.key});

  @override
  State<DsnKelas> createState() => _DsnKelasState();
}

class _DsnKelasState extends State<DsnKelas> {
  int? idDosen;
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
      idDosen = prefs.getInt('id_dosen');
      urlApi = prefs.getString('urlApi');
    });
  }

  Future<void> loadDataAndFetchJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    idDosen = prefs.getInt('id_dosen');
    if (idDosen != null) {
      await fetchJadwal(idDosen!);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchJadwal(int idUser) async {
    if (!mounted) return;
    try {
      final response = await http.post(
        Uri.parse('$urlApi/potensi_api/fetch_jadwal.php'),
        body: {'id_user': idUser.toString()},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success' && mounted) {
          setState(() {
            jadwalData = data['data'];
          });
        } else if (data['status'] != 'success') {
          print('Error from API: ${data['message']}');
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                  height: screenHeight * 0.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bgkelas.jpg'),
                      colorFilter: ColorFilter.mode(
                          Color.fromARGB(80, 0, 0, 0), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.06,
                        ),
                        Text(
                          'Daftar Kelas',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30.0 * textScale,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Hari Ini',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 30.0 * textScale,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
                  Text(
                    'Sedang Berlangsung',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0 * textScale,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  jadwalData != null &&
                          jadwalData!['kelas_berlangsung'] != null &&
                          jadwalData!['kelas_berlangsung'].isNotEmpty
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                top: 14,
                              ),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 14,
                                  left: 14,
                                  right: 14,
                                  bottom: 22,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.6,
                                          child: Text(
                                            '${jadwalData!['kelas_berlangsung'][0]['nama_mata_kuliah']}'
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16.0 * textScale,
                                              color: const Color(0xff023047),
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.005,
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xffe2e2e2),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        child: Text(
                                          '${jadwalData!['kelas_berlangsung'][0]['ruang']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 11.0 * textScale,
                                            color: const Color(0xff888888),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${jadwalData!['kelas_berlangsung'][0]['jam_awal']}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15.0 * textScale,
                                                color: const Color(0xff023047),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Mulai',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14.0 * textScale,
                                                color: const Color(0xff023047),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${jadwalData!['kelas_berlangsung'][0]['jam_akhir']}',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15.0 * textScale,
                                                color: const Color(0xff023047),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Selesai',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14.0 * textScale,
                                                color: const Color(0xff023047),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -20,
                              left: 0,
                              right: 0,
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff023047),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    '${jadwalData!['kelas_berlangsung'][0]['sisa_waktu']}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13.0 * textScale,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Akan Datang',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18.0 * textScale,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  jadwalData != null &&
                          jadwalData!['kelas_akan_datang'] != null &&
                          jadwalData!['kelas_akan_datang'].isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(
                            top: 14,
                          ),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 14,
                              left: 14,
                              right: 14,
                              bottom: 22,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.6,
                                      child: Text(
                                        '${jadwalData!['kelas_akan_datang'][0]['nama_mata_kuliah']}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16.0 * textScale,
                                          color: const Color(0xff757575),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Color(0xffe2e2e2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    child: Text(
                                      '${jadwalData!['kelas_akan_datang'][0]['ruang']}',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11.0 * textScale,
                                        color: const Color(0xff888888),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${jadwalData!['kelas_akan_datang'][0]['jam_awal']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0 * textScale,
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Mulai',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0 * textScale,
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${jadwalData!['kelas_akan_datang'][0]['jam_akhir']}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15.0 * textScale,
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Selesai',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0 * textScale,
                                            color: const Color(0xff757575),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: Card(
                            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
        ),
      ],
    );
  }
}
