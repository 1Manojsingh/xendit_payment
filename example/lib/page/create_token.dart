import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendit_flutter/xendit_flutter.dart';

class CreateTokenPage extends StatefulWidget {
  const CreateTokenPage({super.key});

  @override
  State<CreateTokenPage> createState() => _CreateTokenPageState();
}

class _CreateTokenPageState extends State<CreateTokenPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController cardNumberC;
  late TextEditingController cardDateC;
  late TextEditingController cardCvnC;
  late TextEditingController amountC;

  late bool isMultipleUse;

  @override
  void initState() {
    isMultipleUse = false;
    formKey = GlobalKey<FormState>();
    cardNumberC = TextEditingController(
      text: "4000000000001091",
    );
    cardDateC = TextEditingController(text: "12/2024");
    cardCvnC = TextEditingController(
      text: "123",
    );
    amountC = TextEditingController(
      text: '50000',
    );
    super.initState();
  }

  @override
  void dispose() {
    cardNumberC.dispose();
    cardDateC.dispose();
    cardCvnC.dispose();
    amountC.dispose();
    super.dispose();
  }

  void showDialogResult(TokenResult result) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Token Result'),
        content: result.isSuccess
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Token ID :\n${result.token!.id}",
                  ),
                  Text(
                    "Token Authentication ID :\n${result.token!.authenticationId}",
                  ),
                  Text(
                    "Card Info:\n${result.token!.cardInfo}",
                  ),
                  Text(
                    "Status :\n${result.token!.status}",
                  ),
                ],
              )
            : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Error Code :\n${result.errorCode}",
                  ),
                  Text(
                    "Error Message :\n${result.errorMessage}",
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Back"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: cardNumberC,
                validator: (value) {
                  if (value?.isNotEmpty ?? false) {
                    if (cardCvnC.text.isEmpty) {
                      final validator = CardValidator.isCardNumberValid(value!);
                      if (!validator) {
                        return "Card is invalid";
                      }
                    } else {
                      final validator = CardValidator.isCvnValidForCardType(cardCvnC.text, value);
                      if (!validator) {
                        return "Card and CVN is invalid";
                      }
                    }
                  } else {
                    return "This field cant be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Card Number"),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: cardDateC,
                      maxLength: 7,
                      onChanged: (value) {
                        if (value.length == 2) {
                          cardDateC.text += '/';
                        }
                      },
                      buildCounter: (context,
                              {required currentLength, required isFocused, maxLength}) =>
                          null,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (value.length < 7) {
                            return 'Valid Thru MM/YYYY';
                          }
                          bool isValid = CardValidator.isExpiryValid(
                              value.substring(0, 2), value.substring(3, 7));
                          if (isValid) {
                            return null;
                          } else {
                            return "Expiry not valid";
                          }
                        } else {
                          return "This field is required";
                        }
                      },
                      decoration: InputDecoration(labelText: "Expiry Date"),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: cardCvnC,
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          bool isValidForCardType =
                              CardValidator.isCvnValidForCardType(value, cardNumberC.text);
                          bool isValid = CardValidator.isCvnValid(value);
                          if (isValid && isValidForCardType) {
                            return null;
                          } else {
                            return "Card CVN not valid";
                          }
                        } else {
                          return "This field is required";
                        }
                      },
                      decoration: InputDecoration(labelText: "CVN"),
                    ),
                  ),
                ],
              ),
              TextFormField(
                enabled: !isMultipleUse,
                controller: amountC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Amount"),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              CheckboxListTile.adaptive(
                value: isMultipleUse,
                onChanged: (value) {
                  setState(() {
                    isMultipleUse = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('Multiple Use'),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final XCard card = XCard(
                        creditCardNumber: cardNumberC.text,
                        creditCardCVN: cardCvnC.text,
                        expirationMonth: cardDateC.text.substring(0, 2),
                        expirationYear: cardDateC.text.substring(3, 7),
                      );
                      final xendit = Xendit(
                          'xnd_public_development_DSSqXX4zz6cDgAHGDDbweG80WKDeJqIOyno06Fj3C4eYWrO4mVoRQOIYEA1Tw');
                      late TokenResult resultToken;
                      if (isMultipleUse) {
                        resultToken = await xendit.createMultipleUseToken(card);
                      } else {
                        resultToken = await xendit.createSingleUseToken(
                          card,
                          amount: int.parse(amountC.text),
                        );
                      }
                      log(resultToken.token?.id ?? 'gagal');
                      showDialogResult(resultToken);
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
