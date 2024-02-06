import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xendit_flutter/xendit_flutter.dart';

class CreateAuthPage extends StatefulWidget {
  const CreateAuthPage({super.key});

  @override
  State<CreateAuthPage> createState() => _CreateAuthPageState();
}

class _CreateAuthPageState extends State<CreateAuthPage> {
  late GlobalKey<FormState> formKey;
  late TextEditingController tokenIdC;
  late TextEditingController amountC;
  late TextEditingController currencyC;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    tokenIdC = TextEditingController(
      text: "5bd59627156a6fe31871512a",
    );
    amountC = TextEditingController(
      text: "50000",
    );
    currencyC = TextEditingController(
      text: "IDR",
    );
    super.initState();
  }

  @override
  void dispose() {
    tokenIdC.dispose();
    amountC.dispose();
    currencyC.dispose();
    super.dispose();
  }

  void showDialogResult(AuthenticationResult result) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text('Token Result'),
        content: result.isSuccess
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Authentication ID :\n${result.authentication!.id}",
                  ),
                  Text(
                    "Card Type :\n${result.authentication!.cardInfo.type}",
                  ),
                  Text(
                    "Status :\n${result.authentication!.status}",
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
                controller: tokenIdC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field is required";
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Token ID"),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: amountC,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Amount"),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: currencyC,
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: "Currency"),
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final xendit = Xendit(
                          'xnd_public_development_DSSqXX4zz6cDgAHGDDbweG80WKDeJqIOyno06Fj3C4eYWrO4mVoRQOIYEA1Tw');
                      final resultToken = await xendit.createAuthentication(
                        tokenIdC.text,
                        amount: int.parse(amountC.text),
                        currency: "IDR",
                      );
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
