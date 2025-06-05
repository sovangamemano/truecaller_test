package com.example.truecaller_test;

import android.graphics.Color;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentActivity;

import com.truecaller.android.sdk.oAuth.CodeVerifierUtil;
import com.truecaller.android.sdk.oAuth.TcOAuthCallback;
import com.truecaller.android.sdk.oAuth.TcOAuthData;
import com.truecaller.android.sdk.oAuth.TcOAuthError;
import com.truecaller.android.sdk.oAuth.TcSdk;
import com.truecaller.android.sdk.oAuth.TcSdkOptions;

import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.Map;

import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log; // Import for logging

public class MainActivity extends FlutterFragmentActivity {

    private static final String CHANNEL = "truecaller_sdk";
    private static final String EVENT_CHANNEL = "truecaller_sdk_events";
    private static final String TAG = "TruecallerSDK"; // Log tag
    private static EventChannel.EventSink eventSink;

    private String codeVerifier;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        Log.d(TAG, "Configuring Flutter engine and setting up MethodChannel");

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
                Log.d(TAG, "Received method call: " + call.method);

                switch (call.method) {
                    case "initialize":
                        initializeSdk(call.arguments, result);
                        break;
                    case "invoke":
                        invokeSdk(result);
                        break;
                    case "isUsable":
                        isSdkUsable(result);
                        break;
                    default:
                        Log.w(TAG, "Unknown method called: " + call.method);
                        result.notImplemented();
                        break;
                }
            });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
            .setStreamHandler(new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object arguments, EventChannel.EventSink sink) {
                    Log.d(TAG, "Event channel listening started");
                    eventSink = sink;
                }

                @Override
                public void onCancel(Object arguments) {
                    Log.d(TAG, "Event channel cancelled");
                    eventSink = null;
                }
            });
    }

    private void initializeSdk(Object arguments, MethodChannel.Result result) {
        try {
            Log.d(TAG, "Initializing SDK with arguments: " + arguments.toString());

            @SuppressWarnings("unchecked")
            Map<String, Object> args = (Map<String, Object>) arguments;

            TcSdkOptions options = new TcSdkOptions.Builder(this, new TcOAuthCallback() {
                @Override
                public void onSuccess(TcOAuthData data) {
                    Log.d(TAG, "Truecaller auth success: " + data.getAuthorizationCode());

                    if (eventSink != null) {
                        Map<String, Object> resultMap = Map.of(
                            "authorizationCode", data.getAuthorizationCode(),
                            "codeVerifier", codeVerifier
                        );
                        runOnUiThread(() -> eventSink.success(resultMap));
                    }
                }

                @Override
                public void onFailure(TcOAuthError error) {
                    Log.e(TAG, "Truecaller auth failure: " + error.getErrorMessage());

                    if (eventSink != null) {
                        Map<String, Object> errorMap = Map.of(
                            "errorCode", error.getErrorCode(),
                            "errorMessage", error.getErrorMessage()
                        );
                        runOnUiThread(() -> eventSink.error("AUTH_ERROR", error.getErrorMessage(), errorMap));
                    }
                }

                @Override
                public void onVerificationRequired(TcOAuthError error) {
                    Log.w(TAG, "Verification required: " + error.getErrorMessage());
                }
            })
            .buttonColor(Color.parseColor((String) args.get("buttonColor")))
            .buttonTextColor(Color.parseColor((String) args.get("buttonTextColor")))
            .ctaText(TcSdkOptions.CTA_TEXT_CONTINUE)
            .buttonShapeOptions(TcSdkOptions.BUTTON_SHAPE_ROUNDED)
            .footerType(TcSdkOptions.FOOTER_TYPE_ANOTHER_METHOD)
            .consentHeadingOption(TcSdkOptions.SDK_CONSENT_HEADING_LOG_IN_TO)
            .build();

            TcSdk.init(options);
            Log.d(TAG, "Truecaller SDK initialized successfully");
            result.success(null);

        } catch (Exception e) {
            Log.e(TAG, "SDK initialization error: " + e.getMessage(), e);
            result.error("INIT_ERROR", e.getMessage(), null);
        }
    }

    private void invokeSdk(MethodChannel.Result result) {
        try {
            Log.d(TAG, "Invoking SDK...");

            SecureRandom random = new SecureRandom();
            BigInteger state = new BigInteger(130, random);
            String stateStr = state.toString(32);
            TcSdk.getInstance().setOAuthState(stateStr);
            Log.d(TAG, "OAuth state set: " + stateStr);

            TcSdk.getInstance().setOAuthScopes(new String[]{"profile", "phone", "email"});
            Log.d(TAG, "OAuth scopes set");

            codeVerifier = CodeVerifierUtil.Companion.generateRandomCodeVerifier();
            String codeChallenge = CodeVerifierUtil.Companion.getCodeChallenge(codeVerifier);

            Log.d(TAG, "Code verifier generated: " + codeVerifier);
            Log.d(TAG, "Code challenge generated: " + codeChallenge);

            if (codeChallenge != null) {
                TcSdk.getInstance().setCodeChallenge(codeChallenge);
            }

            TcSdk.getInstance().getAuthorizationCode((FragmentActivity) this);
            Log.d(TAG, "Authorization request initiated");
            result.success(null);

        } catch (Exception e) {
            Log.e(TAG, "Error invoking SDK: " + e.getMessage(), e);
            result.error("INVOKE_ERROR", e.getMessage(), null);
        }
    }

    private void isSdkUsable(MethodChannel.Result result) {
        try {
            boolean usable = TcSdk.getInstance().isOAuthFlowUsable();
            Log.d(TAG, "isOAuthFlowUsable: " + usable);
            result.success(usable);
        } catch (Exception e) {
            Log.e(TAG, "Error checking SDK usability: " + e.getMessage(), e);
            result.error("CHECK_ERROR", e.getMessage(), null);
        }
    }
}
