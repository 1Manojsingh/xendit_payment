import Flutter
import UIKit
import Xendit

public class XenditFlutterPlugin: NSObject, FlutterPlugin {
    
    private var flutterViewController: FlutterViewController?
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.flutter.io/xendit", binaryMessenger: registrar.messenger())
    let instance = XenditFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
          result("iOS " + UIDevice.current.systemVersion)
        case "createToken":
            if let window = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController{
                flutterViewController = window
            }else{
                print("saalah")
            }
            createToken(call: call,result: result)
        case "createAuthentication":
            if let window = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController{
                flutterViewController = window
            }else{
                print("saalah")
            }
            createAuthentication(call: call, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    
    public func createToken(call: FlutterMethodCall,result: @escaping FlutterResult){
        var argument:[String: Any] = [:]
        let cardDataArg = argument["card"]
        var publishableKey = ""
        if let arguments = call.arguments as? Dictionary<String, Any>,
           let _ = arguments["publishedKey"] as? String{
            publishableKey = arguments["publishedKey"] as! String
            argument = arguments
        }
        Xendit.publishableKey = publishableKey
        let cardData = cardFrom(call: call)
        
        let isMultipleUse = argument["isMultipleUse"] as? Bool ?? false
        let currency = argument["currency"] ?? "IDR"
        var amount: NSNumber? = nil;
        if argument["amount"] != nil{
            amount = NSNumber(value: (argument["amount"] as! Int64))
        }
        let onBehalfOf = argument["onBehalfOf"] ?? ""
        
        let customer = customerFrom(call: call)
        let billingDetails = billingFrom(call: call)

        
         let tokenizationRequest = XenditTokenizationRequest.init(cardData: cardData as! XenditCardData, isSingleUse: !isMultipleUse, shouldAuthenticate: true, amount: amount, currency: currency as! String)
         tokenizationRequest.customer = customer
         tokenizationRequest.billingDetails = billingDetails

         Xendit.createToken(fromViewController: flutterViewController!, tokenizationRequest: tokenizationRequest, onBehalfOf: onBehalfOf as! String) { [self] (token, error) in
             if let token = token {
                 result(tokenToMap(token: token))
             } else {
                 result(FlutterError(code: error?.errorCode ?? "500", message: error?.message, details: nil))
             }
         }
    }
  
    
    public func createAuthentication(call: FlutterMethodCall, result: @escaping FlutterResult){
        var argument:[String: Any] = [:]
        var publishableKey = ""
        if let arguments = call.arguments as? Dictionary<String, Any>,
           let _ = arguments["publishedKey"] as? String{
            publishableKey = arguments["publishedKey"] as! String
            argument = arguments
        }
        Xendit.publishableKey = publishableKey
        
        let tokenId = argument["tokenId"] as! String
        let amount = NSNumber(value: (argument["amount"] as! Int64))
        let currency = argument["currency"] as! String
        
        let xenditAuthReq = XenditAuthenticationRequest(tokenId: tokenId, amount: amount, currency: currency)
        Xendit.createAuthentication(fromViewController: flutterViewController!, authenticationRequest: xenditAuthReq, onBehalfOf: nil){ [self](authentication, error) in
            if authentication != nil {
                result(authToMap(authentication: authentication!))
            }else{
                result(FlutterError(code: error!.errorCode, message: error!.message, details: nil))
            }
        }
    }

    
    private func cardFrom(call: FlutterMethodCall) -> XenditCardData? {
        if let cardMap = call.arguments as? [String: Any],
           let cardArgs = cardMap["card"] as? [String:Any],
            
        
           let creditCardNumber = cardArgs["creditCardNumber"] as? String,
           let creditCardCVN = cardArgs["creditCardCVN"] as? String,
           let expirationMonth = cardArgs["expirationMonth"] as? String,
           let expirationYear = cardArgs["expirationYear"] as? String {
            var cardData =  XenditCardData.init(cardNumber: creditCardNumber, cardExpMonth: expirationMonth, cardExpYear: expirationYear)
            cardData.cardCvn = creditCardCVN
            return cardData
        }
        
        return nil
    }

    
    private func billingFrom(call: FlutterMethodCall) -> XenditBillingDetails {
        if let billingDetailsMap = call.arguments as? [String: Any],
           let billingDetailsArgs = billingDetailsMap["billingDetails"] as? [String: Any] {
            
            var billingDetails = XenditBillingDetails()
            
            billingDetails.givenNames = billingDetailsArgs["givenNames"] as? String ?? ""
            billingDetails.surname = billingDetailsArgs["surname"] as? String ?? ""
            billingDetails.email = billingDetailsArgs["email"] as? String ?? ""
            billingDetails.mobileNumber = billingDetailsArgs["mobileNumber"] as? String ?? ""
            billingDetails.phoneNumber = billingDetailsArgs["phoneNumber"] as? String ?? ""

            if let addressArgs = billingDetailsArgs["address"] as? [String: Any] {
                var address = XenditAddress()

                address.country = addressArgs["country"] as? String ?? ""
                address.streetLine1 = addressArgs["streetLine1"] as? String ?? ""
                address.streetLine2 = addressArgs["streetLine2"] as? String ?? ""
                address.city = addressArgs["city"] as? String ?? ""
                address.provinceState = addressArgs["provinceState"] as? String ?? ""
                address.postalCode = addressArgs["postalCode"] as? String ?? ""
                address.category = addressArgs["category"] as? String ?? ""

                billingDetails.address = address
            }

            return billingDetails
        }

        return XenditBillingDetails()
    }
    
    func customerFrom(call: FlutterMethodCall) -> XenditCustomer {
        let customer = XenditCustomer()

        if let customerMap = call.arguments as? [String: Any],
           let customerArgs = customerMap["customer"] as? [String: Any] {

            customer.referenceId = customerArgs["referenceId"] as? String
            customer.email = customerArgs["email"] as? String
            customer.givenNames = customerArgs["givenNames"] as? String
            customer.surname = customerArgs["surname"] as? String
            customer.description = customerArgs["description"] as? String
            customer.mobileNumber = customerArgs["mobileNumber"] as? String
            customer.phoneNumber = customerArgs["phoneNumber"] as? String
            customer.nationality = customerArgs["nationality"] as? String
            customer.dateOfBirth = customerArgs["dateOfBirth"] as? String
            // print(customer)
             


            if let addressesList = customerArgs["addresses"] as? [[String: Any]], !addressesList.isEmpty {
                var addresses = [XenditAddress]()

                for aMap in addressesList {
                    var address = XenditAddress()

                    address.country = aMap["country"] as? String
                    address.streetLine1 = aMap["streetLine1"] as? String
                    address.streetLine2 = aMap["streetLine2"] as? String
                    address.city = aMap["city"] as? String
                    address.provinceState = aMap["provinceState"] as? String
                    address.postalCode = aMap["postalCode"] as? String
                    address.category = aMap["category"] as? String

                    addresses.append(address)
                }

                customer.addresses = addresses
            }else{
                let address = XenditAddress()
                customer.addresses = [address]
            }
        }

        return customer
    }

    private func tokenToMap(token: XenditCCToken) -> [String: Any] {
        var result: [String: Any] = [:]
        result["id"] = token.id
        result["status"] = token.status
        result["authenticationId"] = token.authenticationId
        result["maskedCardNumber"] = token.maskedCardNumber
        result["authentication_url"] = (token.authenticationId)
        result["authentication_id"] = (token.authenticationId)
        result["cardInfo"] = cardInfoToMap(cardInfo: token.cardInfo)
        return result
    }
    
    private func authToMap(authentication: XenditAuthentication)-> [String:Any]{
        var result: [String: Any] = [:]
        result["id"] = authentication.id
        result["creditCardTokenId"] = authentication.tokenId
        result["payerAuthenticationUrl"] = authentication.authenticationURL
        result["status"] = authentication.status
        result["maskedCardNumber"] = authentication.maskedCardNumber
        result["requestPayload"] = authentication.requestPayload
        result["authenticationTransactionId"] = authentication.authenticationTransactionId
        result["cardInfo"] = cardInfoToMap(cardInfo: authentication.cardInfo)
        return result
    }

    private func cardInfoToMap(cardInfo: XenditCardMetadata?) -> [String: Any] {
        guard let cardInfo = cardInfo else {
            return [:]
        }

        var result: [String: Any] = [:]
        result["bank"] = cardInfo.bank
        result["country"] = cardInfo.country
        result["type"] = cardInfo.type
        result["brand"] = cardInfo.brand
        result["cardArtUrl"] = cardInfo.cardArtUrl
        result["fingerprint"] = cardInfo.fingerprint
        return result
    }

}
