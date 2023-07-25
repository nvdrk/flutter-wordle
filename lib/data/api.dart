import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


abstract class HttpClientInterface {
  HttpClientInterface({
    required String baseURL,
  }) : client = Dio()
    ..options =
    BaseOptions(baseUrl: baseURL, validateStatus: (_) => true);

  @protected
  final Dio client;

  @protected
  Future<Response<T>> get<T>(
      String path, {
        Map<String, dynamic>? queryParameters,
        Map<String, Object>? headers,
        bool cacheResponse = false,
      }) async {
    try {
      final response = await client.get<T>(
        path,
        queryParameters: queryParameters,
        options:
        Options(headers: headers, extra: {'cache_response': cacheResponse}),
      );
      return Response(response.data as T, response.statusCode!);
    } on DioException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  @protected
  Future<Response<T>> post<T>(
      String path, {
        required Map<String, dynamic> body,
        Map<String, dynamic>? queryParameters,
        String? contentType,
        Map<String, Object>? headers,
      }) async {
    try {
      final response = await client.post<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(contentType: contentType, headers: headers),
      );

      return Response(response.data as T, response.statusCode!);
    } on DioException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }
}

class Response<T> extends Equatable {
  const Response(this.json, this.statusCode);

  final T json;
  final int statusCode;

  @override
  List<Object?> get props => [json, statusCode];

  @override
  String toString() => 'statusCode: $statusCode, json: ${jsonEncode(json)}';
}

class WordRepository extends HttpClientInterface {
  WordRepository({required super.baseURL});

  Future<String> getRandomWord(int length) async {
    try {
      final response = await get<String>('word',
          queryParameters: {'length': length, 'lang': 'de'});
      final word = jsonDecode(response.json)[0];
      debugPrint(word);
      return word;
    } on Exception catch (e, _) {
      rethrow;
    }
  }
}

abstract class Dependency {
  static Provider<WordRepository> get wordRepository => wordRepo;
}

final wordRepo = Provider<WordRepository>(
        (ref) => WordRepository(baseURL: 'https://random-word-api.herokuapp.com/'));
