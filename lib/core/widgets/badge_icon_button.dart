import 'package:flutter/material.dart';

import '../../app/theme.dart';

//  <--------- Badge Icon Button Widget --------->
//* TO show an icon button with a small count badge in its corner, used for the favorites and bag shortcuts in every header
class BadgeIconButton extends StatelessWidget {
  const BadgeIconButton({
    super.key,
    required this.icon,
    required this.count,
    required this.tooltip,
    required this.onTap,
    this.filled = false,
    this.size = 44,
  });

  //  <--------- Fields --------->
  final IconData icon;
  final int count;
  final String tooltip;
  final VoidCallback onTap;

  //  <--------- Style Options --------->
  //* TO draw a white circle behind the icon in the home header style when filled is true
  final bool filled;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: filled ? c.surface : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                //  <--------- Icon --------->
                Center(child: Icon(icon, size: 20, color: c.ink)),
                //  <--------- Count Badge --------->
                //* TO overlay the count in the corner only when it is above zero, capping the label at 99+
                if (count > 0)
                  Positioned(
                    top: filled ? -4 : 6,
                    right: filled ? -4 : 6,
                    child: Container(
                      height: filled ? 19 : 16,
                      constraints: BoxConstraints(minWidth: filled ? 19 : 16),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.accent,
                        borderRadius: BorderRadius.circular(999),
                        border: filled
                            ? Border.all(color: c.background, width: 2)
                            : null,
                      ),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
