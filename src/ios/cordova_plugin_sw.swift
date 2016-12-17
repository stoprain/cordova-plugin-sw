import Foundation

@objc(cordova_plugin_sw) class cordova_plugin_sw : CDVPlugin {
    
    func greet(_ command: CDVInvokedUrlCommand) {
        print(">>>> STARTED SHOW")
    }

}
