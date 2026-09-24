import 'package:flutter/material.dart';

import '../data/product.dart';
import 'product_card.dart';

//  <--------- Product Sliver Grid Widget --------->
//* TO show a responsive product grid with 2 columns on phones and more on wider screens, using fixed card heights so nothing overflows
class ProductSliverGrid extends StatelessWidget {
  const ProductSliverGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    this.horizontalPadding = 24,
    this.spacing = 14,
  });

  //  <--------- Fields --------->
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final double horizontalPadding;
  final double spacing;

  //  <--------- Helpers --------->
  //* TO pick the column count for the available width
  static int columnsForWidth(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsForWidth(constraints.crossAxisExtent);
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              mainAxisExtent: ProductCard.height,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => onProductTap(product),
              );
            }, childCount: products.length),
          ),
        );
      },
    );
  }
}

//  <--------- Product Carousel Widget --------->
//* TO show a horizontal strip of product cards sized so two fit side by side while staying scrollable
class ProductCarousel extends StatelessWidget {
  const ProductCarousel({
    super.key,
    required this.products,
    required this.onProductTap,
    this.horizontalPadding = 24,
    this.spacing = 14,
  });

  //  <--------- Fields --------->
  final List<Product> products;
  final ValueChanged<Product> onProductTap;
  final double horizontalPadding;
  final double spacing;

  //  <--------- Build --------->
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - horizontalPadding * 2 - spacing) / 2;
        return SizedBox(
          height: ProductCard.height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: products.length,
            separatorBuilder: (_, _) => SizedBox(width: spacing),
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: cardWidth,
                child: ProductCard(
                  product: product,
                  enableHero: false,
                  onTap: () => onProductTap(product),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
