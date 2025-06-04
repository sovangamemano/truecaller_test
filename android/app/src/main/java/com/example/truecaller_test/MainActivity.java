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

public class MainActivity extends FlutterFragmentActivity {

    private static final String CHANNEL = "truecaller_sdk";
    private static final String EVENT_CHANNEL = "truecaller_sdk_events";
    private static EventChannel.EventSink eventSink;

    private String codeVerifier;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Method channel
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler((call, result) -> {
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
                        result.notImplemented();
                        break;
                }
            });

        // Event channel
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
            .setStreamHandler(new EventChannel.StreamHandler() {
                @Override
                public void onListen(Object arguments, EventChannel.EventSink sink) {
                    eventSink = sink;
                }

                @Override
                public void onCancel(Object arguments) {
                    eventSink = null;
                }
            });
    }

    private void initializeSdk(Object arguments, MethodChannel.Result result) {
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> args = (Map<String, Object>) arguments;

            TcSdkOptions options = new TcSdkOptions.Builder(this, new TcOAuthCallback() {
                @Override
                public void onSuccess(TcOAuthData data) {
                    if (eventSink != null) {
                        Map<String, Object> resultMap = Map.of(
                            "authorizationCode", data.getAuthorizationCode(),
                            "codeVerifier", codeVerifier
                        );
                        eventSink.success(resultMap);
                    }
                }

                @Override
                public void onFailure(TcOAuthError error) {
                    if (eventSink != null) {
                        Map<String, Object> errorMap = Map.of(
                            "errorCode", error.getErrorCode(),
                            "errorMessage", error.getErrorMessage()
                        );
                        eventSink.success(errorMap);
                    }
                }

                @Override
                public void onVerificationRequired(TcOAuthError error) {
                    // Optional
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
            result.success(null);

        } catch (Exception e) {
            result.error("INIT_ERROR", e.getMessage(), null);
        }
    }

    private void invokeSdk(MethodChannel.Result result) {
        try {
            SecureRandom random = new SecureRandom();
            BigInteger state = new BigInteger(130, random);
            TcSdk.getInstance().setOAuthState(state.toString(32));
            TcSdk.getInstance().setOAuthScopes(new String[]{"profile", "phone", "email"});

            codeVerifier = CodeVerifierUtil.Companion.generateRandomCodeVerifier();
            String codeChallenge = CodeVerifierUtil.Companion.getCodeChallenge(codeVerifier);

            if (codeChallenge != null) {
                TcSdk.getInstance().setCodeChallenge(codeChallenge);
            }

            TcSdk.getInstance().getAuthorizationCode((FragmentActivity) this);
            result.success(null);
        } catch (Exception e) {
            result.error("INVOKE_ERROR", e.getMessage(), null);
        }
    }

    private void isSdkUsable(MethodChannel.Result result) {
        try {
            boolean usable = TcSdk.getInstance().isOAuthFlowUsable();
            result.success(usable);
        } catch (Exception e) {
            result.error("CHECK_ERROR", e.getMessage(), null);
        }
    }
}
