import { registerPlugin } from '@capacitor/core';
const ApplePaySession = registerPlugin('ApplePaySession', {
    web: () => import('./web').then((m) => new m.ApplePaySessionWeb()),
});
export * from './definitions';
export { ApplePaySession };
//# sourceMappingURL=index.js.map