import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

//  <--------- Api Log Interceptor --------->
//* TO print every request, response and failure in the debug console
class ApiLogInterceptor extends Interceptor {
  //  <--------- Request --------->
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startedAt'] = DateTime.now();
    debugPrint('┌─ API ${options.method} ${options.uri}');
    if (options.data != null) {
      debugPrint('│ body: ${_preview(options.data)}');
    }
    handler.next(options);
  }

  //  <--------- Response --------->
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ms = _elapsed(response.requestOptions);
    debugPrint(
      '└─ ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.uri}$ms',
    );
    debugPrint('   data: ${_preview(response.data)}');
    handler.next(response);
  }

  //!  <--------- Error --------->
  //* TO list the status, Dio type, cause and body whenever a call fails
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final ms = _elapsed(err.requestOptions);
    debugPrint(
      '└─ ERROR ${err.requestOptions.method} ${err.requestOptions.uri}$ms',
    );
    debugPrint('   type: ${err.type.name}');
    debugPrint('   status: ${err.response?.statusCode}');
    debugPrint('   message: ${err.message}');
    if (err.error != null) debugPrint('   cause: ${err.error}');
    if (err.response?.data != null) {
      debugPrint('   body: ${_preview(err.response?.data)}');
    }
    handler.next(err);
  }

  //  <--------- Helpers --------->
  static String _elapsed(RequestOptions options) {
    final started = options.extra['startedAt'];
    if (started is! DateTime) return '';
    return ' ${DateTime.now().difference(started).inMilliseconds}ms';
  }

  //* TO keep long product lists readable while still showing the payload
  static String _preview(Object? data) {
    final text = data.toString();
    const limit = 800;
    if (text.length <= limit) return text;
    return '${text.substring(0, limit)}… (${text.length} chars)';
  }
}
