import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: dotenv.get('BASE_URL'),
        connectTimeout:
            const Duration(seconds: 10),
        sendTimeout:
            const Duration(seconds: 10),
        receiveTimeout:
            const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );
  }
}