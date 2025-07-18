# @capacitor/applepay

Plugin to get an Apple Pay session

## Install

```bash
npm install github:Axitymx/25_IONIC_Plugin_Apple_Pay.git#v1.0.0
npx cap sync
```

## Configuration
To generate an Apple Pay session, it is necessary to provide information such as `countryCode` or `currencyCode`. You can include this information when defining a `paymentRequest` ([`ApplePayRequest`](./Models.md#applepayrequest)), but it is also possible to set certain parameters within the Capacitor configuration.

```typescript
//capacitor.config.ts
{
  plugins: {
    ..., 
    ApplePaySession: {
      merchantId: 'YOUR_MERCHANT_ID',
      countryCode: 'CC',
      currencyCode: 'CCC',
      supportedNetworks: ["visa"],
      //Time to close sheet after was opened in miliseconds. Default value = 30000 ms
      timeToCloseSheet: 5000
    }
  }
}
```
> The parameters defined in `paymentRequest` will take precedence over the values set in the `capacitor.config.ts` configuration.


## ApplePaySession service

```typescript
import { Injectable } from '@angular/core';
import {ApplePayRequest, ApplePaySession, ApplePayStatus, ApplePayError} from "@capacitor/applepay";

@Injectable({
  providedIn: 'root'
})
export class ApplepaysessionService {


  public async canMakePayment(): Promise<boolean>{
    const { status } = await ApplePaySession.canMakePayments();

    return status;
  }

  public async getSession(paymentRequest: ApplePayRequest): Promise< string | null >{
    try{
      const { token } = await ApplePaySession.getSession(paymentRequest);
      
      return token;
    }catch(e){
      const {message, code} = (e as ApplePayError)
      console.log({message, code});

      if(code === "paymentsheet_problem_opening"){
        console.log("Un problema en la configuración del esquema - XCODE")
      }

      if(code === "applepay_not_available"){
        console.log("Apple pay no disponible")
      }

      if(code === "session_canceled"){
        console.log("El usuario cerro el UI nativo")
      }

      if(code === "session_failed"){
        console.log("No se creo la sesión")
      }

      return null
    }
  }

  public async completeSession(status: ApplePayStatus ): Promise<boolean> {
    try{
      await ApplePaySession.completeSession(status);
      return true
    }catch(e){
      const {message, code} = (e as ApplePayError)
      console.log({message, code});

      if(code === "paymentsheet_problem_closing"){
        console.log("El modal se cerro porque se acabo el tiempo de espera `timeToCloseSheet`")
      }
      return false
    }
  }
}
```
