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

  getCurrentLiveLocationOfDriver() async {
    try {
      Position positionOfUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      currentPositionOfDriver = positionOfUser;
      riderCurrentPosition = currentPositionOfDriver;
    } catch (e) {
      print("Error getting current location: $e");
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

  // retrieveCurrentDriverInfo() async {
  //   await FirebaseDatabase.instance
  //       .ref()
  //       .child("riders")
  //       .child(FirebaseAuth.instance.currentUser!.uid)
  //       .once()
  //       .then((snap) {
  //     riderName = (snap.snapshot.value as Map)["name"];
  //     riderPhone = (snap.snapshot.value as Map)["phone"];
  //     riderPhoto = (snap.snapshot.value as Map)["photo"];
  //     riderFaculty = (snap.snapshot.value as Map)["faculty"];

  //     vehicleColor =
  //         (snap.snapshot.value as Map)["vehicle_details"]["vehicleColor"];
  //     vehicleModel =
  //         (snap.snapshot.value as Map)["vehicle_details"]["vehicleModel"];
  //     vehicleNumber =
  //         (snap.snapshot.value as Map)["vehicle_details"]["vehicleNumber"];
  //   });

  //   initializePushNotificationSystem();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLiveLocationOfDriver();
    // retrieveCurrentDriverInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: double.infinity,
            color: Colors.black54,
          ),

          ///go online offline button
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: kSecondaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(
                                    0.7,
                                    0.7,
                                  ),
                                ),
                              ],
                            ),
                            height: 221,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 18),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  Text(
                                    (!isDriverAvailable)
                                        ? "GO ONLINE NOW"
                                        : "GO OFFLINE NOW",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 21,
                                  ),
                                  Text(
                                    (!isDriverAvailable)
                                        ? "You are about to go online, you will become available to receive trip requests from wavers."
                                        : "You are about to go offline, you will stop receiving new trip requests from wavers.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.jost(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("BACK",
                                              style: GoogleFonts.poppins(
                                                color: kPrimaryColor,
                                              )),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (!isDriverAvailable) {
                                              //go online
                                              goOnlineNow();

                                              //get driver location updates
                                              setAndGetLocationUpdates();

                                              Navigator.pop(context);

                                              setState(() {
                                                colorToShow = Colors.red;
                                                titleToShow = "GO OFFLINE NOW";
                                                isDriverAvailable = true;
                                              });
                                            } else {
                                              //go offline
                                              goOfflineNow();

                                              Navigator.pop(context);

                                              setState(() {
                                                colorToShow = kPrimaryColor;
                                                titleToShow = "GO ONLINE NOW";
                                                isDriverAvailable = false;
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                (titleToShow == "GO ONLINE NOW")
                                                    ? kPrimaryColor
                                                    : Colors.red,
                                          ),
                                          child: Text("CONFIRM",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorToShow,
                  ),
                  child: Text(
                    titleToShow,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
