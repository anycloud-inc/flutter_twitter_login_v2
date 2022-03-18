#import "TwitterLoginV2Plugin.h"
#if __has_include(<twitter_login_v2/twitter_login_v2-Swift.h>)
#import <twitter_login_v2/twitter_login_v2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twitter_login_v2-Swift.h"
#endif

@implementation TwitterLoginV2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTwitterLoginV2Plugin registerWithRegistrar:registrar];
}
@end
