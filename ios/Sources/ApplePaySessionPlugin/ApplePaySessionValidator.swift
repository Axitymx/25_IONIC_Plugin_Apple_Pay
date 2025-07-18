import Capacitor
import PassKit
import Foundation

public class ApplePaySessionValidator {
    private let config: ApplePayConfig

    init(config: ApplePayConfig) {
        self.config = config
    }

    public func validateAndCreateRequest(from call: CAPPluginCall) throws -> ApplePayRequest {

        guard let merchantId = call.getString("merchantId") ?? config.merchantId, !merchantId.isEmpty else {
            throw ApplePayValidationError.missingMerchantId
        }

        let supportedNetworksArray = call.getArray("supportedNetworks") as? [String] ??  config.supportedNetworks
        guard !supportedNetworksArray.isEmpty else {
            throw ApplePayValidationError.emptySupportedNetworks
        }

        let validNetworks = ApplePayConverter.convertToPaymentNetworks(from: supportedNetworksArray)
        guard !validNetworks.isEmpty else {
            throw ApplePayValidationError.noValidNetworks
        }

        let countryCode = call.getString("countryCode") ?? config.countryCode
        guard countryCode.count == 2 else {
            throw ApplePayValidationError.invalidCountryCode
        }

        let currencyCode = call.getString("currencyCode") ?? config.currencyCode
        guard currencyCode.count == 3 else {
            throw ApplePayValidationError.invalidCurrencyCode
        }

        let itemsArray: [[String: String]] = call.getArray("items") as? [[String: String]] ?? []
        guard !itemsArray.isEmpty else {
            throw ApplePayValidationError.emptyItems
        }

        let validItems = ApplePayConverter.convertToPaymentItems(from: itemsArray)

        return ApplePayRequest(
            merchantId: merchantId,
            supportedNetworks: validNetworks,
            countryCode: countryCode,
            currencyCode: currencyCode,
            items: validItems
        )
    }

    public func validateAndCreatePaymentRequest(from call: CAPPluginCall) throws -> ApplePayPaymentRequest {
        guard let url = call.getString("url"), !url.isEmpty else {
            throw ApplePayValidationError.missingURL
        }

        guard let body = call.getObject("body") else {
            throw ApplePayValidationError.missingBody
        }

        guard let sessionin = call.getString("sessionIn") else {
            throw ApplePayValidationError.missingBody
        }

        let headers = call.getObject("headers") as? [String: String] ?? nil

        return ApplePayPaymentRequest(
            url: url,
            sessionIn: sessionin,
            body: body,
            headers: headers
        )
    }

}
