package com.axity.plugin.applepay;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "ApplePaySession")
public class ApplePaySessionPlugin extends Plugin {

    private ApplePaySession implementation = new ApplePaySession();

    @PluginMethod
    public void getSession(PluginCall call) {
        call.reject("Apple is not available on ANDROID", "applepay_not_available");
    }

    @PluginMethod
    public void initiatePayment(PluginCall call) {
        call.reject("Apple is not available on ANDROID", "applepay_not_available");
    }

    @PluginMethod
    public void completeSession(PluginCall call) {
        call.reject("Apple is not available on ANDROID", "applepay_not_available");
    }

    @PluginMethod
    public void canMakePayments(PluginCall call) {
        JSObject res = new JSObject();
        res.put("status", false);
        call.resolve(res);
    }
}
