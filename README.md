# twitter_login_v2

![Pub Version](https://img.shields.io/pub/v/twitter_login_v2)

Flutter Twitter Login Plugin

## Install

```
twitter_login_v2: ^0.0.1
```

## Android Configuration

### Add intent filters for incoming links

[/example/android/app/src/main/AndroidManifest.xm](https://github.com/0maru/twitter_login/blob/master/example/android/app/src/main/AndroidManifest.xml)

You need to replace the scheme with a Callback URLs.

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <!-- Accepts URIs that begin with "example://gizmos” -->
  <!-- Registered Callback URLs in TwitterApp -->
  <data android:scheme="example"
        android:host="gizmos" /> <!-- host is option -->
</intent-filter>
```

### Supporting the new Android plugins APIs

If you flutter created your project prior to version 1.12, you need to make sure to update your project in order to use the new Java Embedding API.  
Make use you have flutter_embedding v2 enabled. Add the following code on the manifest file inside <application> tag to enable embedding.  
Flutter wiki: [Upgrading pre 1.12 Android projects.](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

## iOS Configuration

### Add URLScheme

[/example/ios/Runner/Info.plist](https://github.com/0maru/twitter_login/blob/master/example/ios/Runner/Info.plist#L21)

You need to replace the example with a Callback URLs.

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Registered Callback URLs in TwitterApp -->
      <string>example</string>
    </array>
  </dict>
</array>
```

# Example of usage

```dart
final twitterLogin = TwitterLoginV2(
    clientId: "CLIENT_ID", /// Consumer API keys
    redirectURI: "REDIRECT_URI", /// Registered Callback URLs in TwitterApp
);

final accessToken = await twitterLogin.loginV2();
```
