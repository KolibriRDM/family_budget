import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'api_client.dart';

@lazySingleton
class ApiService {
  ApiService(this.apiClient);

  final ApiClient apiClient;

  Future<Response> getMethod(
      {required String path,
      Map<String, dynamic>? params,
      Options? options}) async {
    final response = await apiClient.client.get<dynamic>(
      path,
      queryParameters: params,
      options: options,
    );
    return response;
  }

  Future<Response> getBytesMethod({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    final response = await apiClient.client.get<dynamic>(
      path,
      queryParameters: params,
      options: Options(
        responseType: ResponseType.bytes,
        contentType:
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      ),
    );
    return response;
  }

  Future<Response> postMethod({
    required String path,
    Map<String, dynamic>? params,
    dynamic body,
  }) async {
    final Response response = await apiClient.client.post(
      path,
      queryParameters: params,
      data: body,
    );
    return response;
  }

  Future<Response> uploadFileMethod({
    required String path,
    Map<String, dynamic>? params,
    required dynamic body,
  }) async {
    final Response response = await apiClient.client.post(
      path,
      queryParameters: params,
      data: body,
    );
    return response;
  }

  Future<Response> uploadImageMethod({
    required String path,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
    required Uint8List file,
  }) async {
    Response? response;
    try {
      response = await apiClient.client.post(path,
          queryParameters: params,
          options: Options(contentType: 'application/image'),
          data: Stream.fromIterable(file.map((e) => [e])));
    } catch (ex) {
      debugPrint(ex.toString());
    }

    return response!;
  }

  Future<Response> putMethod({
    required String path,
    Map<String, dynamic>? params,
    required Object body,
  }) async {
    final Response response = await apiClient.client.put(
      path,
      queryParameters: params,
      data: body,
    );
    return response;
  }

  Future<Response> patchMethod({
    required String path,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {
    final Response response = await apiClient.client.patch(
      path,
      queryParameters: params,
      data: body,
    );
    return response;
  }

  Future<Response> deleteMethod({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    final Response response = await apiClient.client.delete(
      path,
    );
    return response;
  }

  Future<Response> createExpenseWithReceipt(Map<String, dynamic> data) async {
    final Response response = await apiClient.client.post(
      '/expenses/with-receipt',
      data: data,
    );
    return response;
  }

  Future<Response> getExpenseReceipt(int expenseId) async {
    final Response response = await apiClient.client.get(
      '/expenses/$expenseId/receipt',
    );
    return response;
  }

  Future<Response> resolveReceiptByQr(String qrRawValue) async {
    final Response response = await apiClient.client.post(
      '/expenses/resolve-receipt',
      data: {
        'qr_raw_value': qrRawValue,
      },
    );
    return response;
  }
}
