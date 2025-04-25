import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';

class AppTextStyles {
  /// Regular
  static final TextStyle inter12Regular = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.blackColor

  );
  ///Counts
  static final TextStyle inter14Counts = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.blackColor.withOpacity(0.7)

  );

  /// Custom method to allow manual color customization
  static TextStyle poppins13WithColor({ required Color color}) {
    return GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: color,

      /// Medium
    );
  }


  ///   Regular -10
  static TextStyle inter10WithColor({ required Color color}) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }


  ///   Regular -12
  static TextStyle inter12WithColor({ required Color color}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,

    );
  }

  ///   Regular -14
  static TextStyle inter14WithColor({ required Color color}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  ///   Regular -16
  static TextStyle inter16WithColor({ required Color color}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  ///   Regular -18
  static TextStyle inter18WithColor({ required Color color}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }
}