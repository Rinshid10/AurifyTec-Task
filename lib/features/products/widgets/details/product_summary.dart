import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/pill.dart';
import '../../data/product.dart';

//  <--------- Brand Rating Row Widget --------->
//* TO show the brand and category eyebrow with the rating pill on the right
class BrandRatingRow extends StatelessWidget {
  const BrandRatingRow({super.key, required this.product});

  final Product product;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final brandLine = [
      if (product.brand != null && product.brand!.isNotEmpty) product.brand!,
      Formatters.categoryLabel(product.category),
    ].join(' • ').toUpperCase();

    return Row(
      children: [
        //  <--------- Brand Line Section --------->
        Expanded(
          child: Text(
            brandLine,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: c.brown,
            ),
          ),
        ),
        const SizedBox(width: 12),
        //  <--------- Rating Pill Section --------->
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: c.tintSoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 4),
              Text(
                Formatters.rating(product.rating),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.24,
                  color: c.ink,
                ),
              ),
              if (product.reviewCount > 0) ...[
                const SizedBox(width: 2),
                Text(
                  '(${Formatters.compact(product.reviewCount)})',
                  style: TextStyle(fontSize: 12, color: c.brown),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

//  <--------- Price Bar Widget --------->
//* TO show the current price, struck-through list price, savings pill and the shipping or minimum-order line when provided
class PriceBar extends StatelessWidget {
  const PriceBar({super.key, required this.product});

  final Product product;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shipping = product.shippingInformation;
    final minOrder = product.minimumOrderQuantity;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  <--------- Price Row Section --------->
          SizedBox(
            height: 36,
            child: Row(
              children: [
                Text(
                  Formatters.price(product.finalPrice),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                    color: c.ink,
                    height: 1.28,
                  ),
                ),
                if (product.hasDiscount) ...[
                  const SizedBox(width: 8),
                  Text(
                    Formatters.price(product.price),
                    style: TextStyle(
                      fontSize: 16,
                      color: c.brown,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Pill(
                    label: 'Save ${Formatters.price(product.savings)}',
                    background: c.chipRose,
                    foreground: c.onChipRose,
                  ),
                ],
              ],
            ),
          ),
          //  <--------- Shipping Line Section --------->
          if (shipping != null || minOrder != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.local_shipping_outlined, size: 14, color: c.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: c.brown,
                        height: 1.5,
                      ),
                      children: [
                        if (shipping != null)
                          TextSpan(
                            text: shipping,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: c.ink,
                            ),
                          ),
                        if (shipping != null && minOrder != null)
                          const TextSpan(text: ' • '),
                        if (minOrder != null)
                          TextSpan(text: 'Minimum order $minOrder'),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

//  <--------- Quick Facts Widget --------->
//* TO show a two-column grid of availability, warranty, returns and shipping chips
class QuickFacts extends StatelessWidget {
  const QuickFacts({super.key, required this.product});

  final Product product;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final availability =
        product.availabilityStatus ??
        (product.inStock ? 'In stock' : 'Out of stock');
    //  <--------- Facts --------->
    //* TO include only the facts the product provides
    final facts = <(IconData, String, String)>[
      (
        Icons.inventory_2_outlined,
        'Availability',
        '$availability · ${product.stock} left',
      ),
      if (product.warrantyInformation != null)
        (
          Icons.verified_user_outlined,
          'Warranty',
          product.warrantyInformation!,
        ),
      if (product.returnPolicy != null)
        (Icons.assignment_return_outlined, 'Returns', product.returnPolicy!),
      if (product.shippingInformation != null)
        (
          Icons.local_shipping_outlined,
          'Shipping',
          product.shippingInformation!,
        ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 64,
      ),
      itemCount: facts.length,
      itemBuilder: (context, i) => _FactChip(
        icon: facts[i].$1,
        title: facts[i].$2,
        subtitle: facts[i].$3,
      ),
    );
  }
}

//  <--------- Fact Chip Widget --------->
//* TO paint one icon, title and subtitle chip
class _FactChip extends StatelessWidget {
  const _FactChip({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: softShadow,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: c.accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.24,
                    color: c.ink,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: c.brown, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//  <--------- Tag Row Widget --------->
//* TO show a horizontal list of product tags
class TagRow extends StatelessWidget {
  const TagRow({super.key, required this.tags});

  final List<String> tags;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAGS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: c.brown,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 32,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tags.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => Center(
              child: Pill(
                label: tags[i],
                background: c.surface,
                foreground: c.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.24,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: Dot(color: c.rose),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
