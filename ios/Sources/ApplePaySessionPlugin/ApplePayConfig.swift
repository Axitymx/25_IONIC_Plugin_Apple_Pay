import Capacitor
import Foundation
import PassKit

public class ApplePayConfig {
    static let DEFAULT_TIME_TO_CLOSE_SHEET: Int = 30

    public let merchantId: String?
    public let supportedNetworks: [String]
    public let countryCode: String
    public let currencyCode: String
    public let timeToCloseSheet: Double

    init(_ config: PluginConfig) {
        self.merchantId = config.getString("merchantId")

        self.supportedNetworks =
            config.getArray("supportedNetworks") as? [String] ?? []

        self.countryCode = config.getString("countryCode") ?? ""
        self.currencyCode = config.getString("currencyCode") ?? ""
        self.timeToCloseSheet =
            Double(
                (config.getInt(
                    "timeToCloseSheet",
                    ApplePayConfig.DEFAULT_TIME_TO_CLOSE_SHEET
                ))
            ) / 1000.0
    }
}

public class ApplePayConverter {

    static func convertToPaymentNetworks(from networkStrings: [String])
    -> [PKPaymentNetwork] {
        var networks: [PKPaymentNetwork] = []

        for networkString in networkStrings {
            switch networkString.lowercased() {
            case "visa":
                networks.append(.visa)
            case "mastercard", "masterCard":
                networks.append(.masterCard)
            case "amex":
                networks.append(.amex)
            case "discover":
                networks.append(.discover)
            default:
                print(
                    "[ApplePay Session] Network not supported: \(networkString)"
                )
            }
        }

        return networks
    }

    static func convertToPaymentItems(from paymentItems: [[String: String]])
    -> [PKPaymentSummaryItem] {
        var summaryItems: [PKPaymentSummaryItem] = []

        for item in paymentItems {
            let summaryItem = PKPaymentSummaryItem(
                label: item["label"]!,
                amount: NSDecimalNumber(string: item["amount"]!, )
            )
            summaryItems.append(summaryItem)
        }

        return summaryItems
    }

    static func convertToStatus(from statusString: String)
    -> PKPaymentAuthorizationStatus {
        switch statusString.lowercased() {
        case "success":
            return .success
        case "failure":
            return .failure
        default:
            return .failure
        }
    }

}
