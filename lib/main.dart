import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:potensiapp/dsn_main.dart';
import 'package:potensiapp/mhs_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Splash(),
  ));
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    double textScale = MediaQuery.of(context).textScaleFactor;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/nyoba.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 0.0),
                    child: Text(
                      'Potensi.',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 34.0 * textScale,
                        letterSpacing: 5.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 35.0),
                        child: Text(
                          'Polines Online Time Enrollment & Schedule System Integration',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0 * textScale,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(35.0, 20.0, 35.0, 0.0),
                        child: Text(
                          'v 1.0.0',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0 * textScale,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool changeTable = false; // State untuk switch
  // State untuk switch
  Future<void> login() async {
    final url = Uri.parse(
        'http://192.168.56.1/potensi_api/login.php'); // Ganti dengan URL API Anda

    final response = await http.post(
      url,
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
        'changeTable': changeTable,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (data['success']) {
      final prefs = await SharedPreferences.getInstance();
      // Login berhasil, navigasi ke halaman berdasarkan switch
      if (changeTable) {
        await prefs.setInt('id_dosen', data['user']['id_dosen']);
        await prefs.setString('nip', data['user']['nip']);
        await prefs.setString('nama_dosen', data['user']['nama_dosen']);
        await prefs.setString('email', data['user']['email']);
        await prefs.setString('password', data['user']['password']);
        await prefs.setString('no_hp', data['user']['no_hp']);
        await prefs.setString('role', data['role']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DsnMain()),
        );
      } else {
        await prefs.setInt('id_mahasiswa', data['user']['id_mahasiswa']);
        await prefs.setInt('nim', data['user']['nim']);
        await prefs.setString('nama', data['user']['nama']);
        await prefs.setString('email', data['user']['email']);
        await prefs.setString('password', data['user']['password']);
        await prefs.setString('no_hp', data['user']['no_hp']);
        await prefs.setString('role', data['role']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MhsMain()),
        );
      }
    } else {
      // Login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login.jpg'),
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(80, 0, 0, 0), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(100.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              height: screenHeight * 0.45,
              margin: const EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    child: Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        fontSize: 36.0 * textScale,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    child: Text(
                      'di Potensi',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 24.0 * textScale,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masuk',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 36.0 * textScale),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Username',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0 * textScale),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 0.0),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'eg: haydar aydin',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff023047), width: 2)),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0)),
                    ),
                  ),
                  Text(
                    'Password',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0 * textScale),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 0.0),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: '•••••••',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff023047), width: 2)),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Switch(
                            value: changeTable,
                            activeColor: const Color(0xffFB8500),
                            onChanged: (value) {
                              setState(() {
                                changeTable = value;
                              });
                            },
                          ),
                          SizedBox(
                            width: screenWidth * 0.05,
                          ),
                          Text(
                            changeTable ? "Dosen" : "Mahasiswa",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.0 * textScale,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Lupa password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0 * textScale,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.0),
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(33, 158, 188, 1),
                          minimumSize: const Size(double.infinity, 50.0)),
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0 * textScale,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
