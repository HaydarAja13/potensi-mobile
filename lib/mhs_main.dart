// ignore: file_names
import 'package:flutter/material.dart';
import 'package:potensiapp/mhs_home.dart';
import 'package:potensiapp/mhs_jadwal.dart';
import 'package:potensiapp/mhs_kelas.dart';
import 'package:potensiapp/mhs_profile.dart';
import 'package:potensiapp/mhs_qr.dart';

class MhsMain extends StatelessWidget {
  const MhsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MhsScreen(),
    );
  }
}

class MhsScreen extends StatefulWidget {
  const MhsScreen({super.key});

  @override
  _MhsScreenState createState() => _MhsScreenState();
}

class _MhsScreenState extends State<MhsScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setPage(index);
  }

  void setPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MhsHome(setPage: setPage),
          const MhsKelas(),
          const MhsJadwal(),
          const MhsProfile(),
        ], // Mencegah swipe manual
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _selectedIndex == 0
          ? Container(
              height: 75,
              width: 75,
              margin: const EdgeInsets.only(bottom: 45),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRMahasiswa()),
                  );
                },
                backgroundColor: const Color.fromARGB(255, 3, 80, 119),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xffFFB703),
          unselectedItemColor: Colors.black,
          iconSize: 26,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Poppins',
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Kelas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
