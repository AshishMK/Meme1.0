//
//  DetailViewController.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 10/6/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
   
    var memeIndex:  Int!
    @IBOutlet weak var memeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
        let backButton = UIBarButtonItem()
        backButton.title = "Sent Memes"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
  }
    
    @objc func editMeme(){
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        memeEditorController.memeIndex = memeIndex
        self.navigationController!.popViewController(animated: false)
        self.present(memeEditorController, animated: true,completion: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        let meme = (UIApplication.shared.delegate as! AppDelegate).memes[memeIndex]
        memeImageView.image = meme.memedImage
      
    }
    

    

}
