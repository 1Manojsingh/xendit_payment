//
//  ApiClient.swift
//  xendit_ios
//
//  Created by irfan on 05/01/24.
//

import Foundation

class ApiClient{
    public static let CLIENT_TYPE = "SDK";
    public static let CLIENT_API_VERSION = "2.0.0";
    public static let CLIENT_IDENTIFIER = "Xendit iOS SDK";
    
    public static let WEBAPI_FLEX_BASE_URL = "https://sandbox.webapi.visa.com"
    
    public static let PRODUCTION_XENDIT_HOST = "api.xendit.co"
    public static let PRODUCTION_XENDIT_BASE_URL = "https://" + PRODUCTION_XENDIT_HOST
    
    public static let TOKEN_CREDENTIALS_PATH = "credit_card_tokenization_configuration"
    public static let CREATE_CREDIT_CARD_PATH = "v2/credit_card_tokens"
    public static let VERIFY_AUTHENTICATION_PATH = "credit_card_authentications/:authentication_id/verification"
    public static let JWT_PATH = "/credit_card_tokens/:token_id/jwt"
    public static let GET_3DS_RECOMMENDATION_URL = "/3ds_bin_recommendation"
    public static let CREDIT_CARD_PATH = "credit_card_tokens"
    public static let AUTHENTICATION_PATH = "authentications"
    public static let TOKENIZE_CARD_PATH = "cybersource/flex/v1/"
}
