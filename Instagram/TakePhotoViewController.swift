//
//  TakePhotoViewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/20/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class TakePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBOutlet weak var submittedLabel: UILabel!
    
    var chosenImage: UIImage?
    
    var caption: String?
    
    let picker = UIImagePickerController()

    var count = 0
    
    @IBAction func submitButton(sender: AnyObject) {
        caption = captionField.text
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Post.postUserImage(imageView.image, withCaption: caption, withCompletion: nil)
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        imageView.alpha = 0.3
        
        submittedLabel.alpha = 1
        
        
                
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        submittedLabel.alpha = 0
        imageView.alpha = 1
        
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        picker.modalPresentationStyle = .FullScreen
        presentViewController(picker,
                              animated: true,
                              completion: nil)
    }
    
    @IBAction func pickPhoto(sender: AnyObject) {
        submittedLabel.alpha = 0
        imageView.alpha = 1

        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submittedLabel.alpha = 0
        imageView.alpha = 1

        picker.delegate = self
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .ScaleAspectFit
        imageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    
    
    @IBAction func getFilter(sender: AnyObject) {
        ////////filter
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let filters = ["CIPhotoEffectoChrome", "CISepiaTone", "CIVignette", "CIPhotoEffectoTransfer"]
        
        let inputImage = chosenImage
        let context = CIContext(options: nil)
        
        if let currentFilter = CIFilter(name: filters[count]) {
            let beginImage = CIImage(image: inputImage!)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)
            
            if let output = currentFilter.outputImage {
                let cgimg = context.createCGImage(output, fromRect: output.extent)
                let processedImage = UIImage(CGImage: cgimg)
                
                // do something interesting with the processed image
                let portraitImage  : UIImage = UIImage(CGImage: processedImage.CGImage! ,
                                                       scale: 1.0 ,
                                                       orientation: UIImageOrientation.Right)
                imageView.image = portraitImage
                
                
            }
        }
        
        print(filters[count])
        count += 1
        if count == filters.count {
            count = 0
        }
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
  
    @IBAction func noFilter(sender: AnyObject) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        imageView.image = chosenImage
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
