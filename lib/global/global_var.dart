import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

String userName = "";

// String googleMapKey = "AIzaSyDlN7pUZ_oPhroD-gHODW-f6uQ1sR6fH4Y";

// const CameraPosition googlePlexInitialPosition = CameraPosition(
//   target: LatLng(-6.929851, 107.769440),
//   zoom: 14.4746,
// );

StreamSubscription<Position>? positionStreamHomePage;
StreamSubscription<Position>? positionStreamNewTripPage;

int driverTripRequestTimeout = 20;

// final audioPlayer = AssetsAudioPlayer();

Position? riderCurrentPosition;

String route = "";
String shuttle = "";
String halte = "";
bool isFull = false;

DatabaseReference shuttleInfo = FirebaseDatabase.instance
      .ref()
      .child("shuttleData")
      .child(FirebaseAuth.instance.currentUser!.uid);

saveRoute(String route, DatabaseReference shuttleInfo) {
      shuttleInfo.update({
        "route": route,
      });
    }

void setStatus(String status) {
    shuttleInfo.update({
      "status": status,
    });
  }
