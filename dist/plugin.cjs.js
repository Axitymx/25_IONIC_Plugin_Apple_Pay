'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const ApplePaySession = core.registerPlugin('ApplePaySession', {
    web: () => Promise.resolve().then(function () { return web; }).then((m) => new m.ApplePaySessionWeb()),
});

class AppleyPayError extends Error {
    constructor(message, code) {
        super(message);
        this.code = 'payment_reject';
        this.code = code;
    }
}
class ApplePaySessionWeb extends core.WebPlugin {
    getSession(request) {
        console.log({ request });
        throw new AppleyPayError('Apple Pay is not available on WEB', 'applepay_not_available');
    }
    initiatePayment(paymentRequest) {
        console.log({ paymentRequest });
        throw new AppleyPayError('Appl Pay is not available on WEB', 'applepay_not_available');
    }
    completeSession(status) {
        console.log(status);
        throw new AppleyPayError('Apple Pay is not available on WEB', 'applepay_not_available');
    }
    canMakePayments() {
        return Promise.resolve({ status: false });
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    ApplePaySessionWeb: ApplePaySessionWeb
});

exports.ApplePaySession = ApplePaySession;
//# sourceMappingURL=plugin.cjs.js.map
