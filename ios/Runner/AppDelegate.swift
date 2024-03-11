import UIKit
import Flutter
import FacebookShare


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let igShareChannel = FlutterMethodChannel(name: "com.mahitm.fragments/igShare",
                                                        binaryMessenger: controller.binaryMessenger)
    
    igShareChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
        if (call.method == "SHARE_IG") {
            guard let rawData = call.arguments else { result("ERROR"); return; }
            
            let rawDataTyped = rawData as! FlutterStandardTypedData
            let stickerBytes =  [UInt8](rawDataTyped.data)
            
            let stickerNSData: NSData = NSData(bytes: stickerBytes, length: stickerBytes.count);
            let stickerData = stickerNSData as Data;
            let sticker = UIImage(data: stickerData);
            
            print("Sharing to instagram");
            FragmentsShare().shareBackgroundAndStickerImageIG(sticker);
            print("Shared");
            
            result("SUCCESS");
        } else if (call.method == "SHARE_FB") {
            guard let rawData = call.arguments else { result("ERROR"); return; }
            
            let rawDataTyped = rawData as! FlutterStandardTypedData
            let stickerBytes =  [UInt8](rawDataTyped.data)
            
            let stickerNSData: NSData = NSData(bytes: stickerBytes, length: stickerBytes.count);
            let stickerData = stickerNSData as Data;
            let sticker = UIImage(data: stickerData);
            
            print("Sharing to Facebook");
            FragmentsShare().shareBackgroundAndStickerImageFB(sticker);
            print("Shared");
            
            result("SUCCESS");
        } else if (call.method == "SHARE_FB_DIALOG") {
            guard let rawData = call.arguments else { result("ERROR"); return; }
            
            let rawDataTyped = rawData as! FlutterStandardTypedData
            let stickerBytes =  [UInt8](rawDataTyped.data)
            
            let stickerNSData: NSData = NSData(bytes: stickerBytes, length: stickerBytes.count);
            let stickerData = stickerNSData as Data;
            let sticker = UIImage(data: stickerData)!;
            
            print("Opening Facebook Dialog");
            
            let photo = SharePhoto(
                   image: sticker,
                   isUserGenerated: true
               )
            var content = SharePhotoContent()
            content.photos = [photo]
            
            let dialog = ShareDialog(
                viewController: self.window.rootViewController,
                content: content,
                delegate: nil
            )
            dialog.show()
            
            result("SUCCESS");
        }
    });
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
