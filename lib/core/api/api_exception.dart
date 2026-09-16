import 'package:dio/dio.dart';

enum ApiExceptionType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  network,
}

class ApiException implements Exception {
  final String message;
  final ApiExceptionType type;
  final int? statusCode;

  const ApiException(
    this.message, {
    this.type = ApiExceptionType.network,
    this.statusCode,
  });

  factory ApiException.fromDio(
    DioException error, {
    String badRequestMessage = 'The request is invalid',
    String unauthorizedMessage = 'Authentication is required',
    String forbiddenMessage = 'You do not have permission for this action',
    String notFoundMessage = 'Resource not found',
    String conflictMessage = 'The request conflicts with the current state',
    String fallbackMessage = 'Unable to complete the request',
  }) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 400) {
      return ApiException(
        badRequestMessage,
        type: ApiExceptionType.badRequest,
        statusCode: statusCode,
      );
    }

    if (statusCode == 401) {
      return ApiException(
        unauthorizedMessage,
        type: ApiExceptionType.unauthorized,
        statusCode: statusCode,
      );
    }

    if (statusCode == 403) {
      return ApiException(
        forbiddenMessage,
        type: ApiExceptionType.forbidden,
        statusCode: statusCode,
      );
    }

    if (statusCode == 404) {
      return ApiException(
        notFoundMessage,
        type: ApiExceptionType.notFound,
        statusCode: statusCode,
      );
    }

    if (statusCode == 409) {
      return ApiException(
        conflictMessage,
        type: ApiExceptionType.conflict,
        statusCode: statusCode,
      );
    }

    return ApiException(
      fallbackMessage,
      type: ApiExceptionType.network,
      statusCode: statusCode,
    );
  }

  @override
  String toString() {
    return message;
  }
}
