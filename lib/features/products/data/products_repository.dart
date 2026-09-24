import '../../../core/network/api_client.dart';
import 'product.dart';
import 'product_sort.dart';

//  <--------- Products Repository --------->
//* TO be the single entry point for product data from the DummyJSON endpoints
class ProductsRepository {
  ProductsRepository(this._client);

  final ApiClient _client;

  static const defaultPageSize = 20;

  //  <--------- Product Listing --------->
  //* TO fetch a page of all products or of one category
  Future<ProductPage> getProducts({
    int limit = defaultPageSize,
    int skip = 0,
    String? category,
    ProductSort sort = ProductSort.relevance,
  }) async {
    final path = category == null || category.isEmpty
        ? '/products'
        : '/products/category/$category';
    final json = await _client.get<Map<String, dynamic>>(
      path,
      queryParameters: _pageParams(limit: limit, skip: skip, sort: sort),
    );
    return ProductPage.fromJson(json);
  }

  //  <--------- Product Search --------->
  //* TO fetch a page of products matching a search query
  Future<ProductPage> searchProducts(
    String query, {
    int limit = defaultPageSize,
    int skip = 0,
    ProductSort sort = ProductSort.relevance,
  }) async {
    final json = await _client.get<Map<String, dynamic>>(
      '/products/search',
      queryParameters: {
        'q': query,
        ..._pageParams(limit: limit, skip: skip, sort: sort),
      },
    );
    return ProductPage.fromJson(json);
  }

  //  <--------- Single Product --------->
  //* TO fetch one product by id
  Future<Product> getProduct(int id) async {
    final json = await _client.get<Map<String, dynamic>>('/products/$id');
    return Product.fromJson(json);
  }

  //  <--------- Categories --------->
  //* TO fetch the list of category slugs
  Future<List<String>> getCategories() async {
    final json = await _client.get<List<dynamic>>('/products/category-list');
    return json.map((e) => e.toString()).toList();
  }

  //  <--------- Category Summary --------->
  //* TO make one tiny request per category to learn the item count and grab a thumbnail
  Future<CategorySummary> getCategorySummary(String category) async {
    final json = await _client.get<Map<String, dynamic>>(
      '/products/category/$category',
      queryParameters: {'limit': 1, 'select': 'thumbnail'},
    );
    final products = json['products'] as List? ?? const [];
    final first = products.isEmpty
        ? null
        : products.first as Map<String, dynamic>;
    return CategorySummary(
      slug: category,
      total: (json['total'] as num?)?.toInt() ?? 0,
      thumbnail: first?['thumbnail'] as String?,
    );
  }

  //  <--------- Helpers --------->
  //* TO build the pagination and sort query parameters
  Map<String, dynamic> _pageParams({
    required int limit,
    required int skip,
    required ProductSort sort,
  }) {
    return {
      'limit': limit,
      'skip': skip,
      if (sort.sortBy != null) 'sortBy': sort.sortBy,
      if (sort.order != null) 'order': sort.order,
    };
  }
}
