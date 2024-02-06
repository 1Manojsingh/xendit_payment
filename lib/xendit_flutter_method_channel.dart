import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xendit_flutter_platform_interface.dart';

/// An implementation of [XenditFlutterPlatform] that uses method channels.
class MethodChannelXenditFlutter extends XenditFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xendit_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
