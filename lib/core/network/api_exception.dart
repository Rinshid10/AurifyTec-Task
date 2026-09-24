import 'package:dio/dio.dart';

//  <--------- Api Error Type --------->
//* TO name the kinds of failures the API layer can surface to the UI
enum ApiErrorType { network, timeout, notFound, server, cancelled, unknown }

//!  <--------- Api Exception --------->
//* TO give the app one UI-friendly exception type so screens never see DioException directly
class ApiException implements Exception {
  const ApiException(this.type, this.message, {this.statusCode});

  //  <--------- Fields --------->
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  //!  <--------- Dio Error Mapping --------->
  //* TO translate every DioException into a readable message and error type
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        return const ApiException(
          ApiErrorType.network,
          'No internet connection. Please check your network and try again.',
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          ApiErrorType.timeout,
          'The request timed out. Please try again.',
        );
      case DioExceptionType.cancel:
        return const ApiException(ApiErrorType.cancelled, 'Request cancelled.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 404) {
          return ApiException(
            ApiErrorType.notFound,
            'We could not find what you were looking for.',
            statusCode: code,
          );
        }
        return ApiException(
          ApiErrorType.server,
          'The server returned an error ($code). Please try again later.',
          statusCode: code,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        //!  <--------- Socket Fallback --------->
        //* TO treat a SocketException reported as unknown as a missing network, since some platforms report it that way
        if (e.error != null && e.error.toString().contains('SocketException')) {
          return const ApiException(
            ApiErrorType.network,
            'No internet connection. Please check your network and try again.',
          );
        }
        return const ApiException(
          ApiErrorType.unknown,
          'Something went wrong. Please try again.',
        );
    }
  }

  //  <--------- Helpers --------->
  //* TO pull a readable message out of any thrown object
  static String messageFor(Object error) {
    if (error is ApiException) return error.message;
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => 'ApiException(${type.name}): $message';
}
