import 'package:flutter/material.dart';
import 'package:potensiapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MhsProfile extends StatefulWidget {
  const MhsProfile({super.key});

  @override
  State<MhsProfile> createState() => _MhsProfileState();
}

class _MhsProfileState extends State<MhsProfile> {
  int? idMahasiswa;
  int? nim;
  String? nama;
  String? email;
  String? password;
  String? noHp;
  String? role;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idMahasiswa = prefs.getInt('id_mahasiswa');
      nim = prefs.getInt('nim');
      nama = prefs.getString('nama');
      email = prefs.getString('email');
      password = prefs.getString('password');
      noHp = prefs.getString('no_hp');
      role = prefs.getString('role');
    });
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
                  height: screenHeight * 0.35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bghome.jpg'),
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
                          height: screenHeight * 0.04,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 32.0 * textScale,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('images/user.png'),
                              radius: 45,
                            ),
                            SizedBox(
                              width: screenWidth * 0.04,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.6,
                                  child: Text(
                                    '$nama',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20.0 * textScale,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff023047),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4),
                                    child: Text(
                                      '$role'.toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ],
                            )
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
            height: screenHeight * 0.65,
            decoration: const BoxDecoration(
              color: Color(0xfff4f4f4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 18,
                right: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Akun',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.0 * textScale,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    'Nomor Induk Mahasiswa (NIM)',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0 * textScale,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '$nim',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0 * textScale,
                          color: const Color(0xff6d6d6d),
                          fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // Adjust border radius as needed
                        borderSide: const BorderSide(
                            color: Colors.grey), // Set border color to grey
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when focused
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.black), // Text color inside the TextField
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    'Nomor Telepon',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0 * textScale,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '$noHp',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0 * textScale,
                          color: const Color(0xff6d6d6d),
                          fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // Adjust border radius as needed
                        borderSide: const BorderSide(
                            color: Colors.grey), // Set border color to grey
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when focused
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.black), // Text color inside the TextField
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.0 * textScale,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: '$email',
                      hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0 * textScale,
                          color: const Color(0xff6d6d6d),
                          fontWeight: FontWeight.w400),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                            16.0), // Adjust border radius as needed
                        borderSide: const BorderSide(
                            color: Colors.grey), // Set border color to grey
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(
                            color: Colors.grey), // Border color when focused
                      ),
                    ),
                    style: const TextStyle(
                        color: Colors.black), // Text color inside the TextField
                  ),
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'App Version',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15 * textScale,
                              color: const Color(0xffc9c9c9),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'V 1.0.0',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.0 * textScale,
                              color: const Color(0xff9b9b9b),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Splash()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffBB1F1F)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Keluar',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.0 * textScale,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
