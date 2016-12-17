import Foundation

@objc(cordova_plugin_sw) class cordova_plugin_sw : CDVPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var c: CDVInvokedUrlCommand!
    private var nv: UINavigationController!
    
    func album(_ command: CDVInvokedUrlCommand) {
        print("cordova_plugin_sw greet")
        
        self.nv = UINavigationController(rootViewController: UIViewController())
        UIApplication.shared.keyWindow?.addSubview(self.nv.view)
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        nv.present(picker, animated: false, completion: nil)
        
        self.c = command
    }
    
    func cleanup() {
        self.nv.dismiss(animated: false, completion: nil)
        self.nv.view.removeFromSuperview()
        self.nv = nil
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
        
        self.cleanup()
        
        let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: path)
        self.commandDelegate.send(r, callbackId: self.c.callbackId)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.cleanup()
        
        let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
        self.commandDelegate.send(r, callbackId: self.c.callbackId)
    }

}
