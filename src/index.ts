import { registerPlugin } from '@capacitor/core';

import type { ApplePaySessionPlugin } from './definitions';

const ApplePaySession = registerPlugin<ApplePaySessionPlugin>('ApplePaySession', {
  web: () => import('./web').then((m) => new m.ApplePaySessionWeb()),
});

export * from './definitions';
export { ApplePaySession };
