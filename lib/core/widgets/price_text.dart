import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../features/products/data/product.dart';
import '../utils/formatters.dart';

//  <--------- Price Text Widget --------->
//* TO show a price with an optional original price struck through beside it
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceSize = 14,
    this.strikeSize = 11,
    this.priceColor,
    this.strikeColor,
    this.gap = 6,
  });

  //  <--------- Product Factory --------->
  //* TO take the final and original price straight from the product so the discount rule lives in one place
  PriceText.forProduct(
    Product product, {
    super.key,
    this.priceSize = 14,
    this.strikeSize = 11,
    this.priceColor,
    this.strikeColor,
    this.gap = 6,
  }) : price = product.finalPrice,
       originalPrice = product.hasDiscount ? product.price : null;

  //  <--------- Fields --------->
  final double price;
  final double? originalPrice;
  final double priceSize;
  final double strikeSize;
  final Color? priceColor;
  final Color? strikeColor;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final strike = originalPrice;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //  <--------- Final Price --------->
          Text(
            Formatters.price(price),
            maxLines: 1,
            style: TextStyle(
              fontSize: priceSize,
              fontWeight: FontWeight.w800,
              color: priceColor ?? c.ink,
              height: 1.3,
            ),
          ),
          //  <--------- Original Price --------->
          //* TO strike through the original price only when one was given and it is higher
          if (strike != null && strike > price) ...[
            SizedBox(width: gap),
            Text(
              Formatters.price(strike),
              maxLines: 1,
              style: TextStyle(
                fontSize: strikeSize,
                decoration: TextDecoration.lineThrough,
                color: strikeColor ?? c.muted,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
