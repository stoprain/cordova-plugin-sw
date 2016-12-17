import Foundation

@objc(cordova_plugin_sw) class cordova_plugin_sw : CDVPlugin {
    
    func greet(command: CDVInvokedUrlCommand) {
        print(">>>> STARTED SHOW")
    }

}
