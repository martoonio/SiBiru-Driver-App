import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sibiru_driver/constants.dart";

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
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: whiteColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  "SILAKAN PILIH SHUTTLE",
                  style: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/shuttle");
                },
                style: ElevatedButton.styleFrom(
                  primary: kSecondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "SHUTTLE",
                  style: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}