import 'package:flutter/material.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';
import 'package:task_qtec_ecommerce/configs/res/components/round_button.dart';
import 'package:task_qtec_ecommerce/configs/res/text_styles.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height *1;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [

        Row(
          children: [
            if (currentPage > 1)
              RoundButton(
                title: "Previous",
                color: Colors.black,
                onPress: () => onPageChanged(currentPage - 1),
              ),
            SizedBox(width: screenWidth*0.1,),
            Text("Page $currentPage of $totalPages",style: AppTextStyles.inter18WithColor(color: AppColors.blackColor),),
            SizedBox(width: screenWidth*0.1,),
            if (currentPage < totalPages)
              RoundButton(
                title: "Next",
                color: Colors.blueAccent,
                onPress: () =>  onPageChanged(currentPage + 1),
              ),
             
          ],
        ),
      ],
    );
  }
}
