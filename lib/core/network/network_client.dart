import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

abstract class NetworkClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});
  Future<Response> post(String path, {dynamic data});
  Future<Response> put(String path, {dynamic data});
  Future<Response> delete(String path);
}

class NetworkClientImpl implements NetworkClient {
  final Dio _dio;

  NetworkClientImpl() : _dio = Dio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: ApiConstants.timeoutDuration);
    _dio.options.receiveTimeout = const Duration(seconds: ApiConstants.timeoutDuration);
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  @override
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  @override
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  @override
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}