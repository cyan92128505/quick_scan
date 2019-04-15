import Flutter
import UIKit
import AudioToolbox

enum EventSet: String {
    case READY = "charon_ready"
    case READY_INVOKE = "charon_ready_invoke"
    case EVENT_CHANNEL = "charon_event_channel"
    case DEEP_LINK = "charon.deep.link"
    case VIBRATE = "charon_vibrate"
}

public class SwiftQuickScanPlugin: NSObject, FlutterPlugin, FlutterStreamHandler{
    private var message = "";
    private var eventSink: FlutterEventSink? {
        willSet (eventChange) {
            print("event sink initial")
        }
        didSet {
            if eventSink != nil {
                sendEvent(type: EventSet.DEEP_LINK, message: message)
                print("event sink standby")
            }
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: EventSet.READY.rawValue, binaryMessenger: registrar.messenger())

        let instance = SwiftQuickScanPlugin()

        registrar.addApplicationDelegate(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let eventChannel = FlutterEventChannel(name: "\(EventSet.EVENT_CHANNEL.rawValue)",
            binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }

    override init() {
        super.init()
    }


    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "\(EventSet.READY_INVOKE.rawValue)":
            result("Hello from iOS")
        case "\(EventSet.VIBRATE.rawValue)":
            AudioServicesPlaySystemSound(1520)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }


    @nonobjc public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {

        if let url = launchOptions?[.url] as? URL {
            message = url.absoluteString
            print(message)
        }

        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        message = url.absoluteString
        sendEvent(type: EventSet.DEEP_LINK, message: message)

        return true
    }

    public func onListen(withArguments arguments: Any?,
        eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }

    private func sendEvent(type _type: EventSet, message _message: String) {
        guard let eventSink = eventSink else {
            return
        }

        eventSink("{\"TYPE\":\"\(_type.rawValue)\",\"MESSAGE\":\"\(_message)\"}");
    }
}
