import Foundation
import MobileCoreServices
import AVFoundation

@objc(cordova_plugin_sw) class cordova_plugin_sw : CDVPlugin, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum PlugInType {
        case Album
        case Camera
    }
    
    private var c: CDVInvokedUrlCommand!
    private var type = PlugInType.Album
    
    func album(_ command: CDVInvokedUrlCommand) {
        print("cordova_plugin_sw album")
        
        self.type = .Album
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.viewController.present(picker, animated: true, completion: nil)
        
        self.c = command
    }
    
    func camera(_ command: CDVInvokedUrlCommand) {
        print("cordova_plugin_sw album")
        
        self.type = .Camera
        
        let code = command.arguments.first!
        print("cordova_plugin_sw code \(code)")
        
        let picker = UIImagePickerController()
        picker.mediaTypes = [(kUTTypeMovie as NSString) as String]
        picker.sourceType = .camera
        picker.cameraCaptureMode = .video
        picker.allowsEditing = false
        picker.delegate = self
        picker.cameraDevice = .front
        self.viewController.present(picker, animated: true, completion: nil)
        
        self.c = command
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if self.type == .Album {
            
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
            
        } else if self.type == .Camera {
            let url = info[UIImagePickerControllerMediaURL] as! URL
            
            self.encodeVideo(videoURL: url)
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.viewController.dismiss(animated: true, completion: nil)
        
        let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
        self.commandDelegate.send(r, callbackId: self.c.callbackId)
    }
    
    func encodeVideo(videoURL: URL)  {
        let avAsset = AVURLAsset(url: videoURL, options: nil)
        
        let startDate = Date()
        
        //Create Export session
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
        exportSession.shouldOptimizeForNetworkUse = true
        
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        //Creating temp path to save the converted video
        
        let cache = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let filePath = "\(cache)/\(NSUUID().uuidString)"
        
        exportSession.outputURL = URL(fileURLWithPath: filePath)
        exportSession.outputFileType = AVFileTypeMPEG4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, 0)
        let range = CMTimeRangeMake(start, avAsset.duration)
        exportSession.timeRange = range
        
        exportSession.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession.status {
            case .failed:
                print("\(exportSession.error)")
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                let endDate = Date()
                
                let time = endDate.timeIntervalSince(startDate)
                print(time)
                print("Successful!")
                print("\(exportSession.outputURL)")
                
                DispatchQueue.main.async {
                    self.viewController.dismiss(animated: true, completion: nil)
                    
                    let r = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: [filePath])
                    self.commandDelegate.send(r, callbackId: self.c.callbackId)
                }
                
            default:
                break
            }
            
        })
        
    }

}
