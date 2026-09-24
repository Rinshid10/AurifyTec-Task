import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_explorer/core/network/api_client.dart';
import 'package:product_explorer/core/network/api_exception.dart';
import 'package:product_explorer/features/products/data/products_repository.dart';

/// Minimal fake transport so the repository can be tested without network.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, {int status = 200}) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

ProductsRepository _repo(
  Future<ResponseBody> Function(RequestOptions options) handler,
) {
  final dio = Dio(BaseOptions(baseUrl: ApiClient.baseUrl))
    ..httpClientAdapter = _FakeAdapter(handler);
  return ProductsRepository(ApiClient(dio: dio));
}

void main() {
  test('getProducts hits /products with limit and skip', () async {
    RequestOptions? captured;
    final repo = _repo((options) async {
      captured = options;
      return _json({
        'products': [
          {'id': 1, 'title': 'A', 'price': 1},
        ],
        'total': 1,
        'skip': 0,
        'limit': 20,
      });
    });

    final page = await repo.getProducts(skip: 40);

    expect(captured!.path, '/products');
    expect(captured!.queryParameters['skip'], 40);
    expect(captured!.queryParameters['limit'], 20);
    expect(page.products.single.title, 'A');
  });

  test('getProducts with category uses the category endpoint', () async {
    RequestOptions? captured;
    final repo = _repo((options) async {
      captured = options;
      return _json({'products': [], 'total': 0, 'skip': 0, 'limit': 20});
    });

    await repo.getProducts(category: 'beauty');

    expect(captured!.path, '/products/category/beauty');
  });

  test('searchProducts passes the query as q', () async {
    RequestOptions? captured;
    final repo = _repo((options) async {
      captured = options;
      return _json({'products': [], 'total': 0, 'skip': 0, 'limit': 20});
    });

    await repo.searchProducts('phone');

    expect(captured!.path, '/products/search');
    expect(captured!.queryParameters['q'], 'phone');
  });

  test('getProduct parses a single product', () async {
    final repo = _repo((_) async => _json({'id': 7, 'title': 'Seven'}));

    final product = await repo.getProduct(7);

    expect(product.id, 7);
    expect(product.title, 'Seven');
  });

  test('getCategories parses a string list', () async {
    final repo = _repo((_) async => _json(['beauty', 'fragrances']));

    expect(await repo.getCategories(), ['beauty', 'fragrances']);
  });

  test('404 becomes ApiException.notFound', () async {
    final repo = _repo(
      (_) async => _json({'message': 'not found'}, status: 404),
    );

    expect(
      () => repo.getProduct(999),
      throwsA(
        isA<ApiException>().having(
          (e) => e.type,
          'type',
          ApiErrorType.notFound,
        ),
      ),
    );
  });

  test('connection errors become ApiException.network', () async {
    final repo = _repo((options) async {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    });

    expect(
      () => repo.getProducts(),
      throwsA(
        isA<ApiException>().having((e) => e.type, 'type', ApiErrorType.network),
      ),
    );
  });
}
