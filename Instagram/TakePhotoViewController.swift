//
//  TakePhotoViewController.swift
//  Instagram
//
//  Created by Abha Vedula on 6/20/16.
//  Copyright © 2016 Abha Vedula. All rights reserved.
//

import UIKit
import Parse

class TakePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBOutlet weak var submittedLabel: UILabel!
    
    var chosenImage: UIImage?
    
    var caption: String?
    
    let picker = UIImagePickerController()

    
    
    @IBAction func submitButton(sender: AnyObject) {
        caption = captionField.text
        
        Post.postUserImage(imageView.image, withCaption: caption, withCompletion: nil)
        
        imageView.alpha = 0.3
        
        submittedLabel.alpha = 1
        
        
                
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    
    @IBAction func takePhoto(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        picker.modalPresentationStyle = .FullScreen
        presentViewController(picker,
                              animated: true,
                              completion: nil)
    }
    
    @IBAction func pickPhoto(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submittedLabel.alpha = 0
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
