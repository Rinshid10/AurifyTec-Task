//  <--------- Product Model --------->
//* TO hold one product as returned by the DummyJSON products endpoints
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.thumbnail,
    required this.images,
    this.reviewCount = 0,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.reviews = const [],
  });

  //  <--------- Fields --------->
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String thumbnail;
  final List<String> images;
  final int reviewCount;

  //  <--------- Detail Fields --------->
  //* TO hold the extra facts shown only on the details page
  final String? sku;
  final double? weight;
  final Dimensions? dimensions;
  final String? warrantyInformation;
  final String? shippingInformation;
  final String? availabilityStatus;
  final String? returnPolicy;
  final int? minimumOrderQuantity;
  final List<Review> reviews;

  //  <--------- Computed Getters --------->
  //* TO derive stock and pricing facts from the raw fields
  bool get inStock => stock > 0;

  bool get lowStock => stock > 0 && stock <= 5;

  bool get hasDiscount => discountPercentage >= 1;

  double get finalPrice =>
      hasDiscount ? price * (1 - discountPercentage / 100) : price;

  double get savings => price - finalPrice;

  //  <--------- JSON Parsing --------->
  //* TO parse defensively since the API mixes int and double and omits brand and tags for some products
  factory Product.fromJson(Map<String, dynamic> json) {
    final reviews = (json['reviews'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(Review.fromJson)
        .toList();
    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      brand: json['brand'] as String?,
      thumbnail: json['thumbnail'] as String? ?? '',
      images:
          (json['images'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      reviewCount: json['reviewCount'] is num
          ? (json['reviewCount'] as num).toInt()
          : reviews.length,
      sku: json['sku'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] is Map<String, dynamic>
          ? Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>)
          : null,
      warrantyInformation: json['warrantyInformation'] as String?,
      shippingInformation: json['shippingInformation'] as String?,
      availabilityStatus: json['availabilityStatus'] as String?,
      returnPolicy: json['returnPolicy'] as String?,
      minimumOrderQuantity: (json['minimumOrderQuantity'] as num?)?.toInt(),
      reviews: reviews,
    );
  }

  //  <--------- JSON Serialization --------->
  //* TO persist favorites and history locally
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discountPercentage,
    'rating': rating,
    'stock': stock,
    'tags': tags,
    'brand': brand,
    'thumbnail': thumbnail,
    'images': images,
    'reviewCount': reviewCount,
    'sku': sku,
    'weight': weight,
    'dimensions': dimensions?.toJson(),
    'warrantyInformation': warrantyInformation,
    'shippingInformation': shippingInformation,
    'availabilityStatus': availabilityStatus,
    'returnPolicy': returnPolicy,
    'minimumOrderQuantity': minimumOrderQuantity,
    'reviews': reviews.map((r) => r.toJson()).toList(),
  };

  //  <--------- Equality --------->
  //* TO compare products by id only
  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

//  <--------- Dimensions Model --------->
//* TO hold the physical size in centimetres as reported by the API
class Dimensions {
  const Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  final double width;
  final double height;
  final double depth;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    width: (json['width'] as num?)?.toDouble() ?? 0,
    height: (json['height'] as num?)?.toDouble() ?? 0,
    depth: (json['depth'] as num?)?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'width': width,
    'height': height,
    'depth': depth,
  };

  //  <--------- Label --------->
  //* TO format the size as "15.1 × 13.1 × 23.0 cm"
  String get label =>
      '${width.toStringAsFixed(1)} × ${height.toStringAsFixed(1)} × '
      '${depth.toStringAsFixed(1)} cm';
}

//  <--------- Review Model --------->
//* TO hold one customer review attached to a product
class Review {
  const Review({
    required this.rating,
    required this.comment,
    required this.reviewerName,
    this.date,
  });

  final int rating;
  final String comment;
  final String reviewerName;
  final DateTime? date;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    rating: (json['rating'] as num?)?.toInt() ?? 0,
    comment: json['comment'] as String? ?? '',
    reviewerName: json['reviewerName'] as String? ?? 'Anonymous',
    date: DateTime.tryParse(json['date'] as String? ?? ''),
  );

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'reviewerName': reviewerName,
    'date': date?.toIso8601String(),
  };
}

//  <--------- Product Page Model --------->
//* TO hold one page of a paginated product response
class ProductPage {
  const ProductPage({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  bool get hasMore => skip + products.length < total;

  factory ProductPage.fromJson(Map<String, dynamic> json) {
    final list = (json['products'] as List? ?? const [])
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProductPage(
      products: list,
      total: (json['total'] as num?)?.toInt() ?? list.length,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? list.length,
    );
  }
}

//  <--------- Category Summary Model --------->
//* TO hold the item count and one thumbnail for an Explore category card
class CategorySummary {
  const CategorySummary({
    required this.slug,
    required this.total,
    this.thumbnail,
  });

  final String slug;
  final int total;
  final String? thumbnail;
}
