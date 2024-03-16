import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sibiru_driver/constants.dart';


class LoadingDialog extends StatelessWidget
{
  String messageText;

  LoadingDialog({super.key, required this.messageText,});



  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: kPrimaryColor,
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              const SizedBox(width: 5,),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),

              const SizedBox(width: 8,),

              Text(
                messageText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: kPrimaryColor,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
