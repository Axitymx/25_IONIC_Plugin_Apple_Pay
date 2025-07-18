import Foundation
import PassKit

@objc public class ApplePaySession: NSObject {
    weak var delegate: ApplePayManagerDelegate?
    private var currentCompletetionUI: ((PKPaymentAuthorizationResult) -> Void)?
    private var completeSessionWithTimer = true
    private var paymentWasAuthorized: Bool = false
    private var paymentInfo: ApplePayPaymentRequest?
    private let config: ApplePayConfig
    private var timer: Timer?

    init(config: ApplePayConfig) {
        self.config = config
    }

    @objc public func getSession(
        request: ApplePayRequest,
        delegate: ApplePayManagerDelegate
    ) {
        self.delegate = delegate
        self.paymentWasAuthorized = false

        guard PKPaymentAuthorizationController.canMakePayments() else {
            return self.completeWithProcessError(error: .applePayNotAvailable)
        }

        let paymentRequest = createPaymentRequest(request: request)
        let controller = PKPaymentAuthorizationController(
            paymentRequest: paymentRequest
        )
        controller.delegate = self

        controller.present(completion: { success in
            guard success else {
                return self.completeWithProcessError(
                    error: .problemOpeningPaymentSheet
                )
            }
        })

    }

    @objc public func completeSession(
        status: String,
        delegate: ApplePayManagerDelegate
    ) {
        if self.currentCompletetionUI == nil {
            return self.completeWithProcessError(
                error: .problemClosingPaymentSheet
            )
        }
        self.timer?.invalidate()
        self.timer = nil
        self.completeSessionWithTimer = false
        let pkStatus = ApplePayConverter.convertToStatus(from: status)
        self.currentCompletetionUI?(
            PKPaymentAuthorizationResult(status: pkStatus, errors: [])
        )
        currentCompletetionUI = nil
        self.completeSessionWithTimer = true
        delegate.applePayDidFinish()
    }

    @objc public func initiatePayment(
        request: ApplePayRequest,
        paymentInfo: ApplePayPaymentRequest,
        delegate: ApplePayManagerDelegate
    ) {
        self.paymentInfo = paymentInfo
        self.getSession(request: request, delegate: delegate)
    }

    @objc public func canMakePayments() -> Bool {
        return PKPaymentAuthorizationController.canMakePayments()
    }

    private func createPaymentRequest(request: ApplePayRequest)
    -> PKPaymentRequest {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = request.merchantId
        paymentRequest.supportedNetworks = request.supportedNetworks
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = request.countryCode
        paymentRequest.currencyCode = request.currencyCode
        paymentRequest.paymentSummaryItems = request.items
        return paymentRequest
    }

    private func requestPayment(
        session: String,
        completion: @escaping (Result<[String: Any]?, NetworkError>) -> Void
    ) {
        let sessionRequest = ApplePaySessionRequest()
        let url = URL(string: self.paymentInfo!.url)
        var body = self.paymentInfo!.body
        let sessionIn = paymentInfo!.sessionIn
        body[sessionIn] = session

        sessionRequest.post(
            url: url!,
            body: body,
            headers: self.paymentInfo!.headers
        ) { result in
            completion(result)
        }
    }

    private func initiateTimerToCloseSheet() {

        self.timer = Timer.scheduledTimer(
            withTimeInterval: self.config.timeToCloseSheet,
            repeats: false
        ) { [weak self] timer in

            if self?.completeSessionWithTimer == true {
                print("[ApplePay Session] Closed by timeout")
                self?.currentCompletetionUI?(
                    PKPaymentAuthorizationResult(status: .failure, errors: nil)
                )
                self?.currentCompletetionUI = nil
            }

            timer.invalidate()
        }
    }

    private func completeWithProcessError(error: ApplePayProcessError) {
        self.delegate?.applePayDidFail(message: error.message, code: error.code)
        delegate = nil
    }

}

extension ApplePaySession: PKPaymentAuthorizationControllerDelegate {
    public func paymentAuthorizationControllerWillAuthorizePayment(
        _ controller: PKPaymentAuthorizationController
    ) {
        // This method is mandatory and runs before the user approves the payment.
        print("[ApplePay Session] Wait for user response...")
    }

    public func paymentAuthorizationControllerDidFinish(
        _ controller: PKPaymentAuthorizationController
    ) {
        controller.dismiss(completion: nil)
        if paymentWasAuthorized {
            delegate?.applePayDidFinish()
            return
        }
        self.completeWithProcessError(error: .paymentCancelled)
    }

    public func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        paymentWasAuthorized = true
        let paymentToken = payment.token.paymentData.base64EncodedString()
        if paymentToken.isEmpty {
            self.completeWithProcessError(error: .sessionFailed)
            completion(
                PKPaymentAuthorizationResult(status: .failure, errors: nil)
            )
            return
        }

        if self.paymentInfo !== nil {
            self.requestPayment(session: paymentToken) { [weak self] response in
                switch response {
                case .success(let data):
                    self?.delegate?.applePayDidPaySuccessfully(response: data!)
                    completion(
                        PKPaymentAuthorizationResult(
                            status: .success,
                            errors: nil
                        )
                    )
                case .failure(let error):
                    self?.delegate?.applePayDidPayError(
                        message: error.messagge,
                        code: error.code
                    )
                    completion(
                        PKPaymentAuthorizationResult(
                            status: .failure,
                            errors: nil
                        )
                    )
                }
            }
            return
        }
        self.delegate?.applePayDidAuthorize(token: paymentToken)
        self.currentCompletetionUI = completion
        self.initiateTimerToCloseSheet()

    }
}
