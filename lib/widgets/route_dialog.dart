import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:sibiru_driver/constants.dart";
import "package:sibiru_driver/global/global_var.dart";

class RouteDialog extends StatefulWidget {
  const RouteDialog({Key? key}) : super(key: key);

  State<RouteDialog> createState() => _RouteDialogState();
}

class _RouteDialogState extends State<RouteDialog> {
  @override
  Widget build(BuildContext context) {

    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: kPrimaryColor,
      elevation: 3,
      shadowColor: Colors.black54,
      child: Container(
        // padding: const EdgeInsets.all(20),
        height: 300,
        // width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: 300,
              child: Column(
                children: [
                  Text(
                    "Pilih Shuttle",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          saveRoute("Blue", shuttleInfo);
                          Navigator.pop(context);
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
                          Navigator.pop(context);
                          setState(() {
                            shuttle = "Grey";
                          });
                          print(shuttle);
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
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "BATAL",
                  style: GoogleFonts.montserrat(
                    color: whiteColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
