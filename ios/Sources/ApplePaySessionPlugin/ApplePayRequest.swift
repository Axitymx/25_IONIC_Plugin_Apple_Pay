import PassKit

@objc public class ApplePayRequest: NSObject {
    let merchantId: String
    let supportedNetworks: [PKPaymentNetwork]
    let countryCode: String
    let currencyCode: String
    let items: [PKPaymentSummaryItem]

    @objc public init(
        merchantId: String,
        supportedNetworks: [PKPaymentNetwork],
        countryCode: String,
        currencyCode: String,
        items: [PKPaymentSummaryItem]
    ) {
        self.merchantId = merchantId
        self.supportedNetworks = supportedNetworks
        self.countryCode = countryCode
        self.currencyCode = currencyCode
        self.items = items
    }
}

@objc public class ApplePayPaymentRequest: NSObject {
    let url: String
    let sessionIn: String
    let headers: [String: String]?
    let body: [String: Any]

    @objc public init(
        url: String,
        sessionIn: String,
        body: [String: Any],
        headers: [String: String]? = nil
    ) {
        self.url = url
        self.sessionIn = sessionIn
        self.headers = headers
        self.body = body
    }

}

public class ApplePaySessionRequest {

    public func post(
        url: URL,
        body: [String: Any],
        headers: [String: String]?,
        completion: @escaping (Result<[String: Any]?, NetworkError>) -> Void
    ) {

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set headers
        for (key, value) in headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Serialize body
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
        } catch {
            completion(.failure(.serializationError(error)))
            return
        }
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in

            DispatchQueue.main.async {
                ApplePaySessionRequest.handleResponse(
                    data: data,
                    response: response,
                    error: error,
                    completion: completion
                )
            }
        }

        task.resume()
    }

    static func handleResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<[String: Any]?, NetworkError>) -> Void
    ) {

        // Check for network error first
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }

        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.invalidResponse))
            return
        }

        // Check for HTTP success status
        guard (200...299).contains(httpResponse.statusCode) else {
            print(
                "[ApplePay Session] HTTP Error - Status Code: \(httpResponse.statusCode)"
            )
            let errorResponse = buildErrorResponse(
                statusCode: httpResponse.statusCode,
                data: data,
                headers: httpResponse.allHeaderFields
            )
            completion(
                .failure(
                    .serverError(errorResponse)
                )
            )
            return
        }

        // Ensure we have data
        guard let data = data, !data.isEmpty else {
            completion(.failure(.noData))
            return
        }

        // Parse JSON only for successful responses
        do {
            guard
                let jsonObject = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                ) as? [String: Any]
            else {
                completion(.failure(.invalidJSONResponse))
                return
            }
            completion(.success(jsonObject))
        } catch {
            completion(.failure(.invalidJSONResponse))
        }
    }

    static func buildErrorResponse(
        statusCode: Int,
        data: Data?,
        headers: [AnyHashable: Any]
    ) -> String {
        var errorResponse: [String: Any] = [
            "statusCode": statusCode,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        if let headers = headers as? [String: String] {
            errorResponse["headers"] = headers
        }

        if let data = data, !data.isEmpty {
            do {
                let jsonError = try JSONSerialization.jsonObject(
                    with: data,
                    options: []
                )

                errorResponse["error"] = jsonError

            } catch {
                // If the error isnt json try to convert to string
                let errorString =
                    String(data: data, encoding: .utf8)
                    ?? "Unable to decode error response"
                errorResponse["error"] = errorString
            }
        } else {
            errorResponse["error"] = "No error details provided"
        }

        return convertDictionaryToJsonString(from: errorResponse)
    }

    static func convertDictionaryToJsonString(from dictionary: [String: Any]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("JSON serialization error: \(error)")
            return ""
        }
    }
}
