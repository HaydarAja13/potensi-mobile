import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:potensiapp/mhs_main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QRMahasiswa(),
  ));
}

class QRMahasiswa extends StatefulWidget {
  const QRMahasiswa({super.key});

  @override
  State<QRMahasiswa> createState() => _QRMahasiswaState();
}

class _QRMahasiswaState extends State<QRMahasiswa> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  Barcode? result;
  QRViewController? controller;
  int? idMahasiswa;

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
                              _manualStopCamera();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MhsMain()),
                              );
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
                            'Pemrograman Perangkat Bergerak',
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
                                    'TI-2A',
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
                                    '07.30 - 11.30',
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
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: screenHeight * 0.5,
                          decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            child: QRView(
                                key: qrKey, onQRViewCreated: _onQRViewCreated),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: screenWidth * 0.4,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Pindai',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0 * textScale,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                  backgroundColor: const Color(0xffFFB703)),
                              child: const Icon(
                                Icons.flashlight_on_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (result != null) ...[
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _sendPostRequest(result!.code),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 12, 138)),
                        child: const Text(
                          'Absen',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      // Cetak data hasil pindai ke konsol
      print("Hasil QR Code: ${scanData.code}");
    });
  }

  Future<void> _manualStopCamera() async {
    if (controller != null) {
      await controller?.stopCamera(); // Hentikan kamera sementara
      controller?.dispose(); // Lepaskan sumber daya kamera
      print("Kamera berhasil dimatikan secara manual.");
    }
  }

  Future<void> _sendPostRequest(String? code) async {
    if (code == null) return;

    final Uri originalUrl = Uri.parse(code);
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idMahasiswa = prefs.getInt('id_mahasiswa');
    });

    final Uri updatedUrl = Uri.parse(
      "${originalUrl.toString()}&id_mahasiswa=$idMahasiswa",
    );

    final payload = jsonEncode({'id_mahasiswa': idMahasiswa});

    final response = await http.post(
      updatedUrl,
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        await controller?.stopCamera(); // Matikan kamera setelah respons sukses
        controller?.dispose();
        print("Response berhasil: ${data['message']}");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MhsMain()),
        );
      } else {
        print('Message: ${data['message']}');
      }
    } else {
      print('Failed to connect to the server');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
