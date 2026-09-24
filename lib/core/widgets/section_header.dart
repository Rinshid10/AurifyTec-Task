import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme.dart';

//  <--------- Section Header Widget --------->
//* TO render the title row above each section with an optional subtitle, inline accessory and trailing text action
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.accessory,
    this.actionLabel,
    this.onAction,
    this.actionColor,
    this.titleSize = 16,
    this.padding,
  });

  //  <--------- Fields --------->
  final String title;
  final String? subtitle;
  final Widget? accessory;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? actionColor;
  final double titleSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(0, 0, 0, 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //  <--------- Title Column --------->
          //* TO show the title with its accessory beside it and the subtitle underneath
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: c.ink,
                        ),
                      ),
                    ),
                    if (accessory != null) ...[
                      SizedBox(width: 8.w),
                      accessory!,
                    ],
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11.sp, color: c.muted),
                  ),
              ],
            ),
          ),
          //  <--------- Trailing Action --------->
          //* TO show a tappable text action like See all when a label is given
          if (actionLabel != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: actionColor ?? c.subtle,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
