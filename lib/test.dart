import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KodeQRPage extends StatefulWidget {
  @override
  _KodeQRPageState createState() => _KodeQRPageState();
}

class _KodeQRPageState extends State<KodeQRPage> {
  String kodeQR = "Loading...";
  final int idJadwal = 5; // Ganti dengan ID jadwal yang sesuai

  @override
  void initState() {
    super.initState();
    fetchKodeQR();
  }

  Future<void> fetchKodeQR() async {
    final url = Uri.parse(
        'http://192.168.0.118/potensi-web/api/coba.php'); // Ganti dengan URL API Anda
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Kode QR Page"),
      ),
      body: Center(
        child: Text(
          kodeQR,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
