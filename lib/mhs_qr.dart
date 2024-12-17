import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  bool? isFlashOn;

  Future<void> saveToDetailPresensi({
    required String idJadwal,
    required String kode_qr,
    required String status,
  }) async {
    const String url =
        'https://localhost/potensi_api/update_detail_presensi.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id_presensi': idJadwal,
          'id_jam_a': kode_qr,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil dikirim ke server!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text("Gagal menyimpan data: ${responseData['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Error: Server mengembalikan status ${response.statusCode}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
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
                  left: 22,
                  right: 22,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          child: Container(
                            height: screenHeight * 0.5,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              child: QRView(
                                  key: qrKey,
                                  onQRViewCreated: _onQRViewCreated),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
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
                          bottom: -35,
                          left: 0,
                          right: 0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (result?.code != null) {
                                      final scannedData =
                                          result!.code!.split(';');
                                      if (scannedData.length == 5) {
                                        await saveToDetailPresensi(
                                          idJadwal: scannedData[0],
                                          kode_qr: scannedData[1],
                                          status: scannedData[2],
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Format QR code tidak valid")),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Tidak ada QR code yang dipindai")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: const Color(0xff219EBC),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (controller != null) {
                                      await controller!.toggleFlash();
                                      setState(() {
                                        isFlashOn = !(isFlashOn ?? false);
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: const Color(0xffFFB703),
                                  ),
                                  child: Icon(
                                    isFlashOn == true
                                        ? Icons.flash_on
                                        : Icons.flash_off,
                                    size: 40,
                                    color: Colors.white,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });

    controller.getFlashStatus().then((status) {
      setState(() {
        isFlashOn = status;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
