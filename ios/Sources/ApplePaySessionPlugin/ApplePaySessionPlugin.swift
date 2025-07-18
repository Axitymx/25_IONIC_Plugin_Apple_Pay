import Foundation
import Capacitor
import PassKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(ApplePaySessionPlugin)
public class ApplePaySessionPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "ApplePaySessionPlugin"
    public let jsName = "ApplePaySession"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "completeSession", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "initiatePayment", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "canMakePayments", returnType: CAPPluginReturnPromise)
    ]
    private var implementation: ApplePaySession!
    private var config: ApplePayConfig!
    private var validator: ApplePaySessionValidator!
    private var currentCall: CAPPluginCall?
    private let genericError = ApplePayProcessError.unknown

    override public func load() {
        self.config = ApplePayConfig(self.getConfig())
        self.validator = ApplePaySessionValidator(config: self.config)
        self.implementation = ApplePaySession(config: self.config)
    }

    @objc func getSession(_ call: CAPPluginCall) {
        self.currentCall = call

        do {
            let request = try self.validator.validateAndCreateRequest(from: call)

            print("[ApplePay Session] Initiating Apple Pay session")
            implementation.getSession(request: request, delegate: self)

        } catch let error as ApplePayValidationError {
            call.reject(error.message, error.code, nil)
            currentCall = nil
        } catch let error as ApplePayProcessError {
            call.reject(error.message, error.code, nil)
            currentCall = nil
        } catch let error {
            call.reject(genericError.message, genericError.code, error.localizedDescription as? Error)
            currentCall = nil
        }
    }

    @objc func initiatePayment(_ call: CAPPluginCall) {

        self.currentCall = call

        do {
            let request = try self.validator.validateAndCreateRequest(from: call)
            let paymentInfo = try self.validator.validateAndCreatePaymentRequest(from: call)

            print("[ApplePay Session] Request And Payment info correct; initiating Apple Pay payment")
            implementation.initiatePayment(request: request, paymentInfo: paymentInfo, delegate: self)

        } catch let error as ApplePayValidationError {
            call.reject(error.message, error.code, nil)
            currentCall = nil
        } catch let error as ApplePayProcessError {
            call.reject(error.message, error.code, nil)
            currentCall = nil
        } catch let error {
            call.reject(genericError.message, genericError.code, error.localizedDescription as? Error )
            currentCall = nil
        }
    }

    @objc func completeSession(_ call: CAPPluginCall) {
        let status = call.getString("status") ?? "error"

        self.currentCall = call
        print("[ApplePay Session] Completing last session.")
        implementation.completeSession(status: status, delegate: self)
    }

    @objc func canMakePayments(_ call: CAPPluginCall) {
        let canMakePay = implementation.canMakePayments()

        call.resolve(["status": canMakePay])
    }
}

extension ApplePaySessionPlugin: ApplePayManagerDelegate {

    public func applePayDidAuthorize(token: String) {
        print("[ApplePay Session] Apple Pay session authorized")

        currentCall?.resolve(["token": token])
        currentCall = nil
    }

    public func applePayDidFail(message: String, code: String) {
        print("[ApplePay Session] Apple Pay session failed: \(message)")
        currentCall?.reject(message, code, nil)
        currentCall = nil
    }

    public func applePayDidFinish( ) {
        print("[ApplePay Session] Apple Pay session finished")
        currentCall?.resolve()
        currentCall = nil
    }

    public func applePayDidPaySuccessfully(response: [String: Any]) {
        self.currentCall?.resolve(["response": response])
        self.currentCall = nil
    }

    public func applePayDidPayError(message: String, code: String) {
        self.currentCall?.reject(message, code)
        self.currentCall = nil
    }
}
