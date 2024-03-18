import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sibiru_driver/constants.dart";
import "package:sibiru_driver/global/global_var.dart";
import "package:sibiru_driver/pages/home_page.dart";
import "package:slide_to_act/slide_to_act.dart";

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  _OfflineScreenState createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.black54,
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
      body: Padding(
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
            const SizedBox(height: 20),
            SlideAction(
              sliderButtonIcon: Icon(
                Icons.arrow_forward,
                color: whiteColor,
              ),
              innerColor: Colors.green,
              outerColor: whiteColor,
              text: "Slide untuk Online",
              textStyle: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              onSubmit: () {
                // goOnlineNow();
                // setAndGetLocationUpdates();
                // setState(() {
                //   titleToShow = "GO OFFLINE NOW";
                //   colorToShow = Colors.red;
                // });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            )
          ],
        )),
      ),
    );
  }
}
