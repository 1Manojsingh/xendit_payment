// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import '../xendit_flutter.dart';
import 'service/platform/xendit_flutter_platform_interface.dart';

class Xendit {
  final String publishableKey;
  Xendit(this.publishableKey);

  XenditFlutterPlatform get platform => XenditFlutterPlatform.instance;

  Future<String?> getPlatformVersion() {
    return platform.getPlatformVersion();
  }

  static Future<String?> check() {
    return XenditFlutterPlatform.instance.check();
  }

  Future<TokenResult> createSingleUseToken(
    XCard card, {
    required int amount,
    bool shouldAuthenticate = true,
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    Customer? customer,
    String? currency,
  }) {
    var params = <String, dynamic>{
      'publishedKey': publishableKey,
      'card': card.to(),
      'amount': amount,
      'shouldAuthenticate': shouldAuthenticate,
      'onBehalfOf': onBehalfOf,
    };
    return platform.createSingleUseToken(params: params);
  }

  Future<TokenResult> createMultipleUseToken(
    XCard card, {
    String onBehalfOf = '',
    BillingDetails? billingDetails,
    Customer? customer,
  }) async {
    var params = <String, dynamic>{
      'publishedKey': publishableKey,
      'card': card.to(),
      'isMultipleUse': true,
      'onBehalfOf': onBehalfOf,
    };

    if (billingDetails != null) {
      params['billingDetails'] = billingDetails.to();
    }

    if (customer != null) {
      params['customer'] = customer.to();
    }

    return platform.createMultipleUseToken(params: params);
  }

  Future<AuthenticationResult> createAuthentication(
    String tokenId, {
    required int amount,
    required String currency,
  }) async {
    var params = <String, dynamic>{
      'publishedKey': publishableKey,
      'tokenId': tokenId,
      'amount': amount,
    };

    params['currency'] = currency;

    return platform.createAuthentication(params: params);
  }
}
