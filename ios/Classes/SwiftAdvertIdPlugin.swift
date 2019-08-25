import Flutter
import UIKit
import AdSupport

public class SwiftAdvertIdPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "advert_id", binaryMessenger: registrar.messenger())
    let instance = SwiftAdvertIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getAdvertisingId":
            var idfaString: String!
            let manager = ASIdentifierManager.shared()
            if manager.isAdvertisingTrackingEnabled {
                idfaString = manager.advertisingIdentifier.uuidString
            } else {
                idfaString = ""
            }
            result(idfaString)
        default:
            result(nil)
    }
  }
}
