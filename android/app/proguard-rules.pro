# Firebase Core
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepclassmembers class com.google.firebase.** { *; }
-keepclassmembers class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Device Info Plus
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.common.**

# HTTP Client
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# GetX (Jika digunakan)
-keep class **.Transition { *; }
-keepclassmembers class **.Transition { *; }
-dontwarn **.Transition