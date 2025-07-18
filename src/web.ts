import { WebPlugin } from '@capacitor/core';

import type {
  ApplePayPayment,
  ApplePayCode,
  ApplePayPaymentResponse,
  ApplePayRequest,
  ApplePaySessionPlugin,
  AppleyPayToken,
  ApplePayStatus,
} from './definitions';

class AppleyPayError extends Error {
  code: ApplePayCode = 'payment_reject';

  constructor(message: string, code: ApplePayCode) {
    super(message);
    this.code = code;
  }
}

export class ApplePaySessionWeb extends WebPlugin implements ApplePaySessionPlugin {
  getSession(request: ApplePayRequest): Promise<AppleyPayToken> {
    console.log({ request });
    throw new AppleyPayError('Apple Pay is not available on WEB', 'applepay_not_available');
  }

  initiatePayment<Body, Response>(paymentRequest: ApplePayPayment<Body>): Promise<ApplePayPaymentResponse<Response>> {
    console.log({ paymentRequest });
    throw new AppleyPayError('Appl Pay is not available on WEB', 'applepay_not_available');
  }

  completeSession(status: ApplePayStatus): Promise<void> {
    console.log(status);
    throw new AppleyPayError('Apple Pay is not available on WEB', 'applepay_not_available');
  }

  canMakePayments(): Promise<{ status: boolean }> {
    return Promise.resolve({ status: false });
  }
}
