import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:xendit_flutter/xendit_flutter.dart';

import '../method/xendit_flutter_method_channel.dart';

abstract class XenditFlutterPlatform extends PlatformInterface {
  /// Constructs a XenditFlutterPlatform.
  XenditFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static XenditFlutterPlatform _instance = MethodChannelXenditFlutter();

  /// The default instance of [XenditFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelXenditFlutter].
  static XenditFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XenditFlutterPlatform] when
  /// they register themselves.
  static set instance(XenditFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<TokenResult> createSingleUseToken({
    required Map<String, dynamic> params,
  }) async {
    throw UnimplementedError('createSingleToken() has not been implemented');
  }

  Future<TokenResult> createMultipleUseToken({
    required Map<String, dynamic> params,
  }) async {
    throw UnimplementedError('createMultiToken() has not been implemented');
  }

  Future<AuthenticationResult> createAuthentication({
    required Map<String, dynamic> params,
  }) async {
    throw UnimplementedError('createAuthentication() has not been implemented');
  }

  Future<String?> check() async {
    throw UnimplementedError('createAuthentication() has not been implemented');
  }
}
