# Suppress missing security provider warnings
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Keep Truecaller SDK and okhttp3
-keep class com.truecaller.** { *; }
-dontwarn com.truecaller.**

# Optional: Keep okhttp3 (used under the hood)
-dontwarn okhttp3.**
