import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';

class AppTextStyles {
  /// Regular
  static final TextStyle poppins12Regular = GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.blackColor

  );

  /// Custom method to allow manual color customization
  static TextStyle poppins13WithColor({ required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: color,/// Medium
    );
  }


}