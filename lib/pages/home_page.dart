import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';

import '../global/global_var.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPositionOfDriver;
  Color colorToShow = kPrimaryColor;
  String titleToShow = "GO ONLINE NOW";
  bool isDriverAvailable = false;
  DatabaseReference? newTripRequestReference;
  int passengerCount = 0;

  String prevHalteDisplay = "";
  String nextHalteDisplay = "";

  DatabaseReference shuttleInfo = FirebaseDatabase.instance
      .ref()
      .child("shuttleData")
      .child(FirebaseAuth.instance.currentUser!.uid);

  void _incrementPassengerCount() {
    setState(() {
      passengerCount++;
    });
  }

  void _decrementPassengerCount() {
    if (passengerCount > 0) {
      setState(() {
        passengerCount--;
      });
    }
  }

  int nextHalteIndex = 0;

  final List<String?> listHalte = [
    null,
    "Gerbang Utama",
    "Labtek 1B",
    "GKU 2",
    "GKU 1",
    "Rektorat",
    "Koica / GKU 3",
    "GSG",
    "Asrama",
    "Parkiran Kehutanan"
  ];

  void navigateToNext() {
    setState(() {
      nextHalteIndex = (nextHalteIndex + 1) % listHalte.length;
      shuttleInfo.update({
        "nextHalte": listHalte[nextHalteIndex],
        "prevHalte": listHalte[nextHalteIndex - 1],
        "countMhs": passengerCount,
      });
    });
  }

  navigateToPrev() {
    setState(() {
      nextHalteIndex = (nextHalteIndex - 1) % listHalte.length;
      shuttleInfo.update({
        "nextHalte": listHalte[nextHalteIndex],
        "prevHalte": listHalte[nextHalteIndex + 1],
        "countMhs": passengerCount,
      });
    });
  }

  getCurrentLiveLocationOfDriver() async {
    try {
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPositionOfDriver = positionOfUser;
      riderCurrentPosition = currentPositionOfDriver;
    } catch (e) {
      print(e);
    }
  }

  goOnlineNow() async {
    // Mendapatkan lokasi saat ini
    await getCurrentLiveLocationOfDriver();

    // Melanjutkan dengan operasi lain setelah mendapatkan lokasi
    Geofire.initialize("activeShuttle");

    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      currentPositionOfDriver!.latitude,
      currentPositionOfDriver!.longitude,
    );
  }

  setAndGetLocationUpdates() async {
    // Mendapatkan lokasi saat ini
    await getCurrentLiveLocationOfDriver();

    // Melanjutkan dengan operasi lain setelah mendapatkan lokasi
    positionStreamHomePage =
        Geolocator.getPositionStream().listen((Position position) {
      currentPositionOfDriver = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(
          FirebaseAuth.instance.currentUser!.uid,
          currentPositionOfDriver!.latitude,
          currentPositionOfDriver!.longitude,
        );
      }
    });
  }

  goOfflineNow() {
    //stop sharing driver live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
  }

  // initializePushNotificationSystem() {
  //   PushNotificationSystem notificationSystem = PushNotificationSystem();
  //   notificationSystem.generateDeviceRegistrationToken();
  //   notificationSystem.startListeningForNewNotification(context);
  // }

  retrieveCurrentDriverInfo() async {
    await FirebaseDatabase.instance
        .ref()
        .child("shuttleData")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snap) {
      prevHalte = (snap.snapshot.value as Map)["prevHalte"];
      nextHalte = (snap.snapshot.value as Map)["nextHalte"];
      capacity = (snap.snapshot.value as Map)["countMhs"];
      route = (snap.snapshot.value as Map)["route"];
    });
  }

  _initializeDriverInfo() async {
    await retrieveCurrentDriverInfo();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLiveLocationOfDriver();
    _initializeDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  kPrimaryColor,
                  kSecondaryColor,
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        ),
        title: Image.asset(
          "assets/sibiru_driver.png",
          height: 50,
        ),
        centerTitle: true,
        shadowColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Image(
                                  image: AssetImage("assets/Icon Halte.png"),
                                  height: 50,
                                  width: 50,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Halte saat ini",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      prevHalteDisplay,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Image(
                                  image: AssetImage("assets/halte tujuan.png"),
                                  height: 50,
                                  width: 50,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Halte selanjutnya",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Text(
                                      nextHalteDisplay,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                        backgroundBlendMode: BlendMode.darken,
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage("assets/shuttle abu.png"),
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Shuttle $route",
                            style: GoogleFonts.poppins(
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.0),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Penumpang",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      boxShadow: List<BoxShadow>.generate(
                          3,
                          (index) => BoxShadow(
                                color: kPrimaryColor.withOpacity(0.5),
                                blurRadius: 3.0,
                                spreadRadius: 0.5,
                                offset: const Offset(
                                  0.7,
                                  0.7,
                                ),
                              )),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(40),
                      backgroundBlendMode: BlendMode.darken,
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: (passengerCount > 0)
                              ? _decrementPassengerCount
                              : null,
                          enableFeedback: true,
                        ),
                        Text(
                          "$passengerCount",
                          style: const TextStyle(fontSize: 34),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _incrementPassengerCount,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: (passengerCount > 0)
                        ? () {
                            setState(() {
                              passengerCount = 0;
                            });
                          }
                        : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (passengerCount > 0)
                            ? kPrimaryColor
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      "Reset",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  kSecondaryColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 85),
                ),
              ),
              onPressed: () {
                navigateToPrev();
                setState(() {
                  nextHalteDisplay = listHalte[nextHalteIndex]!;
                  prevHalteDisplay = listHalte[nextHalteIndex + 1]!;
                });
              },
              child: Text(
                "Kembali",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  kPrimaryColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 85),
                ),
              ),
              onPressed: () {
                navigateToNext();
                setState(() {
                  prevHalteDisplay = listHalte[nextHalteIndex - 1]!;
                  nextHalteDisplay = listHalte[nextHalteIndex]!;
                });
              },
              child: Text(
                "Jalan",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
