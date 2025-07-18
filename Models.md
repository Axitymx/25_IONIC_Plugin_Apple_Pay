

## API

<docgen-index>

* [`getSession(...)`](#getsession)
* [`initiatePayment(...)`](#initiatepayment)
* [`completeSession(...)`](#completesession)
* [`canMakePayments()`](#canmakepayments)
* [Interfaces](#interfaces)
* [Type Aliases](#type-aliases)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### getSession(...)

```typescript
getSession(request: ApplePayRequest) => Promise<AppleyPayToken>
```

| Param         | Type                                                        | Description                                                                                    |
| ------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| **`request`** | <code><a href="#applepayrequest">ApplePayRequest</a></code> | - An <a href="#applepayrequest">`ApplePayRequest`</a> object containing session configuration. |

**Returns:** <code>Promise&lt;<a href="#appleypaytoken">AppleyPayToken</a>&gt;</code>

--------------------


### initiatePayment(...)

```typescript
initiatePayment<Body, Response>(paymentRequest: ApplePayPayment<Body>) => Promise<ApplePayPaymentResponse<Response>>
```

| Param                | Type                                                                    |
| -------------------- | ----------------------------------------------------------------------- |
| **`paymentRequest`** | <code><a href="#applepaypayment">ApplePayPayment</a>&lt;Body&gt;</code> |

**Returns:** <code>Promise&lt;<a href="#applepaypaymentresponse">ApplePayPaymentResponse</a>&lt;Response&gt;&gt;</code>

--------------------


### completeSession(...)

```typescript
completeSession(status: ApplePayStatus) => Promise<void>
```

| Param        | Type                                                      | Description                                                                           |
| ------------ | --------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| **`status`** | <code><a href="#applepaystatus">ApplePayStatus</a></code> | - An <a href="#applepaystatus">`ApplePayStatus`</a> object containing session status. |

--------------------


### canMakePayments()

```typescript
canMakePayments() => Promise<{ status: boolean; }>
```

**Returns:** <code>Promise&lt;{ status: boolean; }&gt;</code>

--------------------


### Interfaces


#### AppleyPayToken

Represents a session for Apple Pay transactions.

| Prop        | Type                |
| ----------- | ------------------- |
| **`token`** | <code>string</code> |


#### ApplePayRequest

Represents a request to initiate an Apple Pay payment.

| Prop                    | Type                           | Description                                                                                                         |
| ----------------------- | ------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **`items`**             | <code>ApplePayItem[]</code>    | An array of payment summary item objects that summarize the amount of the payment. The last item must be the total. |
| **`countryCode`**       | <code>string</code>            | The merchant’s two-letter ISO 3166 country code.                                                                    |
| **`currencyCode`**      | <code>string</code>            | The three-letter ISO 4217 currency code that determines the currency the payment request uses.                      |
| **`supportedNetworks`** | <code>ApplePayNetwork[]</code> | The payment methods (networks) that you support.                                                                    |
| **`merchantId`**        | <code>string</code>            | Your merchant Id; You can provide from Capacitor config.                                                            |


#### ApplePayItem

Represents an item in an Apple Pay payment request.

| Prop         | Type                | Description                                     |
| ------------ | ------------------- | ----------------------------------------------- |
| **`amount`** | <code>string</code> | The total amount to be charged for the payment. |
| **`label`**  | <code>string</code> | A description or label for the payment request. |


#### ApplePayPaymentResponse

Represents the response from an Apple Pay payment operation.

| Prop           | Type                  | Description                                                   |
| -------------- | --------------------- | ------------------------------------------------------------- |
| **`response`** | <code>Response</code> | The actual response data returned from the Apple Pay payment. |


#### ApplePayPayment

Represents a payment request for Apple Pay Payment, extending the base <a href="#applepayrequest">`ApplePayRequest`</a>.

| Prop            | Type                                                            | Description                                                       |
| --------------- | --------------------------------------------------------------- | ----------------------------------------------------------------- |
| **`url`**       | <code>string</code>                                             | The endpoint URL for the payment request                          |
| **`headers`**   | <code><a href="#record">Record</a>&lt;string, string&gt;</code> | A record of HTTP headers to include in the request.               |
| **`body`**      | <code>Body</code>                                               | The payload to be sent with the payment request.                  |
| **`sessionIn`** | <code>keyof Body</code>                                         | The key within the body where the ApplePay session will be place. |


#### ApplePayStatus

| Prop         | Type                              |
| ------------ | --------------------------------- |
| **`status`** | <code>'error' \| 'success'</code> |


### Type Aliases


#### ApplePayNetwork

Represents the supported payment networks for Apple Pay transactions.

- `'visa'`: Visa card network.
- `'masterCard'`: MasterCard network.
- `'amex'`: American Express network.
- `'discover'`: Discover card network.

<code>'visa' | 'mastercard' | 'amex' | 'discover'</code>


#### Record

Construct a type with a set of properties K of type T

<code>{
 [P in K]: T;
 }</code>

</docgen-api>
