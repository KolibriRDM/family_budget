import 'dart:async';

import 'package:dio/dio.dart';
import 'package:family_budget/app/app_router/app_router.dart';
import 'package:family_budget/data/models/token_response.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/helpers/keys.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:family_budget/widgets/restart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import 'interceptors/log.dart';

@lazySingleton
class ApiClient {
  ApiClient(this.prefs, DotEnv env) {
    final url = env.env['API_URL']!;
    // final url = env.env['BASE_URL']!;
    client = Dio(
      BaseOptions(
        baseUrl: url,
        receiveTimeout: const Duration(milliseconds: 15000), // 15 seconds
        connectTimeout: const Duration(milliseconds: 15000),
        sendTimeout: const Duration(milliseconds: 15000),
      ),
    );
    client.interceptors.addAll({
      AppInterceptors(
        prefs,
        dio: client,
        url: url,
        client: this,
      ),
      logInterceptor,
    });
  }

  late Dio client;

  final Preferences prefs;

  DioError? error;
  ErrorInterceptorHandler? handler;
  static const String updatePath = '/auth/refresh';

  void onListener(DioError err, ErrorInterceptorHandler errorHandler) {
    error = err;
    handler = errorHandler;
    dioErrorStream.add(err);
    dioErrorHandlerStream.add(handler);
  }

  final StreamController<DioError?> dioErrorStream =
      StreamController<DioError?>.broadcast();

  final StreamController<ErrorInterceptorHandler?> dioErrorHandlerStream =
      StreamController<ErrorInterceptorHandler?>.broadcast();

  Future<bool> refreshRequest(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final refreshToken = prefs.getStringByKey(Keys.refreshToken);
      if (refreshToken == null) {
        throw DioError(
          requestOptions: error.requestOptions,
          error: t.api.refreshNotFound,
        );
      }

      final response = await client.post(
        updatePath,
      );
      final resp = TokenResponse.fromJson(response.data);

      await prefs.saveAccessToken(resp.accessToken);
      await prefs.saveRefreshToken(resp.refreshToken);

      final accessToken = prefs.getStringByKey(Keys.accessToken);
      if (accessToken == null) {
        throw DioError(
          requestOptions: error.requestOptions,
          error: t.api.accessNotFound,
        );
      }

      error.requestOptions.headers["Authorization"] = 'Bearer $accessToken';
      final opts = Options(
        method: error.requestOptions.method,
        headers: error.requestOptions.headers,
      );

      final retryResponse = await client.request(
        error.requestOptions.path,
        options: opts,
        cancelToken: error.requestOptions.cancelToken,
        onReceiveProgress: error.requestOptions.onReceiveProgress,
        data: error.requestOptions.data,
        queryParameters: error.requestOptions.queryParameters,
      );

      handler.resolve(retryResponse);
      return retryResponse.statusCode! < 300;
    } catch (e) {
      throw DioError(
        requestOptions: error.requestOptions,
        error: e.toString(),
      );
    }
  }
}

class AppInterceptors extends Interceptor {
  final Dio dio;
  final String url;
  final Preferences prefs;
  final ApiClient client;

  AppInterceptors(
    this.prefs, {
    required this.dio,
    required this.url,
    required this.client,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.contains('convert?to=')) {
      options.baseUrl = 'https://api.apilayer.com';
      options.headers['apikey'] = '42rYJoyvTsdnmHwTj45WyiNQG1MbfN2V';
    } else if (prefs.checkToken()) {
      if (options.path.contains(ApiClient.updatePath)) {
        final refreshToken = prefs.getStringByKey(Keys.refreshToken);
        if (refreshToken != null) {
          options.headers['Authorization'] = 'Bearer $refreshToken';
        }
      } else {
        final accessToken = prefs.getStringByKey(Keys.accessToken);
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
      }
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    debugPrint('STATUS_CODE: ${err.response?.statusCode},\n '
        'ERROR: ${err.message},\n '
        // 'MESSAGE: ${err.response?.data["message"]},\n '
        'PATH: ${err.requestOptions.path}');
    if (err.requestOptions.path.contains('GetDataKKT')) {
      throw InternalServerErrorException(err.requestOptions);
    }
    if (err.type == DioErrorType.connectionTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }
    if (err.type == DioErrorType.sendTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }
    if (err.type == DioErrorType.receiveTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }

    if (err.type == DioErrorType.badResponse) {
      if (err.response?.statusCode == 301) {
        throw BadRequestException(err.requestOptions);
      } else if (err.response?.statusCode == 401 ||
          err.response?.statusCode == 403) {
        if (err.requestOptions.path.contains('refresh')) {
          await prefs.deleteAccessToken().then((value) async {
            await prefs.deleteRefreshToken();
          }).then((value) {
              RestartWidget.restartApp(globalContext);
            });
        } else {
          await client.refreshRequest(err, handler);
          return;
        }
      } else if (err.response?.statusCode == 404) {
        if (err.requestOptions.path.contains('refresh')) {
          await prefs.deleteAccessToken().then((value) async {
            await prefs.deleteRefreshToken();
          }).then((value) {
            RestartWidget.restartApp(globalContext);
          });
        }
      }
    }

    if (err.type == DioErrorType.connectionTimeout) {
      throw DeadlineExceededException(err.requestOptions);
    }
    if (err.type == DioErrorType.connectionError) {
      showMessage(
        message: t.api.unknownErr,
        type: PageState.error,
      );
      throw InternalServerErrorException(err.requestOptions);
    }
    return handler.next(err);
  }

  @override
  void onResponse(
    response,
    ResponseInterceptorHandler handler,
  ) {
    return handler.next(response);
  }
}

class DioClientListener extends StatelessWidget {
  const DioClientListener({
    Key? key,
    this.child,
    this.onFunction,
  }) : super(key: key);

  final Widget? child;
  final VoidCallback? onFunction;

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox();
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return t.api.invalidRequest;
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return t.api.unknownErr;
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return t.api.conflict;
  }
}

class NotFoundException extends DioError {
  NotFoundException({required String message, required super.requestOptions});

  @override
  String toString() {
    return message ?? '';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return t.api.internetConnectionErr;
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return t.api.timeoutErr;
  }
}
