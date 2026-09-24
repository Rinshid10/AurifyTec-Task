import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/core/utils/formatters.dart';

void main() {
  test('price formats with two decimals', () {
    expect(Formatters.price(9.5), r'$9.50');
    expect(Formatters.price(1234), r'$1234.00');
  });

  test('rating uses one decimal', () {
    expect(Formatters.rating(4.94), '4.9');
  });

  test('discount rounds to whole percent', () {
    expect(Formatters.discount(7.17), '-7%');
    expect(Formatters.discount(12.5), '-13%');
  });

  test('categoryLabel title-cases slugs', () {
    expect(Formatters.categoryLabel('mens-shirts'), 'Mens Shirts');
    expect(Formatters.categoryLabel('beauty'), 'Beauty');
    expect(Formatters.categoryLabel(''), '');
  });
}
