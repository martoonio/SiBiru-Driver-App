import 'dart:async';
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

String prevHalte = "";
String nextHalte = "";
int capacity = 0;
String route = "";
