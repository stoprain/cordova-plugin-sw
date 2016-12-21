import Foundation

@objc(cordova_plugin_sw) class cordova_plugin_sw : CDVPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var c: CDVInvokedUrlCommand!
    
    func album(_ command: CDVInvokedUrlCommand) {
        print("cordova_plugin_sw album")
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.viewController.present(picker, animated: true, completion: nil)
        
        self.c = command
    }
    
    func camera(_ command: CDVInvokedUrlCommand) {
        print("cordova_plugin_sw album")
        let code = command.arguments.first!
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .video
        picker.delegate = self
        self.viewController.present(picker, animated: true, completion: nil)
        
        self.c = command
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let path = "\(cache)/\(NSUUID().uuidString)"
        let url = URL(fileURLWithPath: path)
        do {
            try UIImageJPEGRepresentation(image, 0.8)?.write(to: url)
        } catch {
            
        }
        
        self.viewController.dismiss(animated: true, completion: nil)
        
        let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: [path])
        self.commandDelegate.send(r, callbackId: self.c.callbackId)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.viewController.dismiss(animated: true, completion: nil)
        
        let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
        self.commandDelegate.send(r, callbackId: self.c.callbackId)
    }

}
