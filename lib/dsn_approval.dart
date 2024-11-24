import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Approval1(),
  ));
}

class Approval1 extends StatefulWidget {
  const Approval1({super.key});

  @override
  State<Approval1> createState() => _Approval1State();
}

class _Approval1State extends State<Approval1> {
  List<bool> checkboxStatus = List<bool>.filled(6, false);
  String _dropdownValue = "Hadir";
  final _items = ['Hadir', 'Tidak hadir'];
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
                    height: screenHeight * 0.35,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Color.fromARGB(70, 0, 0, 0), BlendMode.darken),
                        image: AssetImage('images/bgapproval.jpg'),
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
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Approval Kelas Berlangsung',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28.0 * textScale,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
              height: screenHeight * 0.75,
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
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25))),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 14, left: 14, right: 14, bottom: 24),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 30,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.04,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidth * 0.6,
                                      child: Text(
                                        'Pemrograman Perangkat Bergerak',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 14.0 * textScale,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff0f0f0),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                bottomLeft: Radius.circular(7),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Text(
                                                'TI-2A',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10.0 * textScale,
                                                  color: const Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xfff0f0f0),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(7),
                                                bottomRight: Radius.circular(7),
                                              ),
                                              border: Border.all(
                                                  color: Colors.grey),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0,
                                                      horizontal: 8.0),
                                              child: Text(
                                                'MST III/03',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 10.0 * textScale,
                                                  color: const Color.fromARGB(
                                                      255, 85, 85, 85),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
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
                        Positioned(
                          bottom: -30,
                          left: 0,
                          right: 0,
                          child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      minimumSize: const Size(150, 40)),
                                  child: Text(
                                    'Selesai',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins',
                                        fontSize: 13.5 * textScale,
                                        fontWeight: FontWeight.w600),
                                  ))),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 40),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 15, right: 15),
                          child: ListView.builder(
                            itemCount: checkboxStatus.length,
                            itemBuilder: (context, index) {
                              DateTime startTime = DateTime(2024, 1, 1, 7, 30);
                              DateTime currentTime =
                                  startTime.add(Duration(minutes: 30 * index));
                              String formattedTime =
                                  '${currentTime.hour.toString().padLeft(2, '0')}.${currentTime.minute.toString().padLeft(2, '0')}';
                              return Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor:
                                                  Color(0xffD9D9D9),
                                              radius: 20,
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.02,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Muhamad Haydar',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 11.5 * textScale,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  formattedTime,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 12.0 * textScale,
                                                    color:
                                                        const Color(0xff787878),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: checkboxStatus[index],
                                              activeColor: Colors.green,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  checkboxStatus[index] =
                                                      value ?? false;
                                                });
                                              },
                                            ),
                                            Container(
                                              height: screenHeight * 0.04,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  color: Color(0xffd9d9d9)),
                                              child: Center(
                                                child: DropdownButton(
                                                  items:
                                                      _items.map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      _dropdownValue =
                                                          newValue!;
                                                    });
                                                  },
                                                  value: _dropdownValue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  style: TextStyle(
                                                      fontSize: 11 * textScale,
                                                      color: Colors.black),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    )
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
