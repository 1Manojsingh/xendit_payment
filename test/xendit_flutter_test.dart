// import 'package:flutter_test/flutter_test.dart';
// import '../lib1/xendit_flutter.dart';
// import '../lib1/xendit_flutter_platform_interface.dart';
// import '../lib1/xendit_flutter_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockXenditFlutterPlatform with MockPlatformInterfaceMixin implements XenditFlutterPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   // final XenditFlutterPlatform initialPlatform = XenditFlutterPlatform.instance;

//   test('$MethodChannelXenditFlutter is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelXenditFlutter>());
//   });

//   test('getPlatformVersion', () async {
//     XenditFlutter xenditFlutterPlugin = XenditFlutter();
//     MockXenditFlutterPlatform fakePlatform = MockXenditFlutterPlatform();
//     XenditFlutterPlatform.instance = fakePlatform;

//     expect(await xenditFlutterPlugin.getPlatformVersion(), '42');
//   });
// }
