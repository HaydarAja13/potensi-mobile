import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRDosen(),
  ));
}

class QRDosen extends StatefulWidget {
  const QRDosen({super.key});

  @override
  State<QRDosen> createState() => _QRDosenState();
}

class _QRDosenState extends State<QRDosen> {
  String kodeQR = "Loading...";
  int? idDosen;
  Map<String, dynamic>? jadwalData;
  bool isLoading = true;
  String? idJadwal;

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
    });
  }

  Future<void> loadDataAndFetchJadwal() async {
    final prefs = await SharedPreferences.getInstance();
    idDosen = prefs.getInt('id_dosen');
    if (idDosen != null) {
      await fetchJadwal(idDosen!);
      if (idJadwal != null) {
        await fetchKodeQR();
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchJadwal(int idUser) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.56.1/potensi_api/fetch_jadwal.php'),
        body: {'id_user': idUser.toString()},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response API: $data');
        if (data['status'] == 'success') {
          setState(() {
            jadwalData = data['data'];
            isLoading = false;
            idJadwal = data['data']['kelas_berlangsung'][0]['id'];
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

  Future<void> fetchKodeQR() async {
    final url = Uri.parse(
        'http://192.168.56.1/potensi_api/kode_qr.php'); // Ganti dengan URL API Anda
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_jadwal': idJadwal}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            kodeQR = data['kode_qr'];
          });
        } else {
          setState(() {
            kodeQR = "Error: ${data['message']}";
          });
        }
      } else {
        setState(() {
          kodeQR = "Error: Server returned status ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        kodeQR = "Error: $e";
      });
    }
  }

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
                    height: screenHeight * 0.4,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/qrbg.jpg'),
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
                          Text(
                            jadwalData?['kelas_berlangsung']?[0]
                                    ?['nama_mata_kuliah'] ??
                                '',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28.0 * textScale,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(204, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 28),
                                  child: Text(
                                    jadwalData?['kelas_berlangsung']?[0]
                                            ?['kelas'] ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0 * textScale,
                                      color: const Color(0xff023047),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 25),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(204, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 28),
                                  child: Text(
                                    '${jadwalData?['kelas_berlangsung']?[0]?['jam_awal'] ?? ''} - '
                                    '${jadwalData?['kelas_berlangsung']?[0]?['jam_akhir'] ?? ''}',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0 * textScale,
                                      color: const Color(0xff023047),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
              height: screenHeight * 0.7,
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(30, 0, 0, 0),
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.fmd_good_sharp,
                                    size: 36,
                                    color: Color(0xff00496D),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ruangan',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: const Color(0xff023047),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        jadwalData?['kelas_berlangsung']?[0]
                                                ?['ruang'] ??
                                            '',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: const Color(0xff023047),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(30, 0, 0, 0),
                                    offset: Offset(0, 4),
                                    blurRadius: 8,
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.groups_2_rounded,
                                    size: 36,
                                    color: Color(0xff00496D),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mahasiswa',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: const Color(0xff023047),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '23',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: const Color(0xff023047),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.3,
                            margin: const EdgeInsets.only(top: 30, bottom: 20),
                            padding: const EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.010,
                                ),
                                Center(
                                  child: QrImageView(
                                    data:
                                        "http://192.168.56.1/api/approval_process.php?kode_qr=$kodeQR&id_jadwal=$idJadwal&status=1",
                                    version: QrVersions.auto,
                                    size: 230.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            child: Container(
                              width: screenWidth * 0.3,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Pindai',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 15),
                      child: Text(
                        'Data Presensi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0 * textScale,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SizedBox(
                              child: _buildTextCard('Hadir', '23'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              child: _buildTextCard('Tidak Hadir', '0'),
                            ),
                          ),
                        ),
                      ],
                    ),
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

Widget _buildTextCard(String title, String count) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ]),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff919191),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
