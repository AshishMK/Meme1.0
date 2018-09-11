//
//  ViewController.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 8/25/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    //MARK : Struct
    struct Meme {
        var topText : String!
        var bottomText : String!
        var originalImage :UIImage!
        var memedImage :UIImage!
    }
    
    
    
    //MARK : Outlets
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageEditView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //MARK : Properties
    var memedImage :UIImage!
    var originalImage :UIImage!
    var isKeyBoardShowing : Bool = false
    var topTextFieldInitialEdit = true
    var bottomTextFieldInitialEdit = true
    var activeTextField: UITextField!
    
    
    // MARK : Setting Text Attributes
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2/* TODO: fill in appropriate Float */]
    
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        resetPage()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Keyboard height detction methods
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
  
    @objc func keyboardWillShow(_ notification:Notification) {
        if activeTextField == topTextField {
            return
        }
        if !isKeyBoardShowing {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        isKeyBoardShowing = false
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        isKeyBoardShowing = true
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    //MARK: IBAction mehods
    @IBAction func pickImageFromLibrary(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        let controller = UIAlertController()
        controller.title = "Discard the changes?"
        controller.message = "Do you really want to create new Meme?"
        let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
            self.resetPage()
        }
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        present(controller,animated: true, completion: nil)
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.memedImage =  generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage] , applicationActivities: nil)
        present(controller, animated: true) {
           self.save()
        }
        }
  
  
    
    // MARK: UIImagePicker Controller Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageEditView.image = image
            shareButton.isEnabled = true
            self.originalImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func generateMemedImage() -> UIImage {

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    func resetPage(){
        imageEditView.image = nil
        shareButton.isEnabled = false
        self.originalImage = nil
        topTextFieldInitialEdit = true
        bottomTextFieldInitialEdit = true
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    func save() {
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.originalImage, memedImage: self.memedImage)
    }
    
    
     // MARK: Text Field Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == topTextField && topTextFieldInitialEdit {
            topTextField.text = nil
            topTextFieldInitialEdit = false
        }
        else if textField == topTextField && topTextFieldInitialEdit {
            bottomTextField.text = nil
            bottomTextFieldInitialEdit = false
        }
  
  
        return true
    }
}

