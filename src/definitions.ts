/// <reference types="@capacitor/cli"/>

declare module '@capacitor/cli' {
  export interface PluginsConfig {
    ApplePaySession?: {
      /**
       * The merchant ID
       */
      merchantId?: string;

      /** The payment methods (networks) that you support. */
      supportedNetworks?: ApplePayNetwork[];

      /** The merchant’s two-letter ISO 3166 country code. */
      countryCode?: string;

      /** The three-letter ISO 4217 currency code that determines the currency the payment request uses. */
      currencyCode?: string;

      /** Time to close sheet after was opened in miliseconds.
       * @default 30000 miliseconds
       */
      timeToCloseSheet?: number;
    };
  }
}

/**
 * Represents the supported payment networks for Apple Pay transactions.
 *
 * - `'visa'`: Visa card network.
 * - `'masterCard'`: MasterCard network.
 * - `'amex'`: American Express network.
 * - `'discover'`: Discover card network.
 */
export type ApplePayNetwork = 'visa' | 'mastercard' | 'amex' | 'discover';

/**
 * Represents an item in an Apple Pay payment request.
 */
export interface ApplePayItem {
  /** The total amount to be charged for the payment. */
  amount: string;
  /** A description or label for the payment request. */
  label: string;
}

/**
 * Represents a request to initiate an Apple Pay payment.
 */
export interface ApplePayRequest {
  /**An array of payment summary item objects that summarize the amount of the payment. The last item must be the total. */
  items: ApplePayItem[];
  /** The merchant’s two-letter ISO 3166 country code. */
  countryCode?: string;
  /** The three-letter ISO 4217 currency code that determines the currency the payment request uses. */
  currencyCode?: string;
  /** The payment methods (networks) that you support. */
  supportedNetworks?: ApplePayNetwork[];
  /** Your merchant Id; You can provide from Capacitor config. */
  merchantId?: string;
}

/**
 * Represents a payment request for Apple Pay Payment, extending the base `ApplePayRequest`.
 *
 * @property url - .
 * @property headers - A record of HTTP headers to include in the request.
 * @property body - The payload to be sent with the payment request.
 * @property sessionIn - The key within the body that represents the session information.
 */
export interface ApplePayPayment<Body> extends ApplePayRequest {
  /**The endpoint URL for the payment request */
  url: string;
  /**A record of HTTP headers to include in the request. */
  headers: Record<string, string>;
  /**The payload to be sent with the payment request. */
  body: Body;
  /**The key within the body where the ApplePay session will be place. */
  sessionIn: keyof Body;
}

export type ApplePayCode =
  | 'missing_merchant_id'
  | 'missing_amount'
  | 'missing_url'
  | 'missing_body'
  | 'missing_session_in'
  | 'invalid_amount'
  | 'invalid_country_code'
  | 'invalid_currency_code'
  | 'invalid_networks'
  | 'empty_supported_networks'
  | 'empty_items'
  | 'payment_authorized'
  | 'payment_reject'
  | 'session_canceled'
  | 'session_failed'
  | 'request_failed'
  | 'applepay_not_available'
  | 'paymentsheet_problem_opening'
  | 'paymentsheet_problem_closing'
  | 'applepay_error'
  | 'uknown_error';

/**
 * Represents a session for Apple Pay transactions.
 *
 * @property token - The Apple Pay payment data associated with the session.
 */
export interface AppleyPayToken {
  token: string;
}

/**
 * Represents the response from an Apple Pay payment operation.
 */
export interface ApplePayPaymentResponse<Response> {
  /**The actual response data returned from the Apple Pay payment. */
  response: Response;
}

/**
 * Represents an error that occurred during an Apple Pay operation.
 *
 * @property message - A message explaining the error.
 * @property code - Code of error.
 */
export interface ApplePayError {
  message: string;
  code: ApplePayCode;
}

export interface ApplePayServerErrorData {
  statusCode: number;
  headers?: Record<string, string>;
  error: any;
  timestamp: string;
}

export interface ApplePayStatus {
  status: 'error' | 'success';
}

export interface ApplePaySessionPlugin {
  /**
   * @method getSession
   * Initiates an Apple Pay session with the provided request details.
   * @param request - An `ApplePayRequest` object containing session configuration.
   * @returns A promise that resolves with an `AppleyPayToken` upon successful session creation.
   * @throws A promise that reject with an `ApplePayError` message.
   */
  getSession(request: ApplePayRequest): Promise<AppleyPayToken>;

  /**
   * @method initiatePayment
   * Initiates an Apple Pay Payment request using a url.
   * @param request - An `ApplePayRequest` object containing session configuration.
   * @returns A promise that resolves with an `AppleyPayToken` upon successful session creation.
   * @throws A promise that reject with an `ApplePayError` message.
   */
  initiatePayment<Body, Response>(paymentRequest: ApplePayPayment<Body>): Promise<ApplePayPaymentResponse<Response>>;

  /**
   * @method completeSession
   * Complete Apple Pay session.
   * @param status - An `ApplePayStatus` object containing session status.
   * @returns A promise that resolves with empty value.
   * @throws A promise that reject with an `ApplePayError` message.
   */
  completeSession(status: ApplePayStatus): Promise<void>;

  /**
   * @method canMakePayments
   * Check if Apple Pay is available.
   * @returns A promise that resolves **true** if Apple Pay is available.
   */
  canMakePayments(): Promise<{ status: boolean }>;
}
