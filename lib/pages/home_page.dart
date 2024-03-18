import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sibiru_driver/pages/route_page.dart';
import 'package:slide_to_act/slide_to_act.dart';

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

  String prevHalteDisplay = "Silakan klik Jalan";
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
    isDriverAvailable = false;
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
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                                      image:
                                          AssetImage("assets/Icon Halte.png"),
                                      height: 50,
                                      width: 50,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      image:
                                          AssetImage("assets/halte tujuan.png"),
                                      height: 50,
                                      width: 50,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RoutePage()));
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(3),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              whiteColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(20, 20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage(shuttle == "Grey"
                                    ? "assets/shuttle abu.png"
                                    : "assets/shuttle biru.png"),
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                shuttle == "Grey" ? "Abu" : "Biru",
                                style: GoogleFonts.montserrat(
                                  color: shuttle == "Grey"
                                      ? Colors.grey
                                      : kPrimaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
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
                  height: 50,
                ),
                Column(
                  children: [
                    Switch(
                      value: isDriverAvailable,
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryLightColor,
                      inactiveThumbColor: kPrimaryColor,
                      inactiveTrackColor: kPrimaryLightColor,
                      onChanged: (value) {
                        if (value == true) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              height: 200,
                              color: kPrimaryColor,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Anda yakin ingin online?",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "BATAL",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Colors.red.withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: const BorderSide(
                                                  color: Colors.red, width: 2),
                                            ),
                                            fixedSize: const Size(100, 40),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            goOnlineNow();
                                            setAndGetLocationUpdates();
                                            setState(() {
                                              colorToShow = Colors.red;
                                              titleToShow = "GO OFFLINE NOW";
                                              isDriverAvailable = true;
                                            });
                                          },
                                          child: Text(
                                            "YA",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            fixedSize: const Size(100, 40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              height: 200,
                              color: kPrimaryColor,
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Anda yakin ingin offline?",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "BATAL",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Colors.red.withOpacity(0.3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: const BorderSide(
                                                  color: Colors.red, width: 2),
                                            ),
                                            fixedSize: const Size(100, 40),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            goOfflineNow();
                                            setState(() {
                                              colorToShow = kPrimaryColor;
                                              titleToShow = "GO ONLINE NOW";
                                              isDriverAvailable = false;
                                            });
                                          },
                                          child: Text(
                                            "YA",
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            fixedSize: const Size(100, 40),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          // goOfflineNow();
                          // setState(() {
                          //   colorToShow = kPrimaryColor;
                          //   titleToShow = "GO ONLINE NOW";
                          //   isDriverAvailable = false;
                          // });
                        }
                      },
                    ),
                    Text(
                      titleToShow,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorToShow,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: !isDriverAvailable,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Icon(
                          Icons.wifi_off,
                          size: 100,
                          color: Colors.red,
                        ),
                        Image(image: AssetImage("assets/mode offline.png")),
                        Text(
                          "Anda sedang dalam mode offline dan tidak terdeteksi di website SiBiru Shuttle Tracker. Kembali online Sebelum melanjutkan perjalanan.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: whiteColor,
                          ),
                        ),
                        Column(
                          children: [
                            Switch(
                              value: isDriverAvailable,
                              activeColor: kPrimaryColor,
                              activeTrackColor: kPrimaryLightColor,
                              inactiveThumbColor: kPrimaryColor,
                              inactiveTrackColor: kPrimaryLightColor,
                              onChanged: (value) {
                                if (value == true) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => Container(
                                      height: 200,
                                      color: kPrimaryColor,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Text(
                                              "Anda yakin ingin online?",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "BATAL",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary:
                                                        Colors.red.withOpacity(0.3),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(20),
                                                      side: const BorderSide(
                                                          color: Colors.red,
                                                          width: 2),
                                                    ),
                                                    fixedSize: const Size(100, 40),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    goOnlineNow();
                                                    setAndGetLocationUpdates();
                                                    setState(() {
                                                      colorToShow = Colors.red;
                                                      titleToShow =
                                                          "GO OFFLINE NOW";
                                                      isDriverAvailable = true;
                                                    });
                                                  },
                                                  child: Text(
                                                    "YA",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(20),
                                                    ),
                                                    fixedSize: const Size(100, 40),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  goOfflineNow();
                                  setState(() {
                                    colorToShow = kPrimaryColor;
                                    titleToShow = "GO ONLINE NOW";
                                    isDriverAvailable = false;
                                  });
                                }
                              },
                            ),
                            Text(
                              titleToShow,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colorToShow,
                              ),
                            ),
                          ],
                        )
                      ])),
                ),
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDriverAvailable ? kSecondaryColor : Colors.black54,
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
              onPressed: isDriverAvailable
                  ? () {
                      navigateToPrev();
                      setState(() {
                        nextHalteDisplay = listHalte[nextHalteIndex]!;
                        prevHalteDisplay = listHalte[nextHalteIndex + 1]!;
                      });
                    }
                  : null,
              child: Text(
                "Kembali",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDriverAvailable ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  isDriverAvailable ? kPrimaryColor : Colors.black54,
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
              onPressed: isDriverAvailable
                  ? () {
                      navigateToNext();
                      setState(() {
                        nextHalteDisplay = listHalte[nextHalteIndex]!;
                        prevHalteDisplay = listHalte[nextHalteIndex - 1]!;
                      });
                    }
                  : null,
              child: Text(
                "Jalan",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDriverAvailable ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
