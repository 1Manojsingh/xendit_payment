/// Card Holder Data
class CardHolderData {
  /// First name of the card holder
  final String firstName;

  /// Last name of the card holder
  final String lastName;

  /// Email of the card holder
  final String email;

  /// Phone number of the card holder
  final String phoneNumber;

  /// Creates a new card holder data instance
  CardHolderData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
  });

  /// Convert CardHolderData to Map
  Map<String, dynamic> to() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
      };
}
