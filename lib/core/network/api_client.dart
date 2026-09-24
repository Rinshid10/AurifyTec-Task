import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';
import 'api_log_interceptor.dart';

//  <--------- Api Client --------->
//* TO wrap Dio with the base URL, timeouts and error translation so repositories never touch Dio directly
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _buildDio();

  //  <--------- Configuration --------->
  static const baseUrl = 'https://dummyjson.com';

  //!  <--------- Request Deadline --------->
  //* TO cap any single request regardless of Dio's own timeouts
  static const requestDeadline = Duration(seconds: 12);

  final Dio _dio;

  //  <--------- Dio Factory --------->
  //* TO build the default Dio instance with base options and timeouts
  static Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        //* TO keep Dio's own timeouts inside the overall deadline so they can still fire first
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );
    //!  <--------- Debug Logging --------->
    //* TO print requests, responses and errors only while running in debug
    if (kDebugMode) dio.interceptors.add(ApiLogInterceptor());
    return dio;
  }

  //  <--------- Public Methods --------->
  //* TO perform a GET and return the decoded JSON body cast to T (a Map for objects, a List for arrays)
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    //* TO be able to abort the socket when the deadline passes, even if the caller gave no token
    final token = cancelToken ?? CancelToken();
    //!  <--------- Error Handling --------->
    //* TO convert every failure below into an ApiException the UI can show
    try {
      //!  <--------- Overall Timeout --------->
      //* TO enforce a hard deadline because Dio's timeouts may never fire when DNS hangs with no route, and cancel the request so it does not linger
      final response = await _dio
          .get<T>(path, queryParameters: queryParameters, cancelToken: token)
          .timeout(
            requestDeadline,
            onTimeout: () {
              token.cancel('deadline');
              throw TimeoutException('Request exceeded $requestDeadline');
            },
          );
      final data = response.data;
      if (data == null) {
        throw _logAndThrow(
          const ApiException(
            ApiErrorType.unknown,
            'The server returned an empty response.',
          ),
        );
      }
      return data;
    } on DioException catch (e) {
      throw _logAndThrow(ApiException.fromDio(e));
    } on TimeoutException {
      throw _logAndThrow(
        const ApiException(
          ApiErrorType.timeout,
          'The request timed out. Please check your connection and try again.',
        ),
      );
    } on ApiException {
      rethrow;
    } catch (error) {
      if (kDebugMode) debugPrint('   unexpected: $error');
      throw _logAndThrow(
        const ApiException(
          ApiErrorType.unknown,
          'Unexpected response from the server.',
        ),
      );
    }
  }

  //  <--------- Error Log --------->
  //* TO print the mapped error the UI will show, then rethrow it
  static ApiException _logAndThrow(ApiException error) {
    if (kDebugMode) debugPrint('   mapped: $error');
    return error;
  }
}
