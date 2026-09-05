import 'package:dio/dio.dart';
import 'network_info_service.dart';

class ApiService {
  final Dio dio;
  final NetworkInfoService? networkInfoService;

  ApiService({Dio? dio, this.networkInfoService})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://biddabari.com/api/',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    this.dio.interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
          ),
        );
  }

  Future<void> _checkInternetConnection() async {
    if (networkInfoService != null) {
      final connected = await networkInfoService!.isConnected;
      if (!connected) {
        throw 'No internet connection. Please turn on Wi-Fi or Mobile Data.';
      }
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkInternetConnection();
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _checkInternetConnection();
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please check your internet connection.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server returned error status: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to server was cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please turn on Wi-Fi or Mobile Data.';
      default:
        return 'No internet connection or server unavailable.';
    }
  }
}
