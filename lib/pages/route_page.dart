import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sibiru_driver/constants.dart";
import "package:sibiru_driver/pages/home_page.dart";

import "../global/global_var.dart";

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  _RoutePageState createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 3,
        backgroundColor: kPrimaryColor,
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
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "Silakan Pilih Shuttle",
                  style: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
              const SizedBox(height: 20),
              Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveRoute("Blue", shuttleInfo);
                          Navigator.pushReplacement(
                            context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  const HomePage()));
                          setState(() {
                            shuttle = "Blue";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image(image: AssetImage("assets/shuttle biru.png"), height: 40),
                            const SizedBox(height: 5),
                            Text(
                              "Biru",
                              style: GoogleFonts.montserrat(
                                color: kPrimaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveRoute("Grey", shuttleInfo);
                          Navigator.pushReplacement(
                            context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  const HomePage()));

                          setState(() {
                            shuttle = "Grey";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image(image: AssetImage("assets/shuttle abu.png"), height: 40),
                            const SizedBox(height: 5),
                            Text(
                              "Abu",
                              style: GoogleFonts.montserrat(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}