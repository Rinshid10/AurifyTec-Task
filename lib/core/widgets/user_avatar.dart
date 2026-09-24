import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/theme.dart';

//  <--------- User Avatar Widget --------->
//* TO show a gradient initials avatar for the signed-in user
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.size = 44,
    this.showStatus = false,
  });

  //  <--------- Fields --------->
  final String name;
  final double size;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return SizedBox(
      width: size.r,
      height: size.r,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          //  <--------- Gradient Circle --------->
          //* TO draw the blue gradient disc with the first letter of the name
          Container(
            width: size.r,
            height: size.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
              ),
              border: Border.all(color: c.surface, width: 2),
              boxShadow: softShadow,
            ),
            child: Text(
              initial,
              style: TextStyle(
                color: Colors.white,
                fontSize: (size * 0.4).sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          //  <--------- Status Dot --------->
          //* TO show a green online dot in the corner when requested
          if (showStatus)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12.r,
                height: 12.r,
                decoration: BoxDecoration(
                  color: c.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.surface, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
