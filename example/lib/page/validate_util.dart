import 'package:flutter/material.dart';
import 'package:xendit_flutter/xendit_flutter.dart';

class ValidateUtilPage extends StatefulWidget {
  const ValidateUtilPage({super.key});

  @override
  State<ValidateUtilPage> createState() => _ValidateUtilPageState();
}

class _ValidateUtilPageState extends State<ValidateUtilPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController cardNumberC;
  late TextEditingController monthC;
  late TextEditingController yearC;
  late TextEditingController cardCvnC;
  late TextEditingController amountC;

  late bool isDialogOpen;

  @override
  void initState() {
    isDialogOpen = false;
    formKey = GlobalKey<FormState>();
    cardNumberC = TextEditingController(
      text: "4000000000001091",
    );
    monthC = TextEditingController(text: "12");
    yearC = TextEditingController(text: "2024");
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
    monthC.dispose();
    yearC.dispose();
    cardCvnC.dispose();
    amountC.dispose();
    super.dispose();
  }

  void showDialogValidate(bool isSucces, [String? errorText]) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(isSucces ? "Validate Success" : "Validate Error"),
        content: Text(
          isSucces ? "Validation is fully success" : errorText!,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isDialogOpen = false;
              });
              Navigator.pop(context);
            },
            child: Text('Back'),
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
        child: Column(
          children: [
            TextField(
              controller: cardNumberC,
              decoration: InputDecoration(labelText: "Card Number"),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: monthC,
                    decoration: InputDecoration(labelText: "Expiry Month"),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: yearC,
                    decoration: InputDecoration(labelText: "Expiry Year"),
                  ),
                ),
              ],
            ),
            TextField(
              controller: cardCvnC,
              decoration: InputDecoration(labelText: "CVN"),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // if (cardNumberC.text.isNotEmpty) {
                  final bool numberValidator = CardValidator.isCardNumberValid(cardNumberC.text);
                  if (!numberValidator) {
                    isDialogOpen = true;
                    showDialogValidate(
                      false,
                      "Card Number Invalid",
                    );
                  }
                  // } else if (monthC.text.isNotEmpty && yearC.text.isNotEmpty) {
                  final bool expiryValidator = CardValidator.isExpiryValid(monthC.text, yearC.text);
                  if (!expiryValidator && !isDialogOpen) {
                    isDialogOpen = true;
                    showDialogValidate(
                      false,
                      "Expiry Date is Invalid",
                    );
                  }
                  // } else if (cardCvnC.text.isNotEmpty) {
                  final bool cvnValidator = CardValidator.isCvnValid(cardCvnC.text);
                  if (!cvnValidator && !isDialogOpen) {
                    isDialogOpen = true;
                    showDialogValidate(
                      false,
                      "CVN is Invalid",
                    );
                  }
                  if (numberValidator && expiryValidator && cvnValidator) {
                    showDialogValidate(true);
                  }

                  // }
                },
                child: Text("Validate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
