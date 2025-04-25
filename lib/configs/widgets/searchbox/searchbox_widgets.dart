import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';
import 'package:task_qtec_ecommerce/configs/res/text_styles.dart';

class SearchBoxWidget extends StatelessWidget {
  final double width;
  final Function(String)? onChanged;
  final bool autofocus;
  final bool enabled;

  const SearchBoxWidget({
    Key? key,
    required this.width,
    this.onChanged,
    this.autofocus = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.greyColor,
          width: 0.5,
        ),
      ),
      child: TextFormField(
        autofocus: autofocus,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: 'Search Anything...',
          hintStyle: AppTextStyles.inter18WithColor(
            color: AppColors.greyColor,
          ),
          // prefixIcon:  Icon(CupertinoIcons.search,color: AppColors.blackColor.withOpacity(0.8),),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(11.0),
            child: SvgPicture.asset(
              'assets/images/icons/search.svg',
              color: AppColors.blackColor.withOpacity(0.8),
            ),
          ),

          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 0,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}


class SearchMessageWidget extends StatelessWidget {
  final String message;

  const SearchMessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.query_stats_outlined,
            color: Colors.red,
            size: 45,
          ),
          SizedBox(height:screenHeight * 0.02),
          Text(message, style: AppTextStyles.inter16WithColor(color: AppColors.blackColor),
            textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
