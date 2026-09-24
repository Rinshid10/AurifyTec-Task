import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme.dart';
import '../utils/formatters.dart';

//  <--------- Rating Badge Widget --------->
//* TO show a star with the rating and an optional review count like (142)
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 11,
    this.ratingSize = 11,
    this.countSize = 10,
    this.ratingColor,
    this.countColor,
  });

  //  <--------- Fields --------->
  final double rating;
  final int? reviewCount;
  final double iconSize;
  final double ratingSize;
  final double countSize;
  final Color? ratingColor;
  final Color? countColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //  <--------- Star And Rating --------->
        Icon(
          Icons.star_rounded,
          size: (iconSize + 3).r,
          color: const Color(0xFFF59E0B),
        ),
        SizedBox(width: 3.w),
        Text(
          Formatters.rating(rating),
          style: TextStyle(
            fontSize: ratingSize.sp,
            fontWeight: FontWeight.w700,
            color: ratingColor ?? c.inkSoft,
          ),
        ),
        //  <--------- Review Count --------->
        //* TO append the compact review count only when there is one
        if (reviewCount != null && reviewCount! > 0) ...[
          SizedBox(width: 4.w),
          Text(
            '(${Formatters.compact(reviewCount!)})',
            style: TextStyle(
              fontSize: countSize.sp,
              color: countColor ?? c.muted,
            ),
          ),
        ],
      ],
    );
  }
}
