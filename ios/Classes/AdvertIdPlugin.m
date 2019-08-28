#import "AdvertIdPlugin.h"
#import <advert_id-Swift.h>

@implementation AdvertIdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAdvertIdPlugin registerWithRegistrar:registrar];
}
@end
