import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sibiru_driver/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sibiru_driver/pages/route_page.dart';
import 'package:vibration/vibration.dart';

import '../back_service/back_services.dart';
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
  bool isFull = false;

  String prevHalteDisplay = "Gerbang Utama";
  String nextHalteDisplay = "Labtek 1B";

  DatabaseReference shuttleInfo = FirebaseDatabase.instance
      .ref()
      .child("shuttleData")
      .child(FirebaseAuth.instance.currentUser!.uid);

  int nextHalteIndex = 0;

  final List<String?> listHalte = [
    "Gerbang Utama",
    "Labtek 1B",
    "GKU 2",
    "GKU 1A",
    "Rektorat",
    "Koica",
    "GSG",
    "GKU 1B",
    "Parkiran Kehutanan"
  ];

  void navigateToNext() {
    setState(() {
      nextHalteIndex = (nextHalteIndex + 1) % listHalte.length;
      if (nextHalteIndex > 8) {
        nextHalteIndex = 0;
      } else if (nextHalteIndex < 0) {
        nextHalteIndex = 8;
      }
      shuttleInfo.update({
        "halte": listHalte[nextHalteIndex],
        // "status": isFull ? "full" : "available",
      });
    });
  }

  navigateToPrev() {
    setState(() {
      nextHalteIndex = (nextHalteIndex - 1) % listHalte.length;
      if (nextHalteIndex < 0) {
        nextHalteIndex = 8;
      } else if (nextHalteIndex > 8) {
        nextHalteIndex = 0;
      }
      shuttleInfo.update({
        "halte": listHalte[nextHalteIndex],
        // "status": isFull  ? "full" : "available",
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLiveLocationOfDriver();
    isDriverAvailable = false;
    nextHalteIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: isDriverAvailable ? whiteColor : Colors.black,
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
        centerTitle: false,
        shadowColor: Colors.black54,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                backgroundColor: kSecondaryColor,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 300,
                                  width: 400,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Konfirmasi",
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Ingin mengganti shuttle?",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  elevation: 2,
                                                  fixedSize: Size(120, 20)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Tidak",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      kPrimaryColor,
                                                  elevation: 2,
                                                  fixedSize: Size(120, 20)),
                                              onPressed: () {
                                                goOfflineNow();
                                                setState(() {
                                                  setState(() {
                                                    colorToShow = kPrimaryColor;
                                                    titleToShow =
                                                        "GO ONLINE NOW";
                                                    isDriverAvailable = false;
                                                  });
                                                  FlutterBackgroundService()
                                                      .invoke("stopService");
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RoutePage(),
                                                  ),
                                                );
                                              },
                                              child: Text("Ya",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all<double>(3),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                whiteColor
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize : MaterialStateProperty.all<Size>(
                              const Size(20, 20),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(shuttle == "Grey"
                                    ? "assets/shuttle abu.png"
                                    : "assets/shuttle biru.png"),
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        )
          ),
        ],
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
                    child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Image(
                                      image: AssetImage("assets/current.png"),
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
                                            fontSize: 6,
                                            fontWeight: FontWeight.normal,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Text(
                                          prevHalteDisplay,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Switch(
                                      value: isDriverAvailable,
                                      activeColor: whiteColor,
                                      activeTrackColor: Colors.green,
                                      inactiveThumbColor: whiteColor,
                                      inactiveTrackColor: Colors.red,
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                            primary: Colors.red.withOpacity(0.3),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
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
                                                            final service = FlutterBackgroundService();
                                                            service.configure(
                                                              androidConfiguration:
                                                                  AndroidConfiguration(
                                                                autoStart: true,
                                                                isForegroundMode: true,
                                                                onStart: onStart,
                                                              ),
                                                              iosConfiguration: IosConfiguration(
                                                                autoStart: true,
                                                                onForeground: onStart,
                                                              ),
                                                            );
                                                            service.startService();
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
                                                              borderRadius: BorderRadius.circular(20),
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                            primary: Colors.red.withOpacity(0.3),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(20),
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
                                                            FlutterBackgroundService()
                                                                .invoke("stopService");
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
                                                              borderRadius: BorderRadius.circular(20),
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
                                            fontSize: 11,
                                            fontWeight: FontWeight.normal,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                        Text(
                                          nextHalteDisplay,
                                          style: GoogleFonts.poppins(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                  ],
                                )
                              ],
                            ),
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
                        "Kapasitas",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: kPrimaryColor,
                          )
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Vibration.vibrate(duration: 100);
                              setStatus("available");
                              setState(() {
                                isFull = false;
                              });
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(isFull ? 1 : 3),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isFull ? whiteColor : Colors.green,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(width * 0.4, height * 0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 55,
                                  color: isFull ? Colors.green : whiteColor,
                                ),
                                Text(
                                  "Tersedia",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: isFull
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    color: isFull ? Colors.green : whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Vibration.vibrate(duration: 100);
                              setStatus("full");
                              setState(() {
                                isFull = true;
                              });
                            },
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(isFull ? 3 : 1),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isFull ? Colors.red : whiteColor,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(width * 0.4, height * 0.2),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person_off,
                                  size: 55,
                                  color: isFull ? whiteColor : Colors.red,
                                ),
                                Text(
                                  "Penuh",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isFull ? whiteColor : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Switch(
                              value: isDriverAvailable,
                              activeColor: kPrimaryColor,
                              activeTrackColor: kPrimaryLightColor,
                              inactiveThumbColor: whiteColor,
                              inactiveTrackColor: Colors.red,
                              onChanged: (value) {
                                if (value == true) {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Container(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.red
                                                        .withOpacity(0.3),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: const BorderSide(
                                                          color: Colors.red,
                                                          width: 2),
                                                    ),
                                                    fixedSize:
                                                        const Size(100, 40),
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
                                                    final service =
                                                        FlutterBackgroundService();
                                                    service.configure(
                                                      androidConfiguration:
                                                          AndroidConfiguration(
                                                        autoStart: true,
                                                        isForegroundMode: true,
                                                        onStart: onStart,
                                                      ),
                                                      iosConfiguration:
                                                          IosConfiguration(
                                                        autoStart: true,
                                                        onForeground: onStart,
                                                      ),
                                                    );
                                                    service.startService();
                                                  },
                                                  child: Text(
                                                    "YA",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.green,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    fixedSize:
                                                        const Size(100, 40),
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
                                  FlutterBackgroundService()
                                      .invoke("stopService");
                                }
                              },
                            ),
                            Text(
                              titleToShow,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
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
      bottomNavigationBar: isDriverAvailable ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
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
                Size(width*0.3, height*0.17),
              ),
            ),
            onPressed: isDriverAvailable
                ? () {
                  Vibration.vibrate(duration: 100);
                    navigateToPrev();
                    setState(() {
                      if (nextHalteIndex < 0) {
                        nextHalteIndex = 8;
                        nextHalteDisplay = listHalte[nextHalteIndex]!;
                        prevHalteDisplay = listHalte[0]!;
                      } else if (nextHalteIndex == 0) {
                        nextHalteDisplay = listHalte[nextHalteIndex]!;
                        prevHalteDisplay = listHalte[8]!;
                      } else {
                        nextHalteDisplay = listHalte[nextHalteIndex]!;
                        prevHalteDisplay = listHalte[nextHalteIndex - 1]!;
                      }
                    });
                  }
                : null,
            child: Text(
              "Kembali",
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDriverAvailable ? Colors.white : Colors.grey,
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
                  Size(200, height*0.17),
                ),
              ),
              onPressed: isDriverAvailable
                  ? () {
                    Vibration.vibrate(duration: 100);
                      navigateToNext();
                      setState(() {
                        if (nextHalteIndex > 8) {
                          nextHalteIndex = 0;
                          nextHalteDisplay = listHalte[nextHalteIndex]!;
                          prevHalteDisplay = listHalte[8]!;
                        } else if (nextHalteIndex == 0) {
                          nextHalteDisplay = listHalte[nextHalteIndex]!;
                          prevHalteDisplay = listHalte[8]!;
                        } else {
                          nextHalteDisplay = listHalte[nextHalteIndex]!;
                          prevHalteDisplay = listHalte[nextHalteIndex - 1]!;
                        }
                      });
                    }
                  : null,
              child: Text(
                "Jalan",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDriverAvailable ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ) : null,
    );
  }
}
