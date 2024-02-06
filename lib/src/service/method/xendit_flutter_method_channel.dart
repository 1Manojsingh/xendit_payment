import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../xendit_flutter.dart';
import '../platform/xendit_flutter_platform_interface.dart';

/// An implementation of [XenditFlutterPlatform] that uses method channels.
class MethodChannelXenditFlutter extends XenditFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('plugins.flutter.io/xendit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<TokenResult> createSingleUseToken({
    required Map<String, dynamic> params,
  }) async {
    try {
      var result = await methodChannel.invokeMethod('createToken', params);
      print(result);
      return TokenResult(token: Token.from(result));
    } on PlatformException catch (e) {
      return TokenResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }

  @override
  Future<TokenResult> createMultipleUseToken({
    required Map<String, dynamic> params,
  }) async {
    try {
      var result = await methodChannel.invokeMethod('createToken', params);
      return TokenResult(token: Token.from(result));
    } on PlatformException catch (e) {
      return TokenResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }

  @override
  Future<AuthenticationResult> createAuthentication({required Map<String, dynamic> params}) async {
    try {
      var result = await methodChannel.invokeMethod('createAuthentication', params);
      print(result);
      return AuthenticationResult(authentication: Authentication.from(result));
    } on PlatformException catch (e) {
      return AuthenticationResult(
        errorCode: e.code,
        errorMessage: e.message ?? '',
      );
    }
  }

  @override
  Future<String?> check() async {
    try {
      //
      final result = await methodChannel.invokeMethod('check');
      return result.toString();
    } on PlatformException catch (e) {
      //
      return e.message;
    }
  }
}
