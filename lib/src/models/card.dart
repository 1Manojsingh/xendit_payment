import '../utils/validator.dart';
import 'card_holder_data.dart';

/// Credit Card
class XCard {
  /// Credit Card Number
  final String creditCardNumber;

  /// Credit Card CVN
  final String creditCardCVN;

  /// Card Expiration Month
  final String expirationMonth;

  /// Card Expiration Year
  final String expirationYear;

  /// Card Holder Data
  final CardHolderData? cardHolderData;

  XCard({
    required String creditCardNumber,
    required String creditCardCVN,
    required this.expirationMonth,
    required this.expirationYear,
    this.cardHolderData,
  })  : creditCardNumber = CardValidator.cleanCardNumber(creditCardNumber),
        creditCardCVN = CardValidator.cleanCvn(creditCardCVN);

  /// Convert XCard to Map
  Map<String, dynamic> to() {
    final Map<String, dynamic> cardMap = {
      'creditCardNumber': creditCardNumber,
      'creditCardCVN': creditCardCVN,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
    };

    return cardMap;
  }
}
