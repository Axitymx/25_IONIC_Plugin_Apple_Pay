public struct ApplePayCode {
    static let MISS_MERCHANT_ID = "missing_merchant_id"
    static let MISS_AMOUNT = "missing_amount"
    static let MISS_URL = "missing_url"
    static let MISS_BODY = "missing_body"
    static let MISS_SESSION_IN = "missing_session_in"

    static let INVALID_AMOUNT = "invalid_amount"
    static let INVALID_COUNTRY_CODE = "invalid_country_code"
    static let INVALID_CURRENCY_CODE = "invalid_currency_code"
    static let INVALID_NETWORKS = "invalid_networks"

    static let EMPTY_SUPPORTED_NETWORKS = "empty_supported_networks"
    static let EMPTY_ITEMS = "empty_items"

    static let APPLEPAY_NOT_AVAILABLE = "applepay_not_available"
    static let PROBLEM_OPENING_PAYMENTSHEET = "paymentsheet_problem_opening"
    static let PROBLEM_CLOSING_PAYMENTSHEET = "paymentsheet_problem_closing"

    static let PAYMENT_CANCELED = "session_canceled"
    static let PAYMENT_FAILED = "session_failed"
    static let APPLEPAY_ERROR = "applepay_error"
    static let REQUEST_FAILED = "request_failed"

    static let UKNOWN_ERROR = "uknown_error"

}

public enum ApplePayValidationError: Error {
    case missingMerchantId
    case missingAmount
    case invalidAmount
    case invalidCountryCode
    case invalidCurrencyCode
    case emptySupportedNetworks
    case emptyItems
    case noValidNetworks
    case missingURL
    case missingBody
    case missinSesionIn

    var code: String {
        switch self {
        case .missingMerchantId: return ApplePayCode.MISS_MERCHANT_ID
        case .missingAmount: return ApplePayCode.MISS_AMOUNT
        case .missingURL: return ApplePayCode.MISS_URL
        case .missingBody: return ApplePayCode.MISS_BODY
        case .missinSesionIn: return ApplePayCode.MISS_SESSION_IN

        case .invalidAmount: return ApplePayCode.INVALID_AMOUNT
        case .invalidCountryCode: return ApplePayCode.INVALID_COUNTRY_CODE
        case .invalidCurrencyCode: return ApplePayCode.INVALID_CURRENCY_CODE
        case .emptySupportedNetworks: return ApplePayCode.INVALID_NETWORKS
        case .emptyItems: return ApplePayCode.EMPTY_ITEMS
        case .noValidNetworks: return ApplePayCode.EMPTY_SUPPORTED_NETWORKS
        }
    }

    var message: String {
        switch self {
        case .missingMerchantId:
            return "merchantId is required."
        case .missingAmount:
            return "amount is required."
        case .invalidAmount:
            return "amount must be greater than zero."
        case .invalidCountryCode:
            return "countryCode must be a valid ISO 3166 code (ej: 'US', 'MX')."
        case .invalidCurrencyCode:
            return
                "currencyCode must be a valid ISO 4217 currency code (ej: 'USD', 'MXN')."
        case .emptySupportedNetworks:
            return "supportedNetworks must not be empty."
        case .emptyItems:
            return "Payment items must not be empty."
        case .noValidNetworks:
            return "No valid payment networks were found in supportedNetworks."
        case .missingURL:
            return "url is required."
        case .missingBody:
            return "body is required."
        case .missinSesionIn:
            return "sessionIn is required."
        }
    }
}

public enum ApplePayProcessError: Error {
    case problemOpeningPaymentSheet
    case problemClosingPaymentSheet
    case applePayNotAvailable
    case paymentCancelled
    case sessionFailed
    case unknown

    var code: String {
        switch self {
        case .problemOpeningPaymentSheet:
            return ApplePayCode.PROBLEM_OPENING_PAYMENTSHEET
        case .problemClosingPaymentSheet:
            return ApplePayCode.PROBLEM_CLOSING_PAYMENTSHEET
        case .applePayNotAvailable:
            return ApplePayCode.APPLEPAY_NOT_AVAILABLE
        case .paymentCancelled:
            return ApplePayCode.PAYMENT_CANCELED
        case .sessionFailed:
            return ApplePayCode.PAYMENT_FAILED
        case .unknown:
            return ApplePayCode.UKNOWN_ERROR
        }
    }

    var message: String {
        switch self {
        case .problemOpeningPaymentSheet:
            return "Problem opening Apple Pay sheet."
        case .problemClosingPaymentSheet:
            return "Problem closing Apple Pay sheet."
        case .applePayNotAvailable:
            return "Apple Pay is not available."
        case .paymentCancelled:
            return "Payment cancelled."
        case .sessionFailed:
            return "Ocurred a problem during session request."
        case .unknown:
            return "Unknown error."
        }
    }
}

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case serializationError(Error)
    case serverError(String)
    case invalidJSONResponse
    case noData

    var messagge: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .serializationError(let error):
            return "Serialization error: \(error.localizedDescription)"
        case .serverError(let error):
            return error
        case .invalidJSONResponse:
            return "Invalid JSON response"
        case .noData:
            return "No data"

        }
    }
    var code: String {
        return ApplePayCode.REQUEST_FAILED
    }
}
