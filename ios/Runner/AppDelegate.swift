import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if let controller = window.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "channel/text", binaryMessenger: controller.binaryMessenger)
            channel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                if call.method == "sendText" {
                    if let arguments = call.arguments as? [String: Any],
                       let text = arguments["text"] as? String {
                        let processedText = "\(text)"
                        result(processedText)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENT", message: "Text argument is missing", details: nil))
                    }
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
