Xendit Flutter is a Flutter package designed to simplify the integration of Xendit's payment gateway into your Flutter applications.
With Xendit Flutter, developers can easily create payment tokens for various payment methods, including card payments, and streamline the payment process in their Flutter apps.

Offers seamless integration with native Java (for Android) and SwiftUI (for iOS) implementations,enabling developers to leverage the power of Xendit's payment gateway within their existing native mobile applications.

## Setup
Several steps are required for this plugin to function on Android. I have attempted to ensure that there are no patches on the project side, but I have yet to find a solution for Android.

<details>
<summary>Android</summary>

1. Make sure set the `compileSdkVersion` in your "android/app/build.gradle" file to 34 and `minSdkVersion` set to 21:
   
```gradle
android {
  compileSdkVersion 34
  ...
}
defaultConfig {
  minSdkVersion 21
  ...
}

```
2. Add this code to your "AndroidManifest.xml":
```xml
<manifest
    ...
    xmlns:tools="http://schemas.android.com/tools">
    <application
        ...
        tools:replace="android:label">
        ...
    </application>
    ...
</manifest>
```
</details>

<details>
<summary>iOS</summary>
iOS only supports version 11 and above, as this is the default for the Native SDK Swift.
</details>

## Usage
There are two types of card token authentication: single-use token -> `createSingleToken` and multiple-use token -> `createMultipleUseToken`. You can also authenticate tokens that have not been verified, use `createAuthentication`. Additionally, various validators are available, such as card number validator, CVN validator, etc. Example:

```dart
final XCard card = XCard(
  creditCardNumber: "4000000000001091",
  creditCardCVN: "123",
  expirationMonth: "12",
  expirationYear: "2024",
);

final Xendit xendit = Xendit('your-publish-key');
TokenResult result = await xendit.createSingleUseToken(card, amount: 50000, currency: "IDR");

if (result.isSuccess) {
...
} else {
debugPrint(result.errorMessage);
}
```

Example use validator:

```dart
final bool numberValidator = CardValidator.isCardNumberValid("4000000000001091");

final bool expiryValidator = CardValidator.isExpiryValid("12", "2024");

final bool cvnValidator = CardValidator.isCvnValid("123");
```
## Reference
This plugin reference from [fxendit](https://pub.dev/packages/fxendit). And using SDK Xendit Java and Swift 

## Issues
Have any question, bugs, issues, or feature request you can go to our [GitHub](https://github.com/Irfan234-afif/xendit_flutter/issues).
