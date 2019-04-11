#import "QuickScanPlugin.h"
#import <quick_scan/quick_scan-Swift.h>

@implementation QuickScanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftQuickScanPlugin registerWithRegistrar:registrar];
}
@end
