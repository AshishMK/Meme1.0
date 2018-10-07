//
//  MemeEditorViewController.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 8/25/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{
    
    
    
    
    
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
    var topTextFieldInitialEdit = true
    var bottomTextFieldInitialEdit = true
    var memeIndex = -1
  
    
    
    // MARK : Setting Text Attributes
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2/* TODO: fill in appropriate Float */]
    
    
    // MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(self.topTextField, with: "TOP")
        configure(self.bottomTextField, with: "BOTTOM")
        if memeIndex == -1{
       
     resetPage()
        }
        else {
          
            setMeme()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setMeme(){
         let meme = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
        imageEditView.image = meme.originalImage
        shareButton.isEnabled = true
        self.originalImage = meme.originalImage
        self.memedImage = meme.memedImage
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        topTextFieldInitialEdit = true
        bottomTextFieldInitialEdit = true
    }
    
    func configure(_ textField: UITextField, with defaultText: String) {
        // TODO:- code to configure the textField
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = defaultText
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
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
       
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
       
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
       
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    //MARK: IBAction mehods
    @IBAction func pickImageFromLibrary(_ sender: Any) {
         pickAnImage(from: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
      pickAnImage(from: .camera)
    }
    
    func pickAnImage(from source: UIImagePickerControllerSourceType) {
        // TODO:- code to pick an image from source
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareMeme(_ sender: Any) {
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.memedImage =  generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage] , applicationActivities: nil)
        present(controller, animated: true)
            controller.completionWithItemsHandler = { activity, completed, items, error in
                self.topToolbar.isHidden = false
                self.bottomToolbar.isHidden = false
                self.navigationController?.isNavigationBarHidden = false
                if !completed {
                    // handle task not completed
                   return
                }
                self.save()
                self.dismiss(animated: true, completion: nil)
              
                let resultVC = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
                self.present(resultVC, animated: true, completion: nil)
                
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
        imageEditView.backgroundColor = UIColor.white
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        imageEditView.backgroundColor = UIColor.darkGray
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
        
    }
    
    func save() {
    
        let meme = Meme(topText: self.topTextField.text, bottomText: self.bottomTextField.text, originalImage: self.originalImage, memedImage: self.memedImage)
       (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
     // MARK: Text Field Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           self.view.endEditing(true)
        return false
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

