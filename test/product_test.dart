import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/features/products/data/product.dart';

void main() {
  group('Product.fromJson', () {
    test('parses a full DummyJSON product', () {
      final product = Product.fromJson({
        'id': 1,
        'title': 'Essence Mascara',
        'description': 'Lash princess',
        'category': 'beauty',
        'price': 9.99,
        'discountPercentage': 7.17,
        'rating': 4.94,
        'stock': 5,
        'tags': ['beauty', 'mascara'],
        'brand': 'Essence',
        'thumbnail': 'https://example.com/thumb.png',
        'images': ['https://example.com/1.png'],
      });

      expect(product.id, 1);
      expect(product.title, 'Essence Mascara');
      expect(product.price, 9.99);
      expect(product.tags, ['beauty', 'mascara']);
      expect(product.brand, 'Essence');
      expect(product.lowStock, isTrue);
      expect(product.inStock, isTrue);
    });

    test('tolerates ints for doubles and missing optional fields', () {
      final product = Product.fromJson({
        'id': 2,
        'title': 'Thing',
        'price': 10,
        'rating': 4,
        'stock': 0,
      });

      expect(product.price, 10.0);
      expect(product.rating, 4.0);
      expect(product.brand, isNull);
      expect(product.tags, isEmpty);
      expect(product.images, isEmpty);
      expect(product.inStock, isFalse);
    });

    test('round-trips through toJson', () {
      final original = Product.fromJson({
        'id': 3,
        'title': 'Round trip',
        'price': 1.5,
        'brand': null,
      });
      final copy = Product.fromJson(original.toJson());
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.price, original.price);
    });
  });

  test('parses detail-only fields and reviews', () {
    final product = Product.fromJson({
      'id': 9,
      'title': 'Detailed',
      'price': 10,
      'sku': 'ABC-1',
      'weight': 4,
      'dimensions': {'width': 1.5, 'height': 2, 'depth': 3},
      'warrantyInformation': '1 year',
      'shippingInformation': 'Ships in 2 days',
      'availabilityStatus': 'In Stock',
      'returnPolicy': '30 days',
      'minimumOrderQuantity': 5,
      'reviews': [
        {
          'rating': 4,
          'comment': 'Nice',
          'reviewerName': 'Ann Lee',
          'date': '2025-04-30T09:41:02.053Z',
        },
      ],
    });

    expect(product.sku, 'ABC-1');
    expect(product.dimensions!.label, '1.5 × 2.0 × 3.0 cm');
    expect(product.minimumOrderQuantity, 5);
    expect(product.reviews.single.reviewerName, 'Ann Lee');
    expect(product.reviews.single.date!.year, 2025);
    expect(product.reviewCount, 1);

    final copy = Product.fromJson(product.toJson());
    expect(copy.reviews.single.comment, 'Nice');
    expect(copy.dimensions!.depth, 3);
  });

  group('ProductPage', () {
    test('hasMore reflects skip + count vs total', () {
      final page = ProductPage.fromJson({
        'products': [
          {'id': 1, 'title': 'a'},
          {'id': 2, 'title': 'b'},
        ],
        'total': 5,
        'skip': 0,
        'limit': 2,
      });
      expect(page.products.length, 2);
      expect(page.hasMore, isTrue);

      final last = ProductPage.fromJson({
        'products': [
          {'id': 5, 'title': 'e'},
        ],
        'total': 5,
        'skip': 4,
        'limit': 2,
      });
      expect(last.hasMore, isFalse);
    });
  });
}
