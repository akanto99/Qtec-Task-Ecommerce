import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_qtec_ecommerce/configs/res/color.dart';
import 'package:task_qtec_ecommerce/configs/res/text_styles.dart';
class ProductCardWidgets extends StatefulWidget {
  final String imageUrl;
  final String categoryText;
  final String price;
  final String discountPrice;
  final String offPricePercent;
  final String rating;
  final String ratingCount;

  const ProductCardWidgets({
    Key? key,
    required this.imageUrl,
    required this.categoryText,
    required this.price,
    required this.discountPrice,
    required this.offPricePercent,
    required this.rating,
    required this.ratingCount,
  }) : super(key: key);

  @override
  State<ProductCardWidgets> createState() => _ProductCardWidgetsState();
}

class _ProductCardWidgetsState extends State<ProductCardWidgets> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: screenHeight * 0.18,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xffD5D6DE),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                /// Image
                Positioned.fill(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),

                /// Heart Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isFavorite ? Colors.red :Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.01),
        SizedBox(
          width: screenWidth,
          child: Text(
            widget.categoryText,
            style: AppTextStyles.inter14WithColor(
              color: AppColors.blackColor,
            ),
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            Text(
              widget.price,
              style: AppTextStyles.inter16WithColor(
                color: AppColors.blackColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: screenWidth * 0.015),
            Text(
              widget.discountPrice,
              style: AppTextStyles.inter12WithColor(
                color: AppColors.blackColor.withOpacity(0.5),
              ).copyWith(
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.blackColor.withOpacity(0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: screenWidth * 0.015),
            Text(
              widget.offPricePercent,
              style: AppTextStyles.inter12WithColor(
                color: const Color(0xffEA580C),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/icons/rating.svg',
              fit: BoxFit.contain,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              widget.rating,
              style: AppTextStyles.inter12Regular,
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              widget.ratingCount,
              style: AppTextStyles.inter14Counts,
            ),
          ],
        ),
      ],
    );
  }
}
