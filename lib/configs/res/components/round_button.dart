import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../color.dart';

class RoundButton extends StatelessWidget {

  final String title ;
  final Color color;
  final bool loading ;
  final VoidCallback onPress ;
  const RoundButton({Key? key ,
    required this.title,
    required this.color,
    this.loading = false ,
     required this.onPress ,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final screenWidth = MediaQuery.of(context).size.width * 1;

    return InkWell(
      onTap: onPress,
      child: Container(
        height: screenHeight*0.04,
        width: screenWidth*0.45,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(30)
        ),
        child: Center(
            child:loading ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white,)) :  AutoSizeText(title ,
              style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
              letterSpacing: 0.8,
            )
            )),
      ),
    );
  }
}
