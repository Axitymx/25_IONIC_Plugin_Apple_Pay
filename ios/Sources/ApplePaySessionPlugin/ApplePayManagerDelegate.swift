import Foundation

@objc public protocol ApplePayManagerDelegate: AnyObject {
    @objc func applePayDidAuthorize(token: String)
    @objc func applePayDidPaySuccessfully(response: [String: Any])
    @objc func applePayDidPayError(message: String, code: String)
    @objc func applePayDidFail(message: String, code: String)
    @objc func applePayDidFinish()
}
