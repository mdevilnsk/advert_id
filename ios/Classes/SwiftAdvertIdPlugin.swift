import Flutter
import UIKit
import AdSupport

public class SwiftAdvertIdPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "advert_id", binaryMessenger: registrar.messenger())
    let instance = SwiftAdvertIdPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    static let setLatestLinkKey = "latestLink"

    func setLatestLink(_ latestLink: String?) {

        willChangeValue(forKey: setLatestLinkKey)
        self.latestLink = latestLink
        didChangeValue(forKey: setLatestLinkKey)

        if eventSink {
            eventSink(self.latestLink)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL
        initialLink = url?.absoluteString
        latestLink = initialLink
        getDeferredLinks()
        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        latestLink = url.absoluteString
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            latestLink = userActivity.webpageURL?.absoluteString
            if !eventSink {
                initialLink = latestLink
            }
            return true
        }
        return false
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
        case "getInitialLink":
            result(initialLink)
        case "getLatestLink":
            result(self.lastestlink)
        default:
            result(FlutterMethodNotImplemented)
    }
  }

  func onListen(withArguments arguments: Any?, eventSink: FlutterEventSink) -> FlutterError? {
      self.eventSink = eventSink
      return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
      eventSink = nil
      return nil
  }

  public func getDeferredLinks(){
    AppLinkUtility.fetchDeferredAppLink({ url, error in
        NotificationCenter.default.post(name: NSNotification.Name("LOAD_FINISH"), object: url)

        if error != nil {
            if let error = error {
                print("Received error while fetching deferred app link \(error)")
            }
        }
        if url != nil {
            if let url = url {
                self.latestLink = url.getAbsoluteString
                //UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            self.showAlert(alertMessage: "received deeplink is nil")
        }
    })
  }
}
