import '../../products/data/product.dart';

//  <--------- Cart Line Model --------->
//* TO hold one product in the bag together with its quantity
class CartLine {
  const CartLine({required this.product, required this.quantity});

  //  <--------- Fields --------->
  final Product product;
  final int quantity;

  //  <--------- Totals --------->
  //* TO compute the price of this line from the product price and quantity
  double get lineTotal => product.finalPrice * quantity;

  //  <--------- Copy --------->
  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);

  //  <--------- Serialization --------->
  //* TO convert the line to and from json for local storage
  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  );
}
