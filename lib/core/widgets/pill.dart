import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//  <--------- Pill Widget --------->
//* TO render a small rounded label like 6 saved, -18% or New
class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.leading,
    this.trailing,
    this.fontSize = 10,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing = 0.4,
    this.uppercase = false,
    this.padding,
    this.radius = 999,
    this.border,
  });

  //  <--------- Fields --------->
  final String label;
  final Color background;
  final Color foreground;
  final Widget? leading;
  final Widget? trailing;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final bool uppercase;
  final EdgeInsets? padding;
  final double radius;
  final Color? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius.r),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  <--------- Leading, Label And Trailing --------->
          //* TO place optional widgets on either side of the label text
          if (leading != null) ...[leading!, SizedBox(width: 4.w)],
          Text(
            uppercase ? label.toUpperCase() : label,
            style: TextStyle(
              fontSize: fontSize.sp,
              fontWeight: fontWeight,
              letterSpacing: letterSpacing,
              color: foreground,
              height: 1.4,
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 4.w), trailing!],
        ],
      ),
    );
  }
}

//  <--------- Dot Widget --------->
//* TO draw a solid dot used inside pills and badges
class Dot extends StatelessWidget {
  const Dot({super.key, required this.color, this.size = 6});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
