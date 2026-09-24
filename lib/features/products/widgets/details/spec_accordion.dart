import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/product.dart';

//  <--------- Accordion Widget --------->
//* TO show a collapsible card with an icon and title header, reusable for any details content
class Accordion extends StatefulWidget {
  const Accordion({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  //  <--------- Fields --------->
  final IconData icon;
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  @override
  State<Accordion> createState() => _AccordionState();
}

//  <--------- Accordion State --------->
class _AccordionState extends State<Accordion> {
  //  <--------- Fields --------->
  late bool _open = widget.initiallyExpanded;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          //  <--------- Header Section --------->
          //* TO toggle the open state on tap
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Row(
                children: [
                  Icon(widget.icon, size: 17.r, color: c.accent),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.14,
                        color: c.ink,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20.r,
                      color: c.brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //  <--------- Body Section --------->
          //* TO animate the child in and out
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: _open
                ? Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: widget.child,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

//  <--------- Spec Table Widget --------->
//* TO show label and value rows for the product facts the API exposes
class SpecTable extends StatelessWidget {
  const SpecTable({super.key, required this.product});

  final Product product;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final weight = product.weight;
    //  <--------- Rows --------->
    //* TO include only the facts the product actually has
    final rows = <(String, String)>[
      if (product.sku != null) ('SKU', product.sku!),
      if (product.brand != null && product.brand!.isNotEmpty)
        ('Brand', product.brand!),
      ('Category', Formatters.categoryLabel(product.category)),
      if (weight != null)
        ('Weight', '${weight.toStringAsFixed(weight % 1 == 0 ? 0 : 1)} kg'),
      if (product.dimensions != null) ('Dimensions', product.dimensions!.label),
      ('Stock', '${product.stock} units'),
      if (product.minimumOrderQuantity != null)
        ('Minimum order', '${product.minimumOrderQuantity}'),
      ('Rating', '${Formatters.rating(product.rating)} / 5'),
    ];

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) Divider(height: 1.h, color: c.divider),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    rows[i].$1,
                    style: TextStyle(fontSize: 12.sp, color: c.brown),
                  ),
                ),
                Flexible(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
