// ignore: file_names
import 'package:flutter/material.dart';
import 'package:potensiapp/dsn_home.dart';
import 'package:potensiapp/dsn_jadwal.dart';
import 'package:potensiapp/dsn_kelas.dart';
import 'package:potensiapp/dsn_profile.dart';

void main() => runApp(const DsnMain());

class DsnMain extends StatelessWidget {
  const DsnMain({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: const Color(0xfff4f4f4),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          DsnHome(setPage: setPage),
          const DsnKelas(),
          const DsnJadwal(),
          const DsnProfile(),
        ], // Mencegah swipe manual
      ),
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
